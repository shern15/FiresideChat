//
//  UIViewController+SHFillWithView.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "UIViewController+SHFillWithView.h"

@implementation UIViewController (SHFillWithView)

- (void)fillWithView:(UIView *)subview {
	subview.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:subview];
	
	NSArray<NSLayoutConstraint *> *viewConstraints;
	
	viewConstraints = @[
						[subview.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor],
						[subview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
						[subview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
						[subview.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor]
						];
	
	[NSLayoutConstraint activateConstraints:viewConstraints];
}

@end
