//
//  SFCChat.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Firebase;
#import "SFCChat.h"
#import "SFCMessage.h"
#import "SFCContact.h"
#import "SFCPhoneNumber.h"
#import "SFCFirebaseStore.h"
#import "NSUserDefaults+SHStoredUserDefaults.h"

@interface SFCChat ()
{
	BOOL _isActive;
}
@end

@implementation SFCChat
@synthesize isActive = _isActive;

- (void)awakeFromInsert
{
	[super awakeFromInsert];
	_isActive = NO;
}

- (void)awakeFromFetch {
	[super awakeFromFetch];
	if (_isActive) {
		self.unreadMessagesInteger = 0;
	}
}

+ (nonnull instancetype)chatInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	return [self chatWithName:@"" inManagedObjectContext:managedObjectContext];
}

+ (nonnull instancetype)chatWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	SFCChat *chat = [NSEntityDescription insertNewObjectForEntityForName:kSFCChatEntityName
												  inManagedObjectContext:managedObjectContext];
	chat.name = name;
	
	return chat;
	
}

+ (nonnull instancetype)chatWithContact:(SFCContact *)contact inManagedObjectContext:(NSManagedObjectContext *)context
{
	SFCChat *chat = [NSEntityDescription insertNewObjectForEntityForName:kSFCChatEntityName
												  inManagedObjectContext:context];
	
	[chat addParticipantsObject:contact];
	
	return chat;
}

+ (instancetype)existingChatWithContact:(SFCContact *)contact inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCChatEntityName];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ANY participants == %@ AND participants.@count == 1", contact];
	NSArray<SFCChat *> *fetchResults;
	NSError *fetchError;
	fetchResults = [context executeFetchRequest:fetchRequest error:&fetchError];
	
	if (fetchError) {
		NSLog(@"\nError fetching existing chat with contact: \n\n%@\n", fetchError);
		return nil;
	}
	
	return fetchResults.firstObject;
}

+ (instancetype)existingChatWithStorageId:(NSString *)storageId inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCChatEntityName];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"storageId == %@", storageId];
	
	NSError *fetchError;
	NSArray<SFCChat *> *fetchResults = [context executeFetchRequest:fetchRequest error:&fetchError];
	if (fetchError) {
		NSLog(@"\nError fetching existing chat in %@:\n\n%@\n", NSStringFromSelector(_cmd),fetchError.localizedDescription);
		return nil;
	}
	
	if(fetchResults.count < 1) {
		return nil;
	}
	
	return fetchResults.firstObject;
}

- (nullable SFCMessage *)lastMessage {
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kSFCMessageEntityName];
	request.predicate = [NSPredicate predicateWithFormat:@"chat = %@", self];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]];
	request.fetchLimit = 1;
	
	NSError *error;
	NSArray<SFCMessage *> *results = [self.managedObjectContext executeFetchRequest:request error:&error];
	if (error ) {
		NSLog(@"Error getting last message: %@", error.description);
		return nil;
	}
	
	return results.firstObject;
}

- (BOOL)isGroupChat {
	return self.participants.count > 1;
}

- (NSString *)chatName {
	return [self isGroupChat] ? self.name : self.participants.anyObject.fullName;
}

-(NSInteger)unreadMessagesInteger {
	return [self.unreadMessagesCount integerValue];
}

- (void)setUnreadMessagesInteger:(NSInteger)unreadMessagesCount {
	self.unreadMessagesCount = [NSNumber numberWithInteger:unreadMessagesCount];
}

- (void)addMessagesObject:(SFCMessage *)value
{
	[[self mutableOrderedSetValueForKey:@"messages"] addObject:value];
}

- (NSArray<NSString *> *)participantNames {
	NSString *currentUserPhoneNumber = [NSUserDefaults currentPhoneNumber];
	NSMutableArray<NSString *> *names = [NSMutableArray<NSString *> new];
	for (SFCContact *contact in self.participants) {
		if([contact hasPhoneNumberValue:currentUserPhoneNumber]) {
			continue;
		}
		
		NSString *contactName = [contact fullName];
		if(contactName) {
			[names addObject:contactName];
		} else {
			NSString *contactPhoneNumber = [contact phoneNumber];
			if(!contactPhoneNumber) {
				continue;
			}
			[names addObject:contactPhoneNumber];
		}
	}
	
	[names sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
	return names;
}

@end
