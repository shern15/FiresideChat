//
//  SFCChat+SFCFirebaseModel.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import <Firebase/Firebase.h>
#import "SFCChat+SFCFirebaseModel.h"
#import "SFCContact+SFCFirebaseModel.h"
#import "SFCPhoneNumber.h"
#import "SFCFirebaseStore.h"
#import "SFCContact.h"
#import "SFCMessage.h"
#import "NSManagedObjectContext+SHSaveContext.h"
#import "NSDate+SHDateComponents.h"
#import "NSUserDefaults+SHStoredUserDefaults.h"

@implementation SFCChat (SFCFirebaseModel)

+ (instancetype)newChatWithStorageId:(NSString *)storageId inContext:(NSManagedObjectContext *)context andInFirebaseRoot:(FIRDatabaseReference *)databaseRoot
{
	SFCChat *chat = [NSEntityDescription insertNewObjectForEntityForName:kSFCChatEntityName
												  inManagedObjectContext:context];
	
	chat.storageId = storageId;
	
	[[databaseRoot child:[NSString stringWithFormat:@"chats/%@/metadata",storageId]]
	 observeSingleEventOfType:FIRDataEventTypeValue withBlock:
	 ^(FIRDataSnapshot *snapshot) {
		 if([snapshot.value isKindOfClass:[NSNull class]]) {
			 return;
		 }
		 NSDictionary *dataDictionary = snapshot.value;
		 NSMutableDictionary *participantsDictionary = dataDictionary[@"participants"];
		 
		 [participantsDictionary removeObjectForKey:[NSUserDefaults currentPhoneNumber]];
		 
		 __block NSMutableArray<SFCContact *> *participants = [NSMutableArray new];
		 
		 [participantsDictionary.allKeys enumerateObjectsUsingBlock:
		  ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			  NSString *phoneNumberKey = obj;
			  SFCContact *participant = [SFCContact existingContactWithPhoneNumber:phoneNumberKey
															inManagedObjectContext:context
																 usingFirebaseRoot:databaseRoot];
			  
			  if(!participant) {
				  participant = [SFCContact newContactWithPhoneNumber:phoneNumberKey
											   inManagedObjectContext:context
													usingFirebaseRoot:databaseRoot];
			  }
			  
			  [participants addObject:participant];
		  }];
		 
		 NSString *chatName = dataDictionary[@"name"];
		 [context performBlock:^{
			 chat.participants = [NSSet setWithArray:participants];
			 chat.name = chatName;
			 
			 NSError *error;
			 BOOL saveSuccessful = [context saveContext:&error];
			 if (!saveSuccessful) {
				 NSLog(@"\nError saving modified chat with participants:\n\n%@\n", error.localizedDescription);
			 }
		 }];
		 
	 }];
	
	return chat;
}

- (void)uploadToFirebaseRoot:(FIRDatabaseReference *)databaseRoot withContext:(NSManagedObjectContext *)context
{
	if (self.storageId) {
		return;
	}
	FIRDatabaseReference *firebaseRef = [[databaseRoot child:@"chats"] childByAutoId];
	self.storageId = firebaseRef.key;
	NSMutableDictionary<NSString *, id> *data = [NSMutableDictionary new];
	data[@"id"] = firebaseRef.key;
	
	NSArray<SFCContact *> *participants = self.participants.allObjects;
	NSMutableDictionary<NSString *, NSNumber *> *numbersDict = [NSMutableDictionary new];
	numbersDict[[NSUserDefaults currentPhoneNumber]] = @YES;
	
	NSMutableArray<NSString *> *userIds = [NSMutableArray new];
	[userIds addObject:[FIRAuth auth].currentUser.uid];
	
	NSPredicate *registeredPredicate = [NSPredicate predicateWithFormat:@"isRegistered == YES"];
	
	[participants enumerateObjectsUsingBlock: ^(SFCContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
	 {
		 NSArray<SFCPhoneNumber *> *phoneNumbers = obj.phoneNumbers.allObjects;
		 SFCPhoneNumber *number = [phoneNumbers filteredArrayUsingPredicate:registeredPredicate].firstObject;
		 if (!number) {
			 return;
		 }
		 
		 numbersDict[number.value] = @YES;
		 [userIds addObject:obj.storageId];
	 }];
	
	data[@"participants"] = numbersDict;
	
	if (self.name) {
		data[@"name"] = self.name;
	}
	
	[firebaseRef setValue:@{@"metadata" : data}];
	
	[userIds enumerateObjectsUsingBlock:
	 ^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		 [[databaseRoot child:
		   [NSString stringWithFormat:@"users/%@/chats/%@",obj, firebaseRef.key]]
		  setValue:@YES];
	 }];
}

