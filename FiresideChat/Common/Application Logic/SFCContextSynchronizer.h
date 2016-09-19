//
//  SFCContextSynchronizer.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;
@import CoreData;

@protocol SFCRemoteStoreInterface;

@interface SFCContextSynchronizer : NSObject

@property (nullable, nonatomic, weak) id<SFCRemoteStoreInterface> remoteStore;

- (nonnull instancetype)initWithMainContext:(nonnull NSManagedObjectContext *)mainContext
				  andBackgroundContext:(nonnull NSManagedObjectContext *)backgroundContextArray;

- (nonnull instancetype)init NS_UNAVAILABLE;

@end
