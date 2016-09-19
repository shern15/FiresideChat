//
//  SFCChat.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;
@import CoreData;

@class SFCMessage;
@class SFCContact;
NS_ASSUME_NONNULL_BEGIN

static NSString *const kSFCChatEntityName = @"SFCChat";

@interface SFCChat : NSManagedObject

@property (nonatomic) BOOL isActive;

+ (nonnull instancetype)chatInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;


+ (nonnull instancetype)chatWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (nonnull instancetype)chatWithContact:(nonnull SFCContact *)contact inManagedObjectContext:(nonnull NSManagedObjectContext *)context;

+ (nullable instancetype)existingChatWithContact:(nonnull SFCContact *)contact inManagedObjectContext:(nonnull NSManagedObjectContext *)context;

+ (nullable instancetype)existingChatWithStorageId:(NSString *)storageId inManagedObjectContext:(NSManagedObjectContext *)context;

- (nullable SFCMessage *)lastMessage;

- (BOOL)isGroupChat;

- (nonnull NSArray<NSString *> *)participantNames;

- (NSInteger)unreadMessagesInteger;

- (void)setUnreadMessagesInteger:(NSInteger)unreadMessagesCount;

- (nullable NSString *)chatName;

@end
NS_ASSUME_NONNULL_END

#import "SFCChat+CoreDataProperties.h"
