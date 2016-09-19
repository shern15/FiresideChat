//
//  SFCFirebaseStore.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;
#import "SFCRemoteStoreInterface.h"
#import "SFCFirebaseModel.h"

@class NSManagedObjectContext;

static NSUInteger kSFCFirebaseTimestampModifier = 1000;
@interface SFCFirebaseStore : NSObject

- (nonnull instancetype)initWithManagedObjectContext:(nonnull NSManagedObjectContext *)context;

- (nonnull instancetype)init NS_UNAVAILABLE;

- (BOOL)hasAuth;

- (void)unauth;

@end

@interface SFCFirebaseStore (SFCRemoteStore)<SFCRemoteStoreInterface>

@end
