//
//  SFCAdapterDelegate.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;

@protocol SFCAdapter;
@protocol SFCAdapterDelegate <NSObject>
@optional
- (void)adapter:(nonnull id<SFCAdapter>)adapter didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath WithObject:(nonnull id)object;
- (void)adapter:(nonnull id<SFCAdapter>)adapter didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath WithObject:(nonnull id)object;
- (void)adapter:(nonnull id<SFCAdapter>)adapter accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath withObject:(nonnull id)object;
- (void)adapter:(nonnull id<SFCAdapter>)adapter didRemoveRowAtIndexPath:(nonnull NSIndexPath *)indexPath withObject:(nonnull id)object;
@end
