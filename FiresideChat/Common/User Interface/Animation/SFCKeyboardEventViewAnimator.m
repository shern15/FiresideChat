//
//  SFCKeyboardEventViewAnimator.m
//  Created by Sean Hernandez.
//

#import"SFCKeyboardEventViewAnimator.h"
#import "NSNotification+SHKeyboardProperties.h"

@interface SFCKeyboardEventViewAnimator()
@property (nullable, nonatomic, unsafe_unretained) NSLayoutConstraint *elementConstraint;
@property (nonnull, nonatomic, unsafe_unretained) UIView * constraintOwner;
@property (nonatomic) CGFloat originalConstant;
@end

@implementation SFCKeyboardEventViewAnimator

- (nonnull instancetype)initWithLayoutConstraintToModify:(NSLayoutConstraint *)constraint andConstraintOwner:(UIView *)constraintOwnerView {
	if ((self = [super init])) {
		_elementConstraint = constraint;
		_constraintOwner = constraintOwnerView;
		_originalConstant = constraint.constant;
	}
	
	return self;
}

//Modifies the constraint by the height of the 
//- (void)animateOnKeyboardNotification:(NSNotification *)notification
//			  keyboardPaddingConstant:(CGFloat)paddingConstant
//					   animationDelay:(CGFloat)animationDelay
//				  animationCompletion:(void (^)(BOOL finished))completion
//{
//	NSTimeInterval animationDuration = notification.keyboardAnimationDuration;
//	UIViewAnimationOptions animationOption = notification.keyboardAnimationOption;
//	CGRect keyboardScreenRect = notification.keyboardScreenFrameEnd;
//	CGRect keyboardFrameRect = [_constraintOwner convertRect:keyboardScreenRect
//														 fromView:[UIApplication sharedApplication].delegate.window];
//	
//	
//	[self animateConstraintWithConstantModifier:constantModifier
//							  animationDuration:animationDuration
//								 animationDelay:animationDelay
//								animationOption:animationOption
//							animationCompletion:completion];
//}

- (void)animateOnKeyboardNotification:(NSNotification *)notification
		  withViewToShowAboveKeyboard:(UIView *)view
			  keyboardPaddingConstant:(CGFloat)paddingConstant
					   animationDelay:(CGFloat)animationDelay
				  animationCompletion:(void (^)(BOOL finished))completion
{
	NSTimeInterval animationDuration = notification.keyboardAnimationDuration;
	UIViewAnimationOptions animationOption = notification.keyboardAnimationOption;
	CGRect keyboardScreenRect = notification.keyboardScreenFrameEnd;
	CGRect keyboardFrameRect = [_constraintOwner convertRect:keyboardScreenRect
													fromView:[UIApplication sharedApplication].delegate.window];
	CGFloat constantModifier;
	
	if(notification.name == UIKeyboardWillHideNotification) {
		constantModifier = _originalConstant;
		[self animateConstraintWithConstantModifier:constantModifier animationDuration:animationDuration
									 animationDelay:animationDelay animationOption:animationOption
								animationCompletion:completion];
		return;
	}
	
	if(view) {
		constantModifier = keyboardFrameRect.origin.y - CGRectGetMaxY(view.frame) - paddingConstant;
	} else {
		constantModifier = keyboardFrameRect.origin.y - CGRectGetMaxY(_constraintOwner.frame) - paddingConstant;
	}

	[self animateConstraintWithConstantModifier:constantModifier animationDuration:animationDuration
								 animationDelay:animationDelay animationOption:animationOption
							animationCompletion:completion];
}

//MARK: Helper Method
- (void)animateConstraintWithConstantModifier:(CGFloat)constantModifier
							animationDuration:(NSTimeInterval)animationDuration
							   animationDelay:(NSTimeInterval)animationDelay
							  animationOption:(UIViewAnimationOptions)animationOption
						  animationCompletion:(void (^)(BOOL finished))completion
{
	
	self.elementConstraint.constant = constantModifier;
	
	[UIView animateWithDuration:animationDuration delay:0.0 options:animationOption
					 animations:^{
						 [_constraintOwner layoutIfNeeded];
					 }
					 completion:completion];

}

@end
