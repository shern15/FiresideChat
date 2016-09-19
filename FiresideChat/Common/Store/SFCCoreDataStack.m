//
//  SFCCoreDataStack.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCCoreDataStack.h"
//#import "NSManagedObjectContext+SHSaveContext.h"

@interface SFCCoreDataStack()

@property (nonnull, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonnull, nonatomic) NSURL *applicationDocumentsDirectory;
@property (nonnull, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonnull, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation SFCCoreDataStack
static NSString *const kModuleName = @"FiresideChat";

- (nonnull NSManagedObjectModel *)managedObjectModel {
	if (!_managedObjectModel) {
		NSURL *modelUrl = [[NSBundle mainBundle]
						   URLForResource:kModuleName withExtension:@"momd"];
		
		_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
	}
	
	return _managedObjectModel;
}

- (nonnull NSURL *)applicationDocumentsDirectory {
	if (!_applicationDocumentsDirectory) {
		_applicationDocumentsDirectory = [[NSFileManager defaultManager]
										  URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
	}
	
	return _applicationDocumentsDirectory;
}

- (nonnull NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (!_persistentStoreCoordinator) {
		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
									   initWithManagedObjectModel:self.managedObjectModel];
		
		NSString *pathComponent = [NSString stringWithFormat:@"%@.sqlite",kModuleName];
		NSURL *persistentStoreURL = [self.applicationDocumentsDirectory
									 URLByAppendingPathComponent:pathComponent];
		
		NSError *error;
		[_persistentStoreCoordinator
		 addPersistentStoreWithType:NSSQLiteStoreType
		 configuration:nil URL:persistentStoreURL
		 options:@{NSMigratePersistentStoresAutomaticallyOption: @YES,
				   NSInferMappingModelAutomaticallyOption: @YES}
		 error:&error];
		
		if (error) {
			NSLog(@"\n\nError Initializing persistent store coordinator:\n%@\n", error.userInfo);
			abort();
		}
	}
	
	return  _persistentStoreCoordinator;
}

- (nonnull NSManagedObjectContext *)managedObjectContext {
	if (!_managedObjectContext) {
		_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		_managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	}
	
	return _managedObjectContext;
}

//- (BOOL)saveMainContext:(NSError * _Nullable __autoreleasing * _Nullable)error
//{
//	return [self.managedObjectContext saveContext:error];
//}


- (void)purgeContext {
	NSArray<NSEntityDescription *> *entities = _managedObjectModel.entities;
	for (NSEntityDescription *entity in entities) {
		if(!entity.name) {
			continue;
		}
		NSError *deleteError;
		NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity.name];
		NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
		[_managedObjectContext executeRequest:deleteRequest error:&deleteError];
		if(deleteError) {
			NSLog(@"\n\nError deleting entities:\n%@\n",deleteError);
		}
	}
}

@end
