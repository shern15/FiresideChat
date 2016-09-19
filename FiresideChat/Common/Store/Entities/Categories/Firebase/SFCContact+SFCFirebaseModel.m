//
//  SFCContact+SFCFirebaseModel.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//
@import CoreData;
#import <Firebase/Firebase.h>
#import "NSManagedObjectContext+SHSaveContext.h"
#import "SFCContact+SFCFirebaseModel.h"
#import "SFCPhoneNumber.h"

@implementation SFCContact (SFCFirebaseModel)

+ (instancetype)newContactWithPhoneNumber:(NSString *)phoneNumberValue
				   inManagedObjectContext:(NSManagedObjectContext *)context
						usingFirebaseRoot:(FIRDatabaseReference *)databaseRoot
{
	SFCContact *contact = [NSEntityDescription insertNewObjectForEntityForName:kSFCContactEntityName
														inManagedObjectContext:context];
	
	SFCPhoneNumber *phoneNumber = [NSEntityDescription insertNewObjectForEntityForName:kSFCPhoneNumberEntityName
																inManagedObjectContext:context];
	
	phoneNumber.contact = contact;
	phoneNumber.isRegistered = YES;
	phoneNumber.value = phoneNumberValue;
	
	[contact updateContactIdInManagedObjectContext:context
								  fromFirebaseRoot:databaseRoot
								  usingPhoneNumber:phoneNumberValue];
	
	return contact;
}

+ (instancetype)existingContactWithPhoneNumber:(NSString *)phoneNumber
						inManagedObjectContext:(NSManagedObjectContext *)context
							 usingFirebaseRoot:(FIRDatabaseReference *)databaseRoot
{
	NSError *fetchError;
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCPhoneNumberEntityName];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"value == %@", phoneNumber];
	
	NSArray<SFCPhoneNumber *> *fetchResults = [context executeFetchRequest:fetchRequest error:&fetchError];
	
	if(fetchError) {
		NSLog(@"\nError fetching phone numbers in %@:\n\n%@",NSStringFromSelector(_cmd), fetchError.localizedDescription);
		return nil;
	}
	
	if(fetchResults.count < 1) {
		return nil;
	}
	
	SFCContact *contact = [fetchResults firstObject].contact;
	if(!contact.storageId) {
		[contact updateContactIdInManagedObjectContext:context
									  fromFirebaseRoot:(FIRDatabaseReference *)databaseRoot
									  usingPhoneNumber:phoneNumber];
	}
	return contact;
}

- (void)uploadToFirebaseRoot:(FIRDatabaseReference *)databaseRoot withContext:(NSManagedObjectContext *)context
{
	if (!self.phoneNumbers) {
		return;
	}
	
	NSArray<SFCPhoneNumber *> *phoneNumbers = self.phoneNumbers.allObjects;
	[phoneNumbers enumerateObjectsUsingBlock:
	 ^(SFCPhoneNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
	 {
		 [[[[databaseRoot child:@"users"]
			queryOrderedByChild:@"phoneNumber"]
		   queryEqualToValue:obj.value]
		  observeSingleEventOfType:FIRDataEventTypeValue withBlock:
		  ^(FIRDataSnapshot *snapshot) {
			  NSDictionary *userData = snapshot.value;
			  
			  if ([userData isKindOfClass:[NSNull class]]) {
				  return;
			  }
			  
			  NSString *uid = userData.allKeys.firstObject;
			  [context performBlock:
			   ^{
				   self.storageId = uid;
				   obj.isRegistered = YES;
				   NSError *error;
				   BOOL saveSuccessful = [context saveContext:&error];
				   if (!saveSuccessful) {
					   NSLog(@"\nError saving Context In uploadToFirebaseRoot\n\n%@\n",error);
					   return;
				   }
				   [self observeStatusInFirebaseRoot:databaseRoot withContext:context];
			   }];
		  }];
	 }];
}

- (void)updateContactIdInManagedObjectContext:(NSManagedObjectContext *)context
							 fromFirebaseRoot:(FIRDatabaseReference *)databaseRoot usingPhoneNumber:(NSString *)phoneNumber
{
	[[[[databaseRoot child:@"users"]
	   queryOrderedByChild:@"phoneNumber"]
	  queryEqualToValue:phoneNumber]
	 observeSingleEventOfType:FIRDataEventTypeValue withBlock:
	 ^(FIRDataSnapshot *snapshot) {
		 NSDictionary *userData = snapshot.value;
		 if ([userData isKindOfClass:[NSNull class]]) {
			 return;
		 }
		 NSString *userId = userData.allKeys.firstObject;
		 [context performBlock:^{
			 NSError *error;
			 self.storageId = userId;
			 BOOL saveSuccessful = [context saveContext:&error];
			 
			 if (!saveSuccessful) {
				 NSLog(@"error saving context after updating contact id:\n\n%@\n",error.localizedDescription);
			 }
		 }];
	 }];
}

- (void)observeStatusInFirebaseRoot:(FIRDatabaseReference *)databaseRoot withContext:(NSManagedObjectContext *)context
{
	if (!self.storageId) {
		return;
	}
	
	[[databaseRoot child:
	  [NSString stringWithFormat:@"users/%@/status", self.storageId]]
	 observeEventType:FIRDataEventTypeValue withBlock:
	 ^(FIRDataSnapshot *snapshot) {
		 if (snapshot.value == [NSNull null]) {
			 return;
		 }
		 
		 [context performBlock:
		  ^{
			  self.status = snapshot.value;
			  NSError *error;
			  BOOL saveSuccessful = [context saveContext:&error];
			  if (!saveSuccessful) {
				  NSLog(@"\nError saving context in observeStatusInFirebaseRoot:\n%@\n", error.localizedDescription);
			  }
		  }];
	 }];
}

@end
