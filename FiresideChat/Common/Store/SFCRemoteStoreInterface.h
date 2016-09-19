//
//  SFCRemoteStoreInterface.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;

@class NSManagedObject;

@protocol SFCRemoteStoreInterface <NSObject>

- (void)signUpWithPhoneNumber:(nonnull NSString *)phoneNumber email:(nonnull NSString *)email
					password:(nonnull NSString *)password
			 successCallback:(void (^__nullable)(void))successCallback
			   errorCallback:(void (^__nullable)(NSString * __nonnull errorMessage))errorCallback;

- (void)loginWithEmail:(nonnull NSString *)email
			  password:(nonnull NSString *)password
	   successCallback:(void (^__nullable)())successCallback
		 errorCallback:(void(^__nullable)(NSString * _Nonnull errorMessage))errorCallback;

- (void)startSynchronization;

- (void)storeInsertedManagedObjects:(nullable NSArray<NSManagedObject *> *)insertedObjects
					 updatedObjects:(nullable NSArray<NSManagedObject *> *)updatedObjects
					 andRemoveDeletedObjects:(nullable NSArray<NSManagedObject *> *)deletedObjects;

@end
