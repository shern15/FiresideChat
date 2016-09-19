//
//  SFCTextFieldAnimator.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;

@interface SFCShowTextFieldAnimator : NSObject

- (nonnull instancetype)initWithTextField:(nonnull UITextField *)textField textFieldConstraint:(nonnull NSLayoutConstraint *)constraint
						 constantModifier:(NSUInteger)modifier NS_DESIGNATED_INITIALIZER;

- (void)animateToShowTextField:(BOOL)showTextField
		 withAnimationDuration:(NSTimeInterval)animationDuration;

- (nonnull instancetype)init NS_UNAVAILABLE;
@end
