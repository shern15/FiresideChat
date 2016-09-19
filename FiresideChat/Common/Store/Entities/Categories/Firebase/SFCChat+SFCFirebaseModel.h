//
//  SFCChat+SFCFirebaseModel.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCChat.h"
#import "SFCFirebaseModel.h"

@class Firebase;

@interface SFCChat (SFCFirebaseModel)<SFCFirebaseModel>

+ (nonnull instancetype)newChatWithStorageId:(nonnull NSString *)storageId
								   inContext:(nonnull NSManagedObjectContext *)context
						   andInFirebaseRoot:(nonnull FIRDatabaseReference *)databaseRoot;

- (void)observeMessagesInFirebaseRoot:(nonnull FIRDatabaseReference *)databaseRoot
			usingManagedObjectContext:(nonnull NSManagedObjectContext *)context;

@end
