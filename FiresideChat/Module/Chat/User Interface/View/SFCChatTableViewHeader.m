//
//  SFCChatTableViewHeader.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCChatTableViewHeader.h"

@interface SFCChatTableViewHeader()

@property (nonnull, nonatomic) UIButton *composeGroupButton;

@end

@implementation SFCChatTableViewHeader
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
	_composeGroupButton = [UIButton new];
	_composeGroupButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:_composeGroupButton];
	
	[_composeGroupButton setTitle:@"New Group" forState:UIControlStateNormal];
	[_composeGroupButton setTitleColor:self.tintColor forState:UIControlStateNormal];
	
	UIView *border = [UIView new];
	border.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:border];
	
	border.backgroundColor = [UIColor lightGrayColor];
	
	NSArray<NSLayoutConstraint *> *constraints;
	
	constraints = @[
					[_composeGroupButton.heightAnchor constraintEqualToAnchor:self.heightAnchor],					
					[_composeGroupButton.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
					[border.heightAnchor constraintEqualToConstant:1],
					[border.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
					[border.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
					[border.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
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