- (void)removeFromFirebaseRoot:(FIRDatabaseReference *)databaseRoot withContext:(NSManagedObjectContext *)context
{
	if(!self.storageId) {
		return;
	}
	FIRAuth *firebaseAuth = [FIRAuth auth];
	
	[[databaseRoot child:
	 [NSString stringWithFormat:@"users/%@/chats/%@", firebaseAuth.currentUser.uid, self.storageId]]
	 removeAllObservers];
	
	[[databaseRoot child:
	  [NSString stringWithFormat:@"users/%@/chats/%@", firebaseAuth.currentUser.uid, self.storageId]]
	 removeValue];
}

- (void)observeMessagesInFirebaseRoot:(FIRDatabaseReference *)databaseRoot usingManagedObjectContext:(NSManagedObjectContext *)context
{
	NSString *storageId = self.storageId;
	
	if (!storageId) {
		return;
	}
	
	NSTimeInterval lastMessageTimeInterval;
	NSDate *lastMessageTimestamp = self.lastMessageTime;
	if (lastMessageTimestamp) {
		lastMessageTimeInterval = [lastMessageTimestamp timeIntervalSince1970];
	} else {
		lastMessageTimeInterval = 1;
	}
	
	[[[[databaseRoot child:
	 [NSString stringWithFormat:@"chats/%@/messages",storageId]]
	   queryOrderedByKey] queryStartingAtValue:
	  [NSString stringWithFormat:@"%f",((lastMessageTimeInterval) * kSFCFirebaseTimestampModifier)]]
	 observeEventType:FIRDataEventTypeChildAdded withBlock:
	 ^(FIRDataSnapshot *snapshot) {
		 [context performBlock:^{
			 
			 if(snapshot.value == [NSNull null]) {
				 return;
			 }
			 
			 NSString *phoneNumber = (NSString *)snapshot.value[@"sender"];
			 
			 NSString *text = (NSString *)snapshot.value[@"message"];
			 if(!text) {
				 return;
			 }
			 
			 NSTimeInterval timeInterval = [snapshot.key doubleValue];
			 NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timeInterval/kSFCFirebaseTimestampModifier)];
			 
			 SFCContact *sender;
			 if(!phoneNumber || [phoneNumber isEqualToString:[NSUserDefaults currentPhoneNumber]])
			 {
				 sender = nil;
				 
				 //Check that this message isn't a message we just sent to the server ourselves
				 //by checking the milliseconds elapsed between the timestamp of the last message
				 //sent to this chat and the timestamp of the message just received from the server
				 if (self.lastMessageTime) {
					 NSTimeInterval millisecondsElapsed = [NSDate millisecondsFromDate:date toDate:self.lastMessageTime];
					 if(millisecondsElapsed < 1)
					 {
						 return;
					 }
				 }
			 }
			 else
			 {
				 sender = [SFCContact existingContactWithPhoneNumber:phoneNumber
											  inManagedObjectContext:context
												   usingFirebaseRoot:databaseRoot];
				 
				 if (!sender) {
					 sender = [SFCContact newContactWithPhoneNumber:phoneNumber
											 inManagedObjectContext:context
												  usingFirebaseRoot:databaseRoot];
				 }
				 
				 //TODO:Increase the count of unread messages by one
				 self.unreadMessagesInteger = self.unreadMessagesInteger +1;
			 }
			 
			 SFCMessage *message = [SFCMessage messageWithText:text timestamp:date inManagedObjectContext:context];
			 
			 message.sender = sender;
			 message.chat = self;
			 self.lastMessageTime = message.timestamp;
			 
			 NSError *error;
			 BOOL saveSuccessful = [context saveContext:&error];
			 
			 if (!saveSuccessful) {
				 NSLog(@"\nError saving messages from firebase to context:\n\n%@\n", error.localizedDescription);
			 }
		 }];
	 }];
}

- (SFCMessage *)existingMessageInChatWithTimestamp:(NSDate *)timestamp andSender:(SFCContact *)sender
{
	NSTimeInterval actualTimeInterval = [timestamp timeIntervalSince1970];
	NSTimeInterval startTimeInterval = (round(actualTimeInterval * 1000) - 1) / 1000;
	NSTimeInterval endTimeInterval = (round(actualTimeInterval * 1000) + 1) / 1000;
	
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTimeInterval];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTimeInterval];
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp >= %@ AND timestamp <= %@ AND sender == %@",startDate, endDate, sender];
	NSOrderedSet *filteredOrderedSet = [self.messages filteredOrderedSetUsingPredicate:predicate];
	
	return filteredOrderedSet.firstObject;
}

@end
