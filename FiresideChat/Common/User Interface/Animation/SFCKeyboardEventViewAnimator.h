//
//  SFCKeyboardEventViewAnimator.h
//  Created by Sean Hernandez.
//

@import UIKit;


@interface SFCKeyboardEventViewAnimator : NSObject

- (nonnull instancetype)initWithLayoutConstraintToModify:(nonnull NSLayoutConstraint *)constraint
									  andConstraintOwner:(nonnull UIView *)constraintOwnerView;


- (void)animateOnKeyboardNotification:(nonnull NSNotification *)notification
		  withViewToShowAboveKeyboard:(nullable UIView *)view
			  keyboardPaddingConstant:(CGFloat)paddingConstant
					   animationDelay:(CGFloat)animationDelay
				  animationCompletion:(void (^_Nullable)(BOOL finished))completion;


- (nonnull instancetype)init NS_UNAVAILABLE;
@end
