//
//  SFCSearchFieldHeaderView.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCSearchFieldHeaderView.h"

@interface SFCSearchFieldHeaderView()

@property (nullable, nonatomic) UITextField *searchField;

@end

@implementation SFCSearchFieldHeaderView

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
	CGRect searchFieldRect = CGRectMake(0, 0, 0, 50);
	_searchField = [[UITextField alloc] initWithFrame:searchFieldRect];
	_searchField.backgroundColor = [UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:1.0f];
	_searchField.placeholder = @"Type contact name";
	[self addSubview:_searchField];
	
	CGRect holderViewFrame = CGRectMake(0, 0, 50, 50);
	UIView *holderView = [[UIView alloc] initWithFrame:holderViewFrame];
	
	_searchField.leftView = holderView;
	_searchField.leftViewMode = UITextFieldViewModeAlways;
	_searchField.translatesAutoresizingMaskIntoConstraints = NO;
	UIImage *contactImage = [[UIImage imageNamed:@"contact_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	UIImageView  *contactImageView = [[UIImageView alloc] initWithImage:contactImage];
	contactImageView.tintColor = [UIColor darkGrayColor];
	
	[holderView addSubview:contactImageView];
	contactImageView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSArray<NSLayoutConstraint *> *constraints;
	constraints = @[
					[_searchField.widthAnchor constraintEqualToAnchor:self.widthAnchor],
					[_searchField.heightAnchor constraintEqualToAnchor:self.heightAnchor],
					[contactImageView.widthAnchor constraintEqualToAnchor:holderView.widthAnchor constant:-20],
					[contactImageView.heightAnchor constraintEqualToAnchor:holderView.heightAnchor constant:-20],
					[contactImageView.centerXAnchor constraintEqualToAnchor:holderView.centerXAnchor],
					[contactImageView.centerYAnchor constraintEqualToAnchor:holderView.centerYAnchor]
					];
	
	[NSLayoutConstraint activateConstraints:constraints];
	[self setNeedsLayout];
	[self layoutIfNeeded];
	CGFloat compressedHeight = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
	CGRect frame = self.frame;
	
	frame.size.height = compressedHeight;
	
	self.frame = frame;
}

@end
