//
//  SFCCoreDataStackConsumer.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;

@class SFCCoreDataStack;
@protocol SFCCoreDataStackConsumer <NSObject>

@property(nonnull, nonatomic) SFCCoreDataStack *coreDataStack;

@end
