//
//  SFCMessagesSectionHeaderView.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCMessagesSectionHeaderView.h"
#import "UIColor+SFCViewColors.h"

@interface SFCMessagesSectionHeaderView()

@property(nonnull, nonatomic) UILabel *dateLabel;

@end

@implementation SFCMessagesSectionHeaderView

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
	self.backgroundColor = [UIColor clearColor];
	UIView *paddingView = [UIView new];
	[self addSubview:paddingView];
	paddingView.translatesAutoresizingMaskIntoConstraints = NO;
	paddingView.layer.cornerRadius = 10;
	paddingView.layer.masksToBounds = true;
	paddingView.backgroundColor = [UIColor sectionHeaderBackgroundColor];
	
	_dateLabel = [UILabel new];
	[paddingView addSubview:_dateLabel];
	_dateLabel.translatesAutoresizingMaskIntoConstraints = NO;

	
	NSArray<NSLayoutConstraint *> *constraints;
	constraints = @[
					[paddingView.centerXAnchor
					 constraintEqualToAnchor:self.centerXAnchor],
					
					[paddingView.centerYAnchor
					 constraintEqualToAnchor:self.centerYAnchor],
					
					[_dateLabel.centerXAnchor
					 constraintEqualToAnchor:paddingView.centerXAnchor],
					
					[_dateLabel.centerYAnchor
					 constraintEqualToAnchor:paddingView.centerYAnchor],
					
					[paddingView.heightAnchor
					 constraintEqualToAnchor:_dateLabel.heightAnchor constant:4],
					
					[paddingView.widthAnchor
					 constraintEqualToAnchor:_dateLabel.widthAnchor constant:10],
					
					[self.heightAnchor
					 constraintEqualToAnchor:paddingView.heightAnchor]
					];
	
	[NSLayoutConstraint activateConstraints:constraints];
}

- (nullable NSString *)title {
	return _dateLabel.text;
}

- (void)setTitle:(nonnull NSString *)titleString {
	_dateLabel.text = titleString;
}

@end
