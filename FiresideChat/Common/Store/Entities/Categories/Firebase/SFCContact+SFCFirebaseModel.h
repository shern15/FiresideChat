//
//  SFCContact+SFCFirebaseModel.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCContact.h"
#import "SFCFirebaseModel.h"

@interface SFCContact (SFCFirebaseModel)<SFCFirebaseModel>

+ (nonnull instancetype)newContactWithPhoneNumber:(nonnull NSString *)phoneNumber
				   inManagedObjectContext:(nonnull NSManagedObjectContext *)context
						usingFirebaseRoot:(nonnull FIRDatabaseReference *)databaseRoot;

+ (nullable instancetype)existingContactWithPhoneNumber:(nonnull NSString *)phoneNumber
								 inManagedObjectContext:(nonnull NSManagedObjectContext *)context
									  usingFirebaseRoot:(nonnull FIRDatabaseReference *)databaseRoot;

- (void)updateContactIdInManagedObjectContext:(nonnull NSManagedObjectContext *)context
							 fromFirebaseRoot:(nonnull FIRDatabaseReference *)databaseRoot usingPhoneNumber:(nonnull NSString *)phoneNumber;

- (void)observeStatusInFirebaseRoot:(nonnull FIRDatabaseReference *)databaseRoot withContext:(nonnull NSManagedObjectContext *)context;



@end
