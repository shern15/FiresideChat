//
//  SFCChatTableViewCell.m
//  FiresideChat
//
//  Created by Sean Hernandez.


#import "SFCChatTableViewCell.h"
#import "SFCChat.h"
#import "SFCContact.h"
#import "SFCMessage.h"
#import "SFCEdgeInsetsLabel.h"
#import "UIColor+SFCViewColors.h"

@interface SFCChatTableViewCell()

@property (nonnull, nonatomic) UILabel *nameLabel;
@property (nonnull, nonatomic) UILabel *messageLabel;
@property (nonnull, nonatomic) UILabel *dateLabel;
@property (nonnull, nonatomic) SFCEdgeInsetsLabel *unreadCountLabel;

@end

@implementation SFCChatTableViewCell

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	return self;
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		_nameLabel = [UILabel new];
		_messageLabel = [UILabel new];
		_dateLabel = [UILabel new];
		_unreadCountLabel = [SFCEdgeInsetsLabel new];
		[self setupTableViewCell];
	}
	
	return self;
}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 100);
}

- (void)awakeFromNib {
	[super awakeFromNib];
    // Initialization code
}

- (void)setupTableViewCell {
	[self setupLabels];
	self.backgroundColor = [UIColor clearColor];
}

- (void)setupLabels {
	_nameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
	_unreadCountLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
	_unreadCountLabel.layer.cornerRadius = 5.0;
	
	_messageLabel.font = [UIFont systemFontOfSize:15];
	_messageLabel.textColor = [UIColor grayColor];
	_messageLabel.numberOfLines = 2;
	_dateLabel.textColor = [UIColor grayColor];
	_unreadCountLabel.textColor = [UIColor whiteColor];
	_unreadCountLabel.layer.backgroundColor = [UIColor unreadCountLabelColor].CGColor;
	_unreadCountLabel.backgroundColor = [UIColor clearColor];
	_unreadCountLabel.labelEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0);
	_unreadCountLabel.hidden = YES;

	_nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_unreadCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
	
	[_unreadCountLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
	[_unreadCountLabel setContentHuggingPriority:751 forAxis:UILayoutConstraintAxisHorizontal];
	
	[self.contentView addSubview:_nameLabel];
	[self.contentView addSubview:_messageLabel];
	[self.contentView addSubview:_dateLabel];
	[self.contentView addSubview:_unreadCountLabel];
	
	NSArray<NSLayoutConstraint *> *constraints;
	constraints = @[[_nameLabel.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor],
					[_nameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor],
					[_dateLabel.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor],
					[_dateLabel.firstBaselineAnchor constraintEqualToAnchor:_nameLabel.firstBaselineAnchor],
					[_messageLabel.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor],
					[_messageLabel.leadingAnchor constraintEqualToAnchor:_nameLabel.leadingAnchor],
					[_messageLabel.trailingAnchor constraintEqualToAnchor:_unreadCountLabel.leadingAnchor],
					[_unreadCountLabel.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor],
					[_unreadCountLabel.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor]
					];
	
	[NSLayoutConstraint activateConstraints:constraints];
}

- (void)showUnreadMessageLabel:(BOOL)show {
	_unreadCountLabel.hidden = !show;
}

- (void)setObject:(id)object {
	SFCChat *chatModel = (SFCChat *)object;
	static NSDateFormatter *formatter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		formatter = [NSDateFormatter new];
		formatter.dateFormat = @"MM/dd/YY";
	});
	
	_nameLabel.text = chatModel.chatName;
	_dateLabel.text = [formatter stringFromDate:chatModel.lastMessageTime];
	_messageLabel.text = chatModel.lastMessage.text;
	
	//TODO:if unreadMessagesCount is 0, hide the unreadMessages label or show it
	//if its > 0
	_unreadCountLabel.text = [NSString stringWithFormat:@"%ld",chatModel.unreadMessagesInteger];
	[self showUnreadMessageLabel:(chatModel.unreadMessagesInteger > 0)];
}

@end
