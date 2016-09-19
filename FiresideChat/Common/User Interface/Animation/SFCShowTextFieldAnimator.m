//
//  SFCTextFieldAnimator.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCShowTextFieldAnimator.h"

@interface SFCShowTextFieldAnimator()

@property (nullable, nonatomic, unsafe_unretained) NSLayoutConstraint *constraint;
@property (nullable, nonatomic, unsafe_unretained) UITextField *textField;
@property (nonatomic) NSUInteger constraintModifier;

@end

@implementation SFCShowTextFieldAnimator

- (instancetype)initWithTextField:(UITextField *)textField textFieldConstraint:(NSLayoutConstraint *)constraint
				 constantModifier:(NSUInteger)modifier
{
	if((self = [super init])) {
		_textField = textField;
		_constraint = constraint;
		_constraintModifier = modifier;
	}
	
	return self;
}

- (void)animateToShowTextField:(BOOL)showTextField
		 withAnimationDuration:(NSTimeInterval)animationDuration {

	[_textField.superview layoutIfNeeded];
	
	if(showTextField) {
		_constraint.constant += _constraintModifier;
		_textField.hidden = NO;
		[UIView
		 animateWithDuration:animationDuration animations:
		 ^{
			 [_textField.superview layoutIfNeeded];
			 _textField.alpha = 1.0;
			 
		 }];
	}
	else {
		_constraint.constant -= _constraintModifier;
		[UIView animateWithDuration:animationDuration animations:
		 ^{
			 [_textField.superview layoutIfNeeded];
			 _textField.alpha = 0.0;
		} completion:
		 ^(BOOL finished) {
			 _textField.hidden = YES;
		 }];
	}
}

@end