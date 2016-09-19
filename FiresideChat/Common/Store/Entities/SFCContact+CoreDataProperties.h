//
//  SFCContact+CoreDataProperties.h
//  
//
//  Created by Sean Hernandez.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SFCContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFCContact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *contactId;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nonatomic) BOOL isFavorite;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *storageId;
@property (nullable, nonatomic, retain) NSSet<SFCChat *> *chats;
@property (nullable, nonatomic, retain) NSSet<SFCMessage *> *messages;
@property (nullable, nonatomic, retain) NSSet<SFCPhoneNumber *> *phoneNumbers;

@end

@interface SFCContact (CoreDataGeneratedAccessors)

- (void)addChatsObject:(SFCChat *)value;
- (void)removeChatsObject:(SFCChat *)value;
- (void)addChats:(NSSet<SFCChat *> *)values;
- (void)removeChats:(NSSet<SFCChat *> *)values;

- (void)addMessagesObject:(SFCMessage *)value;
- (void)removeMessagesObject:(SFCMessage *)value;
- (void)addMessages:(NSSet<SFCMessage *> *)values;
- (void)removeMessages:(NSSet<SFCMessage *> *)values;

- (void)addPhoneNumbersObject:(SFCPhoneNumber *)value;
- (void)removePhoneNumbersObject:(SFCPhoneNumber *)value;
- (void)addPhoneNumbers:(NSSet<SFCPhoneNumber *> *)values;
- (void)removePhoneNumbers:(NSSet<SFCPhoneNumber *> *)values;

@end

NS_ASSUME_NONNULL_END
