//
//  SFCSearchField.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCSearchField.h"

@implementation SFCSearchField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self setupView];
	}
	
	return self;
}

- (instancetype)init {
	if ((self = [super init])) {
		[self setupView];
	}
	
	return self;
}


- (void)setupView {
	//CGRect searchFieldRect = CGRectMake(0, 0, 0, 50);
	self.backgroundColor = [UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:1.0f];
	self.placeholder = @"Type contact name";
	
	CGRect holderViewFrame = CGRectMake(0, 0, 50, 50);
	UIView *holderView = [[UIView alloc] initWithFrame:holderViewFrame];
	
	self.leftView = holderView;
	self.leftViewMode = UITextFieldViewModeAlways;
	UIImage *contactImage = [[UIImage imageNamed:@"contact_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	UIImageView  *contactImageView = [[UIImageView alloc] initWithImage:contactImage];
	contactImageView.tintColor = [UIColor darkGrayColor];
	
	[holderView addSubview:contactImageView];
	contactImageView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSArray<NSLayoutConstraint *> *constraints;
	constraints = @[
					[contactImageView.widthAnchor constraintEqualToAnchor:holderView.widthAnchor constant:-20],
					[contactImageView.heightAnchor constraintEqualToAnchor:holderView.heightAnchor constant:-20],
					[contactImageView.centerXAnchor constraintEqualToAnchor:holderView.centerXAnchor],
					[contactImageView.centerYAnchor constraintEqualToAnchor:holderView.centerYAnchor]
					];
	
	[NSLayoutConstraint activateConstraints:constraints];

}
@end
