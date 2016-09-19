//
//  NSNotification+SHKeyboardProperties.h
//  
//
//  Created by Sean Hernandez.
//

@import UIKit;

@interface NSNotification (SHKeyboardProperties)

- (NSTimeInterval)keyboardAnimationDuration;
- (NSInteger)keyboardRawAnimationCurve;
- (NSUInteger)keyboardAnimationOption;
- (CGRect)keyboardScreenFrameBegin;
- (CGRect)keyboardScreenFrameEnd;

@end
