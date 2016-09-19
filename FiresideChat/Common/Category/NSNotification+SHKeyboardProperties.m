//
//  NSNotification+SHKeyboardProperties.m
//  
//
//  Created by Sean Hernandez.
//

#import "NSNotification+SHKeyboardProperties.h"

@implementation NSNotification (SHKeyboardProperties)

- (NSTimeInterval)keyboardAnimationDuration {
	if(self.userInfo != nil) {
		return [self.userInfo[UIKeyboardAnimationDurationUserInfoKey]
				doubleValue];
	} else {
		return 0.1;
	}
}

- (NSInteger)keyboardRawAnimationCurve {
	if (self.userInfo != nil) {
		NSInteger rawAnimationCurve = [self.userInfo[UIKeyboardAnimationCurveUserInfoKey]
									   integerValue];
		return rawAnimationCurve;
	} else {
		return UIViewAnimationCurveEaseIn;
	}
}

- (NSUInteger)keyboardAnimationOption {
	return (NSUInteger)(self.keyboardRawAnimationCurve << 16);
}


- (CGRect)keyboardScreenFrameBegin {
	if (self.userInfo != nil) {
		return [self.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	} else {
		return CGRectZero;
	}
}

- (CGRect)keyboardScreenFrameEnd {
	if (self.userInfo != nil) {
		return [self.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	} else {
		return CGRectZero;
	}
	
	
}

@end
