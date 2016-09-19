//
//  NSManagedObjectContext+SHSaveContext.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "NSManagedObjectContext+SHSaveContext.h"

@implementation NSManagedObjectContext (SHSaveContext)

//Call this function from the appropriate performBlock or performBlockAndWait block
//based on concurrency type
- (BOOL)saveContext:(NSError * _Nullable __autoreleasing * _Nullable)error {

	//Attempt the save. If its not successful then check if its
	//a validation error we might be able to recover from.
	BOOL saveSuccessful = [self save:error];
	if (!saveSuccessful) {
		if ([self shouldAttemptRecoveryIfCascadeDeleteRuleSaveError:*error]) {
			//If we might be able to recover, attempt to save again.
			saveSuccessful = [self save:error];
		}
	}
	return saveSuccessful;
}

- (BOOL)shouldAttemptRecoveryIfCascadeDeleteRuleSaveError:(nullable NSError *)error
{
	//Check that its a validation error.
	if ([error code] != NSManagedObjectValidationError) return NO;
	if (![[error domain] isEqualToString:NSCocoaErrorDomain]) return NO;
	
	//Get reference to object that threw the error.
	NSManagedObject *object = [[error userInfo] objectForKey:NSValidationObjectErrorKey];
	if (![object isKindOfClass:[NSManagedObject class]]) return NO;
	
	NSString *key = [[error userInfo] objectForKey:NSValidationKeyErrorKey];
	if (!key) return NO;
	
	// Check that its a relationship to another managed object.
	NSRelationshipDescription *relationship = [[[object entity] relationshipsByName] objectForKey:key];
	if (!relationship) return NO;
	
	// Check to see if the target managed object has been deleted.
//	NSManagedObject *invalidValue = [object valueForKey:key];
//	if (![invalidValue isDeleted] && [invalidValue managedObjectContext]) return NO;
	
	// Check that if we delete the target object, do we also delete the object that threw the error
	// i.e Is there a Cascade delete rule on the inverse relationship
	if ([[relationship inverseRelationship] deleteRule] != NSCascadeDeleteRule) return NO;
	
	// Delete the object, and return a flag indicating we should to attempt to resave.
	NSLog(@"Deleting object that looks like Cascade delete rule for key %@ wasn't honoured: %@", key, object);
	[[object managedObjectContext] deleteObject:object];
	return YES;
}

@end
