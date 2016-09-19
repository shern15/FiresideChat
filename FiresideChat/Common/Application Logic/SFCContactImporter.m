 //
//  SFCContactImporter.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCContactImporter.h"
#import "SFCContact.h"
#import "SFCPhoneNumber.h"
#import "NSManagedObjectContext+SHSaveContext.h"

@interface SFCContactImporter()

@property (nonnull, nonatomic) NSManagedObjectContext *context;
@property (nonnull, nonatomic) NSDate *lastCNNotificationTime;

@end

@implementation SFCContactImporter
typedef NSDictionary<NSString *, NSDictionary<NSString *, NSManagedObject *> *> SFCContactsPhoneNumbersDictionary;
static NSString * const kContactsKey = @"contacts";
static NSString * const kPhoneNumbersKey = @"phoneNumbers";

- (nonnull instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
	if ((self = [super init])) {
		_context = context;
	}
	
	return self;
}

- (void)fetchContacts {
	CNContactStore *contactStore = [CNContactStore new];
	[contactStore requestAccessForEntityType:CNEntityTypeContacts
	 completionHandler:
	 ^(BOOL granted, NSError * _Nullable error)
	{
		if (error) {
			NSLog(@"\nError Requesting Access to contacts: %@\n", error.description);
			return;
		}
		if (granted)
		{
			[self.context performBlock:
			 ^{
				 NSDictionary<NSString *, SFCContact *> *contacts;
				 NSDictionary<NSString *, SFCPhoneNumber *> *phoneNumbers;
				 
				 SFCContactsPhoneNumbersDictionary *contactsPhoneNumbersDict = [self fetchExisting];
				 if (contactsPhoneNumbersDict) {
					 contacts = contactsPhoneNumbersDict[kContactsKey] ? contactsPhoneNumbersDict[kContactsKey] : @{};
					 phoneNumbers = contactsPhoneNumbersDict[kPhoneNumbersKey] ? contactsPhoneNumbersDict[kPhoneNumbersKey] : @{};
				 } else {
					 contacts = @{};
					 phoneNumbers = @{};
				 }

				 CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc]
														initWithKeysToFetch:@[
																			  CNContactGivenNameKey,
																			  CNContactFamilyNameKey,
																			  CNContactPhoneNumbersKey
																			  ]];
				 NSError *fetchError;
				 [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&fetchError
													  usingBlock:
				  ^(CNContact * _Nonnull contact, BOOL * _Nonnull stop)
				  {
					  if (fetchError)
					  {
						  NSLog(@"\nError Fetching Contacts: %@", fetchError.description);
					  }
					  
					  SFCContact *coreDataContact;
					  
					  if(contacts[contact.identifier]) {
						  coreDataContact = contacts[contact.identifier];
					  } else {
						  coreDataContact = [SFCContact contactWithCNContact:contact
													  inManagedObjectContext:_context];
					  }
					  
					  if(!coreDataContact) {
						  return;
					  }
					  
					  
					  //MARK:Add Phone Numbers for contact
					  
					  for(CNLabeledValue *labeledValue in contact.phoneNumbers)
					  {
						  CNPhoneNumber *contactPhoneNumber = (CNPhoneNumber *)labeledValue.value;
						  if(phoneNumbers[contact.identifier]) {
							  SFCPhoneNumber *coreDataPhoneNumber = phoneNumbers[contactPhoneNumber.stringValue];
							  [coreDataPhoneNumber updatePhoneNumberWithCNPhoneNumber:contactPhoneNumber
																		   andContact:coreDataContact
																			  andKind:[CNLabeledValue localizedStringForLabel:labeledValue.label]];
							  
						  } else {
			
							  [SFCPhoneNumber phoneNumberWithContactPhoneNumber:contactPhoneNumber
													 andContactPhoneNumberOwner:coreDataContact
																		andKind:[CNLabeledValue localizedStringForLabel:labeledValue.label]
													 inManagedObjectContext:_context];
						  }
					  }
					  
					  if (coreDataContact.inserted) {
						  coreDataContact.isFavorite = YES;
					  }
					  //NSLog(@"\nContact Id: %@\n", coreDataContact.contactId);
					  
				  }];
				 NSError *error;
				 BOOL saveSuccessful = [_context saveContext:&error];
				 
				 if (!saveSuccessful) {
					 NSLog(@"\nError saving Contacts to context:\n %@", error);
					 
				 }
			}];
		}
	}];
}

- (SFCContactsPhoneNumbersDictionary *)fetchExisting
{
	NSMutableDictionary<NSString *, SFCContact *> *contactsDictionary = [NSMutableDictionary new];
	NSMutableDictionary<NSString *, SFCPhoneNumber *> *phoneNumbersDictionary = [NSMutableDictionary new];
	
	NSError *fetchError;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kSFCContactEntityName];
	fetchRequest.relationshipKeyPathsForPrefetching = @[kPhoneNumbersKey];
	
	NSArray<SFCContact *> *contactResultsArray = [_context executeFetchRequest:fetchRequest error:&fetchError];
	
	if(fetchError)
	{
		NSLog(@"\nError fetching existing contacts:\n %@",fetchError.description);
		return nil;
	}
	
	if (contactResultsArray) {
		for (SFCContact *contact in contactResultsArray)
		{
			if(!contact.contactId) {
				//MARK:- Safeguard for cases when contact has no contact id. In this case lets ignore the contact. -
				continue;
			}
			
			[contactsDictionary setObject:contact forKey:contact.contactId];
			for (SFCPhoneNumber *phoneNumber in contact.phoneNumbers)
			{
				[phoneNumbersDictionary setObject:phoneNumber forKey:phoneNumber.value];
			}
		}
	}
		
	return @{kContactsKey : contactsDictionary, kPhoneNumbersKey : phoneNumbersDictionary};
}

- (void)addObservers {
	[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressBookDidChangeNotification:)
												 name:CNContactStoreDidChangeNotification object:nil];
}

- (void)addressBookDidChangeNotification:(NSNotification *)notification {
	//MARK: Hack for addressBook API Notification Bug
	NSDate *now = [NSDate new];
	if (_lastCNNotificationTime &&
		[now timeIntervalSinceDate:_lastCNNotificationTime] <= 1) {
		return;
	}
	_lastCNNotificationTime = now;
	
	[self fetchContacts];
}

- (void)displayCannotAccessContactsAlert {
	UIAlertController *cannotAccessContactsAlert = [UIAlertController
													alertControllerWithTitle:@"Cannot Access Contacts"
													message:@"FiresideChat needs permission to access your contacts"
													preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	UIAlertAction *openSettings = [UIAlertAction actionWithTitle:@"Open Settings"
														   style:UIAlertActionStyleDefault
														 handler:^(UIAlertAction * _Nonnull action) {
															 [self openSettings];
														 }];
	
	[cannotAccessContactsAlert addAction:openSettings];
	[cannotAccessContactsAlert addAction:cancelAction];
}

- (void)openSettings {
	NSURL* url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
	[[UIApplication sharedApplication] openURL:url];
}

@end
