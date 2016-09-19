//
//  SFCContact.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;
@import CoreData;

@class SFCMessage;
@class SFCChat;
@class SFCPhoneNumber;
@class CNContact;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kSFCContactEntityName = @"SFCContact";
@interface SFCContact : NSManagedObject

+ (nullable instancetype)contactWithCNContact:(CNContact *)cnContact
					  inManagedObjectContext:(NSManagedObjectContext *)context;

+ (nullable instancetype)contactWithIdentifier:(nonnull NSString *)identifier
									 andFirstName:(nonnull NSString *)firstName
								  andLastName:(nonnull NSString *)lastName
					   inManagedObjectContext:(nonnull NSManagedObjectContext *)managedObjectContext;

- (nonnull NSString *)fullName;
- (void)setFullName:(nonnull NSString *)fullName;
- (nonnull NSString *)nameInitials;
- (BOOL)hasPhoneNumberValue:(nonnull NSString *)phoneNumberValue;
- (nullable NSString *)phoneNumber;

@end

NS_ASSUME_NONNULL_END

#import "SFCContact+CoreDataProperties.h"
