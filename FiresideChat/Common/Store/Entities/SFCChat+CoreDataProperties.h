//
//  SFCChat+CoreDataProperties.h
//  
//
//  Created by Sean Hernandez on 9/7/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SFCChat.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFCChat (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *lastMessageTime;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *storageId;
@property (nullable, nonatomic, retain) NSNumber *unreadMessagesCount;
@property (nullable, nonatomic, retain) NSOrderedSet<SFCMessage *> *messages;
@property (nullable, nonatomic, retain) NSSet<SFCContact *> *participants;

@end

@interface SFCChat (CoreDataGeneratedAccessors)

- (void)insertObject:(SFCMessage *)value inMessagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMessagesAtIndex:(NSUInteger)idx;
- (void)insertMessages:(NSArray<SFCMessage *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMessagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMessagesAtIndex:(NSUInteger)idx withObject:(SFCMessage *)value;
- (void)replaceMessagesAtIndexes:(NSIndexSet *)indexes withMessages:(NSArray<SFCMessage *> *)values;
- (void)addMessagesObject:(SFCMessage *)value;
- (void)removeMessagesObject:(SFCMessage *)value;
- (void)addMessages:(NSOrderedSet<SFCMessage *> *)values;
- (void)removeMessages:(NSOrderedSet<SFCMessage *> *)values;

- (void)addParticipantsObject:(SFCContact *)value;
- (void)removeParticipantsObject:(SFCContact *)value;
- (void)addParticipants:(NSSet<SFCContact *> *)values;
- (void)removeParticipants:(NSSet<SFCContact *> *)values;

@end

NS_ASSUME_NONNULL_END
