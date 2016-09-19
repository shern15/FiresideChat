//
//  NSManagedObjectContext+SHSaveContext.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (SHSaveContext)

- (BOOL)shouldAttemptRecoveryIfCascadeDeleteRuleSaveError:(nullable NSError *)error;
- (BOOL)saveContext:(NSError * _Nullable __autoreleasing * _Nullable)error;

@end
