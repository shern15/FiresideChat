//
//  SFCMessage+SFCFirebaseModel.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Firebase;
#import "SFCMessage+SFCFirebaseModel.h"
#import "SFCChat+SFCFirebaseModel.h"
#import "SFCFirebaseStore.h"
#import "NSUserDefaults+SHStoredUserDefaults.h"

@implementation SFCMessage (SFCFirebaseModel)

- (void)uploadToFirebaseRoot:(FIRDatabaseReference *)databaseRoot withContext:(NSManagedObjectContext *)context
{
	if (!self.chat.storageId) {
		[self.chat uploadToFirebaseRoot:databaseRoot withContext:context];
	}
	
	NSString *chatStorageId = self.chat.storageId;
	
	NSDictionary *data = @{
						   @"message" : self.text,
						   @"sender" : [NSUserDefaults currentPhoneNumber]
						   };
	
	NSTimeInterval timeInterval = [self.timestamp timeIntervalSince1970] * kSFCFirebaseTimestampModifier;
	NSString *timeIntervalString = [NSString stringWithFormat:@"%lu", (unsigned long)timeInterval];
	[[databaseRoot child:
	  [NSString stringWithFormat:@"chats/%@/messages/%@",chatStorageId, timeIntervalString]]
	 setValue:data];
}

@end
