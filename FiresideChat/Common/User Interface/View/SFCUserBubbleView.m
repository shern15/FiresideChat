//
//  SFCUserBubbleView.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCUserBubbleView.h"

@interface SFCUserBubbleView()

@property (nonnull, nonatomic) UILabel *initialsLabel;
@property (nonnull, nonatomic) UIImageView *photoView;

@end

@implementation SFCUserBubbleView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		_initialsLabel = [UILabel new];
		_photoView = [UIImageView new];
		[self setupView];
	}
	
	return self;
}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(30, 30);
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setupView];
	
}

- (void)setupView
{
	_initialsLabel.textColor = [UIColor whiteColor];
	_initialsLabel.font = [UIFont systemFontOfSize:15];
	_initialsLabel.textAlignment = NSTextAlignmentCenter;
	
	_photoView.backgroundColor = [UIColor clearColor];
	_photoView.contentMode = UIViewContentModeScaleAspectFit;
	_photoView.hidden = YES;
	
	_initialsLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_photoView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self addSubview:_photoView];
	[self addSubview:_initialsLabel];
	
	self.backgroundColor = [UIColor lightGrayColor];
	self.layer.cornerRadius = 15;
	self.clipsToBounds = YES;
	
	[self setupConstraints];
}

- (void)setupConstraints {
	[self.widthAnchor constraintEqualToConstant:30].active = YES;
	[self.heightAnchor constraintEqualToConstant:30].active = YES;
	[_photoView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
	[_photoView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
	[_initialsLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
	[_initialsLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}

- (void)setInitialsString:(NSString *)initialsString {
	_initialsLabel.text = initialsString;
}

- (void)setUserPhoto:(UIImage *)userPhoto {
	_photoView.layer.cornerRadius = _photoView.frame.size.width / 2;
	_photoView.image = userPhoto;
}



@end
