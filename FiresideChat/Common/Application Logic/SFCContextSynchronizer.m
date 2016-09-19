//
//  SFCContextSynchronizer.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import CoreData;
#import "SFCContextSynchronizer.h"
#import "SFCRemoteStoreInterface.h"

typedef NSDictionary<NSString *, NSSet<NSManagedObject *> *> SFCSetsDictionary;
@interface SFCContextSynchronizer()

@property (nonnull, nonatomic) NSManagedObjectContext *mainContext;
@property (nonnull, nonatomic) NSManagedObjectContext *backgroundContext;

@end

@implementation SFCContextSynchronizer
NSString * const kNotificationSenderKey = @"NotificationSender";

- (nonnull instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext andBackgroundContext:(NSManagedObjectContext *)backgroundContext
{
	if ((self = [super init])) {
		_mainContext = mainContext;
		_backgroundContext = backgroundContext;
		
		[[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(mainContextDidSave:)
													  name:NSManagedObjectContextDidSaveNotification
													object:_mainContext];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundContextDidSave:)
													 name:NSManagedObjectContextDidSaveNotification
												   object:_backgroundContext];

	}
	
	return self;
}

- (void)mainContextDidSave:(NSNotification *)notification
{
	[_backgroundContext performBlock:
	 ^{
		 NSArray<NSManagedObject *> *insertedObjects = [self objectsForKey:NSInsertedObjectsKey inSetsDictionary:notification.userInfo inManagedObjectContext:_backgroundContext];
		 NSArray<NSManagedObject *> *updatedObjects = [self objectsForKey:NSUpdatedObjectsKey inSetsDictionary:notification.userInfo inManagedObjectContext:_backgroundContext];
		 NSArray<NSManagedObject *> *deletedObjects = [self objectsForKey:NSDeletedObjectsKey inSetsDictionary:notification.userInfo inManagedObjectContext:_backgroundContext];
		 //We make sure we sync the changes to the firebase server before we merge with our local database
		 //the changes to our background context to make sure the server records reflect the current state
		 //of the objects (i.e. chats, messages, etc) for this user
		 if (_remoteStore) {
			 [_remoteStore storeInsertedManagedObjects:insertedObjects updatedObjects:updatedObjects andRemoveDeletedObjects:deletedObjects];
		 }
		 [_backgroundContext mergeChangesFromContextDidSaveNotification:notification];
	 }];
}

- (void)backgroundContextDidSave:(NSNotification *)notification
{
	[_mainContext performBlock:
//	[_mainContext performBlockAndWait:
	 ^{
		 [[self objectsForKey:NSUpdatedObjectsKey inSetsDictionary:notification.userInfo inManagedObjectContext:_mainContext]
		  enumerateObjectsUsingBlock:^(NSManagedObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
		  {
			  [obj willAccessValueForKey:nil];
		  }];

		 [_mainContext mergeChangesFromContextDidSaveNotification:notification];
	}];
}

- (NSArray<NSManagedObject *> *)objectsForKey:(NSString *)key
							 inSetsDictionary:(SFCSetsDictionary *)setsDictionary
					   inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSSet<NSManagedObject *> *set = setsDictionary[key] ? setsDictionary[key] : [NSSet new];
	NSArray<NSManagedObject *> *objects = set.allObjects;
	NSMutableArray *objectsMutableArray = [NSMutableArray new];
	
	[objects enumerateObjectsUsingBlock:^(NSManagedObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[objectsMutableArray addObject:[context objectWithID:obj.objectID]];
	}];
	
	return objectsMutableArray;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:_mainContext];
	[[NSNotificationCenter defaultCenter] removeObserver:_backgroundContext];
}

@end
