//
//  SFCMessage.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN
static NSString * const kSFCMessageEntityName = @"SFCMessage";
static NSString * const kSFCTimestampKey = @"timestamp";
static NSString * const kSFCSectionIdentifierKey = @"sectionIdentifier";

@class SFCChat;
@class SFCContact;
@interface SFCMessage : NSManagedObject

+ (nonnull instancetype)messageWithText:(nonnull NSString *)text timestamp:(nonnull NSDate *)timestamp
				 inManagedObjectContext:(nonnull NSManagedObjectContext *)managedObjectContext;


- (BOOL)isIncoming;

@end
NS_ASSUME_NONNULL_END

#import "SFCMessage+CoreDataProperties.h"
