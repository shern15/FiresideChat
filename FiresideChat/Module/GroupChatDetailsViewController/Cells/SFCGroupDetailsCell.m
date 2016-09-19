//
//  SFCGroupDetailsCell.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCGroupDetailsCell.h"
#import "SFCUserBubbleView.h"
#import "SFCContact.h"

@interface SFCGroupDetailsCell ()

@property (nonnull, nonatomic) SFCUserBubbleView *userBubbleView;
@property (nonnull, nonatomic) UILabel *nameLabel;

@end

@implementation SFCGroupDetailsCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
		[self setupTableViewCell];
	}
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		[self setupTableViewCell];
	}
	return self;
}


- (void)setupTableViewCell
{
	_nameLabel = [UILabel new];
	_userBubbleView = [[SFCUserBubbleView alloc] initWithFrame:CGRectZero];
	
	_nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_userBubbleView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.contentView addSubview:_userBubbleView];
	[self.contentView addSubview:_nameLabel];
	
	self.detailTextLabel.textColor = [UIColor lightGrayColor];
	self.accessoryType = UITableViewCellAccessoryDetailButton;
	self.backgroundColor = [UIColor clearColor];
	
	[self setupConstraints];
}


- (void)setupConstraints {
	NSArray<NSLayoutConstraint *> *constraints = @[
												   [_userBubbleView.leadingAnchor
													constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor],
												   [_userBubbleView.centerYAnchor
													constraintEqualToAnchor:self.contentView.centerYAnchor],
												   [_nameLabel.leadingAnchor
													constraintEqualToAnchor:_userBubbleView.trailingAnchor constant:10],
												   [_nameLabel.centerYAnchor
													constraintEqualToAnchor:self.contentView.centerYAnchor]
												   ];
	
	[NSLayoutConstraint activateConstraints:constraints];
}

- (void)setObject:(id)object
{
	SFCContact *contact = object;
	_nameLabel.text = contact.fullName;
	[_userBubbleView setInitialsString:[contact nameInitials]];
}

@end
