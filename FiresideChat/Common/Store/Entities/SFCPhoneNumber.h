//
//  SFCPhoneNumber.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;
@import CoreData;

@class SFCContact;
@class CNPhoneNumber;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kSFCPhoneNumberEntityName = @"SFCPhoneNumber";
@interface SFCPhoneNumber : NSManagedObject

+ (nonnull instancetype)phoneNumberWithContactPhoneNumber:(CNPhoneNumber *)contactPhoneNumber
							   andContactPhoneNumberOwner:(SFCContact *)ownerContact
												  andKind:(nullable NSString *)kind
								   inManagedObjectContext:(NSManagedObjectContext *)context;

// Insert code here to declare functionality of your managed object subclass
- (void)updatePhoneNumberWithCNPhoneNumber:(nonnull CNPhoneNumber *)phoneNumber
								andContact:(nullable SFCContact *)contact
								   andKind:(nullable NSString *)kind;


@end

NS_ASSUME_NONNULL_END

#import "SFCPhoneNumber+CoreDataProperties.h"
