//
//  SFCMessagesParticipantsHeaderView.m
//  FiresideChat
//
//  Created by Sean Hernandez on 9/14/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import "SFCMessagesParticipantsHeaderView.h"
#import "UIColor+SFCViewColors.h"

@interface SFCMessagesParticipantsHeaderView()

@property (nonnull, nonatomic) UILabel *namesLabel;

@end

@implementation SFCMessagesParticipantsHeaderView

- (instancetype)init {
	if((self = [super init])) {
		[self setupView];
	}
	
	return self;
}

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

- (void)setupView {
	self.backgroundColor = [UIColor secondaryColor];
	_namesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_namesLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_namesLabel setTextColor:[UIColor whiteColor]];
	_namesLabel.layoutMargins = UIEdgeInsetsMake(0, -20, 0, -20);
	[self addSubview:_namesLabel];
	
	NSArray<NSLayoutConstraint *> *constraints = @[
												   [_namesLabel.layoutMarginsGuide.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
												   [_namesLabel.layoutMarginsGuide.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
												   [_namesLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
												   ];
	[NSLayoutConstraint activateConstraints:constraints];
}

- (void)setParticipantsNamesWithArray:(NSArray<NSString *> *)namesArray {
	_namesLabel.text = [NSString stringWithFormat:@"To: %@",
						[namesArray componentsJoinedByString:@", "]];
}

- (void)setParticipantsNamesWithString:(NSString *)namesString {
	_namesLabel.text = namesString;
}

@end
