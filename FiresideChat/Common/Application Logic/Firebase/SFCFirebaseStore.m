//
//  SFCFirebaseStore.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import CoreData;

#import <Firebase/Firebase.h>
#import "SFCFirebaseStore.h"
#import "SFCContact+SFCFirebaseModel.h"
#import "SFCChat+SFCFirebaseModel.h"
#import "NSUserDefaults+SHStoredUserDefaults.h"
#import "NSManagedObjectContext+SHSaveContext.h"

@interface SFCFirebaseStore()

@property (nonnull, nonatomic) NSManagedObjectContext *context;
@property (nonnull, nonatomic) FIRDatabaseReference *databaseRoot;
@property (nonnull, nonatomic) FIRAuth *firebaseAuth;
@property (nonatomic) BOOL synchronizationStarted;

@end

@implementation SFCFirebaseStore
static NSString * const kChatsKey = @"chat";
static NSString * const kMessagesKey = @"messages";

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
	if ((self = [super init])) {
		_context = context;
		_databaseRoot = [[FIRDatabase database] reference];
		_firebaseAuth = [FIRAuth auth];
		//_synchronizationStarted = NO;
	}
	
	return self;
}

- (BOOL)hasAuth {
	return (_firebaseAuth.currentUser != nil);
}

- (void)unauth {
	NSError *error;
	[_firebaseAuth signOut:&error];
	if(error) {
		NSLog(@"\n\nError sigining out user:\n%@", error);
	}
}

- (void)uploadManagedObject:(NSManagedObject *)object {
	if([object conformsToProtocol:@protocol(SFCFirebaseModel)]) {
		id<SFCFirebaseModel> firebaseModel = (id<SFCFirebaseModel>)object;
		[firebaseModel uploadToFirebaseRoot:_databaseRoot withContext:_context];
	}
}

- (void)removeManagedObject:(NSManagedObject *)object {
	if([object conformsToProtocol:@protocol(SFCFirebaseModel)]) {
		id<SFCFirebaseModel> firebaseModel = (id<SFCFirebaseModel>)object;
		if([firebaseModel respondsToSelector:@selector(removeFromFirebaseRoot:withContext:)]) {
			[firebaseModel removeFromFirebaseRoot:_databaseRoot withContext:_context];
		}
	}
}

//MARK: Helper Methods

- (NSArray<SFCContact *> *)fetchAppContacts
{
	NSError *fetchError;
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCContactEntityName];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"storageId != nil"];
	NSArray<SFCContact *> *fetchResults = [_context executeFetchRequest:fetchRequest error:&fetchError];
	
	if (fetchError) {
		NSLog(@"\n\nError fetching App Contacts:\n\n%@\n",fetchError.localizedDescription);
		return @[];
	}
	
	return fetchResults;
}

@end

@implementation SFCFirebaseStore (SFCRemoteStoreInterface)

- (void)startSynchronization {
	if(!_synchronizationStarted) {
		_synchronizationStarted = YES;
		[_context performBlock:^{
			[self observeChats];
			[self observeContactStatuses];
		}];
	}
}

- (void)storeInsertedManagedObjects:(NSArray<NSManagedObject *> *)insertedObjects updatedObjects:(NSArray<NSManagedObject *> *)updatedObjects andRemoveDeletedObjects:(NSArray<NSManagedObject *> *)deletedObjects
{
	for (NSManagedObject *object in insertedObjects) {
		[self uploadManagedObject:object];
	}
	for (NSManagedObject *object in deletedObjects) {
		[self removeManagedObject:object];
	}
	[_context performBlock:^{
		NSError *error;
		BOOL saveSuccessful = [_context saveContext:&error];
		if (!saveSuccessful) {
			NSLog(@"Error saving context in %@: \n%@\n",NSStringFromSelector(_cmd), error);
		}

	}];
}

- (void)signUpWithPhoneNumber:(NSString *)phoneNumber email:(NSString *)email password:(NSString *)password successCallback:(void (^)(void))successCallback errorCallback:(void (^)(NSString * _Nonnull))errorCallback
{
	[_firebaseAuth createUserWithEmail:email password:password completion:
	 ^(FIRUser * _Nullable user, NSError * _Nullable error) {
		 if (error) {
			 NSLog(@"\n\nError Creating user in Firebase with \nPhoneNumber: %@ \nEmail: %@\nPassword: %@\n\n%@\n", phoneNumber, email, password, error.localizedDescription);
			 if (errorCallback) {
				 errorCallback(error.description);
			 }
		 }
		 else if (!user) {
			 errorCallback(@"No userData returned from registration.\nPlease try again later!");
		 }
		 else {
			 NSDictionary *newUser = @{
									   @"phoneNumber" : phoneNumber
									   };
			 
			 [NSUserDefaults setCurrentPhoneNumber:phoneNumber];
			 NSString *uid = user.uid;
			 [[[_databaseRoot
				child:@"users"]
			   child:uid]
			  setValue:newUser];
			 
			 successCallback();
		 }
	 }];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password successCallback:(void (^)())successCallback errorCallback:(void (^ _Nullable)(NSString * _Nonnull))errorCallback
{
	[_firebaseAuth signInWithEmail:email password:password completion:
	 ^(FIRUser * _Nullable user, NSError * _Nullable error) {
		 if (error)
		 {
			 NSLog(@"\n\nError signing in User with\nEmail: %@, Password: %@ \n%@",email, password, error);
			 if (errorCallback) {
				 errorCallback(error.localizedDescription);
			 }
		 }
		 else {
			 NSString *userId = user.uid;
			 [[[_databaseRoot
				child:@"users"]
			   child:userId]
			  observeSingleEventOfType:FIRDataEventTypeValue
			  withBlock:^(FIRDataSnapshot *snapshot) {
				  NSDictionary *userData = snapshot.value;
				  NSString *phoneNumber = userData[@"phoneNumber"];
				  if (phoneNumber) {
					  [NSUserDefaults setCurrentPhoneNumber:phoneNumber];
					  successCallback();
				  } else {
					  errorCallback(@"No Registered Phone Number Found. Please Create a new account.");
				  }
			  }];
		 }
	 }];
}
- (void)observeContactStatuses {
	NSArray<SFCContact *> *contacts = [self fetchAppContacts];
	[contacts enumerateObjectsUsingBlock:
	 ^(SFCContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		 [obj observeStatusInFirebaseRoot:_databaseRoot withContext:_context];
	 }];
}

- (void)observeChats {
	[[_databaseRoot child:[NSString stringWithFormat:@"users/%@/chats",_firebaseAuth.currentUser.uid]]
	 observeEventType:FIRDataEventTypeChildAdded withBlock:
	 ^(FIRDataSnapshot *snapshot) {
		 [_context performBlock:^{
			 NSString *uid = snapshot.key;
			 SFCChat *chat = [SFCChat existingChatWithStorageId:uid inManagedObjectContext:_context];
			 if (!chat) {
				 chat = [SFCChat newChatWithStorageId:uid inContext:_context andInFirebaseRoot:_databaseRoot];
			 }
			 
			 [chat observeMessagesInFirebaseRoot:_databaseRoot usingManagedObjectContext:_context];
			 
			 if (chat.inserted) {
				 NSError *error;
				 BOOL saveSuccessful = [_context saveContext:&error];
				 
				 if (!saveSuccessful)
				 {
					 NSLog(@"\nError saving context in %@:\n\n%@\n", NSStringFromSelector(_cmd), error.localizedDescription);
				 }
			 }
		 }];

	}];
}

@end
