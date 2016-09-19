//
//  SFCCoreDataStack.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;
@import CoreData;

@interface SFCCoreDataStack : NSObject

@property (nonnull, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonnull, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
//- (BOOL)saveMainContext:(NSError * _Nullable __autoreleasing * _Nullable)error;
- (void)purgeContext;
@end
