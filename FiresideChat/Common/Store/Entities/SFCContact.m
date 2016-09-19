//
//  SFCContact.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Firebase;
@import Contacts;
#import "SFCContact.h"
#import "SFCChat.h"
#import "SFCPhoneNumber.h"

@implementation SFCContact

+ (nullable instancetype)contactWithCNContact:(CNContact *)cnContact
					   inManagedObjectContext:(NSManagedObjectContext *)context
{
	return [self contactWithIdentifier:cnContact.identifier
						  andFirstName:cnContact.givenName
						   andLastName:cnContact.familyName
				inManagedObjectContext:context];
}

+ (nullable instancetype)contactWithIdentifier:(NSString *)identifier
									 andFirstName:(NSString *)firstName
								 andLastName:(NSString *)lastName
					  inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	//TODO: Refactor so that we can use phone number if no name is provided
	if (![SFCContact isValidName:firstName] && ![SFCContact isValidName:lastName]) {
		printf("\nInvalid first and last name submitted to initializer");
		return nil;
	}
	
	SFCContact *contact = [NSEntityDescription insertNewObjectForEntityForName:kSFCContactEntityName
												  inManagedObjectContext:managedObjectContext];
	contact.contactId = identifier;
	contact.firstName = firstName;
	contact.lastName = lastName;
	
	return contact;
}

- (NSString *)sortLetter {
	unichar letter = [self.firstName characterAtIndex:0];
	NSString *string;
	
	if([[NSCharacterSet punctuationCharacterSet] characterIsMember:letter] || letter == ' ') {
		string = @"#";
	} else {
		string = [NSString stringWithCharacters:&letter length:1];
	}
	
	return string;
}

- (NSString *)nameInitials
{
	unichar firstNameInitial = 0;
	unichar lastNameInitial = 0;
	
	if (self.firstName) {
		firstNameInitial = [self.firstName characterAtIndex:0];

	}
	
	if (self.lastName) {
		lastNameInitial = [self.lastName characterAtIndex:0];
	}
	
	NSCharacterSet *alphaNumericSet = [NSCharacterSet alphanumericCharacterSet];
	
	if([alphaNumericSet characterIsMember:firstNameInitial] &&
	   [alphaNumericSet characterIsMember:lastNameInitial]) {
		return [NSString stringWithFormat:@"%c%c", firstNameInitial, lastNameInitial];
	}
	
	else if ([alphaNumericSet characterIsMember:firstNameInitial]) {
		return [NSString stringWithFormat:@"%c", firstNameInitial];
	}
	
	else if ([alphaNumericSet characterIsMember:lastNameInitial]) {
		return [NSString stringWithFormat:@"%c", lastNameInitial];
	}
	
	return @"";
}

- (NSString *)fullName {
	[self willAccessValueForKey:@"fullName"];
	if(!self.firstName && !self.lastName) {
		//If there's no name on the user, use phone number
		// as name for identification purposes
		return [self phoneNumber];
	}
	
	if(!self.firstName || !self.lastName) {
		if(self.firstName) {
			return self.firstName;
		}
		
		else if(self.lastName) {
			return self.lastName;
		}
	}
	
	
	
	NSString *fullName = [@[self.firstName, self.lastName] componentsJoinedByString:@" "];
	
	[self didAccessValueForKey:@"fullName"];
	
	return fullName;
}

- (void)setFullName:(NSString *)fullName {
	if(![SFCContact isValidName:fullName]) {
		return;
	}
	NSArray<NSString *> *names = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	[self willChangeValueForKey:@"fullName"];
	
	self.firstName = names.firstObject;
	self.lastName = names.lastObject;
	
	[self didChangeValueForKey:@"fullName"];
}

- (void)setFirstName:(NSString *)firstName {
	if (![SFCContact isValidName:firstName]) {
		printf("\nFirst name is invalid");
		return;
	}
	
	[self willChangeValueForKey:@"firstName"];
	[self willChangeValueForKey:@"fullName"];
	
	[self setPrimitiveValue:firstName forKey:@"firstName"];
	
	[self didChangeValueForKey:@"firstName"];
	[self didChangeValueForKey:@"fullName"];
}

- (void)setLastName:(NSString *)lastName {
	if (![SFCContact isValidName:lastName]) {
		return;
	}
	
	[self willChangeValueForKey:@"lastName"];
	[self willChangeValueForKey:@"fullName"];
	
	[self setPrimitiveValue:lastName forKey:@"lastName"];
	
	[self didChangeValueForKey:@"lastName"];
	[self didChangeValueForKey:@"fullName"];
}

+ (BOOL)isValidName:(NSString *)name {
	if (name.length == 0) {
		return false;
	}
	
	return true;
}

- (BOOL)hasPhoneNumberValue:(NSString *)phoneNumberValue {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.value == %@", phoneNumberValue];
	return [self.phoneNumbers filteredSetUsingPredicate:predicate].count > 0;
}

- (NSString *)phoneNumber {
	SFCPhoneNumber *phoneNumber = [self.phoneNumbers anyObject];
	return phoneNumber ? phoneNumber.value : @"";
}

- (NSString *)description {
	return [NSString stringWithFormat:@"\nContactID: %@\nFullName: %@\n isFavorite:%d\n",self.contactId, self.fullName, self.isFavorite];
}

@end
