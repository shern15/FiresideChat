//
//  UIButton+SFCButtonAnimation.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "UIButton+SHButtonAnimation.h"

@implementation UIButton (SHButtonAnimation)

NSString *const kScaleSmallAnimatonKey = @"layerScaleSmallAnimation";
NSString *const kScaleSpringAnimatonKey = @"layerScaleSpringAnimation";
NSString *const kScaleDefaultAnimationKey = @"layerScaleDefaultAnimation";


- (void)scaleToSmallAnimation {
	NSNumber *fromScaleNumber = @1.0;
	NSNumber *toScaleNumber = @0.95;
	CFTimeInterval animDuration = 0.25;
	
	CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:kScaleSmallAnimatonKey];
	scaleAnim.duration = animDuration;
	scaleAnim.fromValue = fromScaleNumber;
	scaleAnim.toValue = toScaleNumber;
	scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
	scaleAnim.fillMode = kCAFillModeForwards;
	scaleAnim.removedOnCompletion = false;
	
	[self.layer addAnimation:scaleAnim forKey:kScaleSmallAnimatonKey];
}

- (void)springScaleAnimation {
	NSTimeInterval animDuration = 0.25;
	NSTimeInterval animDelay = 0.0;
	CGFloat springDamping = 0.2;
	CGFloat springVelocity = 0.1;
	
	[self.layer removeAllAnimations];
	self.transform = CGAffineTransformMakeScale(0.95, 0.95);
	
	[UIView animateWithDuration:animDuration
						  delay:animDelay
		 usingSpringWithDamping:springDamping
		  initialSpringVelocity:springVelocity
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 self.transform = CGAffineTransformMakeScale(1.0, 1.0);
					 }
					 completion:^(BOOL finished){
						 self.transform = CGAffineTransformIdentity;
					 }
	 ];
}

- (void)scaleToDefaultAnimation {
	NSNumber *fromScaleNumber = @0.95;
	NSNumber *toScaleNumber = @1.0;
	CFTimeInterval animDuration = 0.25;
	
	CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:kScaleSmallAnimatonKey];
	scaleAnim.duration = animDuration;
	scaleAnim.fromValue = fromScaleNumber;
	scaleAnim.toValue = toScaleNumber;
	scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
	scaleAnim.fillMode = kCAFillModeForwards;
	scaleAnim.removedOnCompletion = true;
	
	[self.layer addAnimation:scaleAnim forKey:kScaleDefaultAnimationKey];
}
@end
