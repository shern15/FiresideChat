//
//  SFCMessageTableViewCell.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCMessageTableViewCell.h"
#import "SFCMessage.h"
#import "SFCContact.h"
#import "SFCUserBubbleView.h"
#import "UIColor+SFCViewColors.h"
#import "UIImage+SHMirrorImage.h"
#import "UIImage+SHColoredImage.h"

@interface SFCMessageTableViewCell()

@property (nonnull, nonatomic) UILabel *nameLabel;
@property (nonnull, nonatomic) UILabel *messageLabel;
@property (nonnull, nonatomic) UIImageView *messageBubbleImageView;
@property (nonnull, nonatomic) SFCUserBubbleView *userBubbleView;
@property (nonnull, nonatomic) NSArray *outgoingConstraints;
@property (nonnull, nonatomic) NSArray *incomingConstraints;

@end

@implementation SFCMessageTableViewCell

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	return self;
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		_messageBubbleImageView = [UIImageView new];
		_messageLabel = [UILabel new];
		_nameLabel = [UILabel new];

		_userBubbleView= [SFCUserBubbleView new];
		
		[self setupTableViewCell];
	}
	
	return self;
}

- (void)setupTableViewCell {
	_nameLabel.textColor = [UIColor grayColor];
	_nameLabel.font = [UIFont systemFontOfSize:10];
	
	_userBubbleView.translatesAutoresizingMaskIntoConstraints = NO;
	_nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	
	_messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_messageBubbleImageView.translatesAutoresizingMaskIntoConstraints = NO;
	
	
	[self.contentView addSubview:_messageBubbleImageView];
	[_messageBubbleImageView addSubview:_messageLabel];
	
	[self.contentView addSubview:_userBubbleView];
	
	[self.contentView addSubview:_nameLabel];
	
	[_messageLabel.centerXAnchor constraintEqualToAnchor:_messageBubbleImageView.centerXAnchor].active = YES;
	[_messageLabel.centerYAnchor constraintEqualToAnchor:_messageBubbleImageView.centerYAnchor].active = YES;
	[_messageBubbleImageView.widthAnchor constraintEqualToAnchor:_messageLabel.widthAnchor constant:30].active = YES;
	[_messageBubbleImageView.heightAnchor constraintEqualToAnchor:_messageLabel.heightAnchor constant:20].active = YES;
	
	[_messageBubbleImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10].active = YES;
	[_messageBubbleImageView.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
	[_userBubbleView.bottomAnchor constraintEqualToAnchor:_messageBubbleImageView.bottomAnchor].active = YES;
	
	_outgoingConstraints = @[
							 [_messageBubbleImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
							 [NSLayoutConstraint constraintWithItem:_messageBubbleImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual
															 toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0.0]
							 ];
	
	_incomingConstraints = @[
							 [_userBubbleView.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor],
							 [_messageBubbleImageView.leadingAnchor constraintEqualToAnchor:_userBubbleView.trailingAnchor],
							 [NSLayoutConstraint constraintWithItem:_messageBubbleImageView attribute:NSLayoutAttributeTrailing
														  relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView
														  attribute:NSLayoutAttributeCenterX multiplier:1.5 constant:0.0],
							 [_nameLabel.bottomAnchor constraintEqualToAnchor:_messageBubbleImageView.topAnchor],
							 [_nameLabel.leadingAnchor constraintEqualToAnchor:_messageLabel.leadingAnchor]
							 ];
	
	
	_messageLabel.textAlignment = NSTextAlignmentLeft;
	_messageLabel.numberOfLines = 0;
	
	_messageLabel.textColor = [UIColor whiteColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.backgroundColor = [UIColor clearColor];
}


- (void)setObject:(id)object {
	SFCMessage *messageModel = (SFCMessage *)object;
	_messageLabel.text = messageModel.text;
	if(messageModel.sender) {
		[_userBubbleView setInitialsString: [messageModel.sender nameInitials]];
		_nameLabel.text = messageModel.sender.fullName;
	}
	[self setupMessageViewFromIsIncomingFlag:messageModel.isIncoming];
}

- (void)setupMessageViewFromIsIncomingFlag:(BOOL)isIncoming {
	
	//MARK: Initialize Message background images once;
	static UIImage *incomingMessageImage;
	static UIImage *outgoingMessageImage;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		incomingMessageImage = [self makeIncomingBubbleImage];
		outgoingMessageImage = [self makeOutgoingBubbleImage];
	});
	
	if (isIncoming) {
		_messageBubbleImageView.image = incomingMessageImage;
		_messageLabel.textColor = [UIColor blackColor];
		_userBubbleView.hidden = NO;
		_nameLabel.hidden = NO;
		[NSLayoutConstraint deactivateConstraints:_outgoingConstraints];
		[NSLayoutConstraint activateConstraints:_incomingConstraints];
	} else {
		_messageBubbleImageView.image = outgoingMessageImage;
		_messageLabel.textColor = [UIColor whiteColor];
		_userBubbleView.hidden = YES;
		_nameLabel.hidden = YES;
		[NSLayoutConstraint deactivateConstraints:_incomingConstraints];
		[NSLayoutConstraint activateConstraints:_outgoingConstraints];
	}
}

- (UIImage *)makeIncomingBubbleImage {
	UIImage *image = [UIImage imageNamed:@"MessageBubble"];
	UIEdgeInsets incomingInsets = UIEdgeInsetsMake(17, 26.5, 17.5, 26.5);
	image = [[[image upMirroredImage]
			  colorImageWithColor:[UIColor incomingBubbleImageColor]]
			 resizableImageWithCapInsets:incomingInsets];
	return image;
}

- (UIImage *)makeOutgoingBubbleImage {
	UIImage *image = [UIImage imageNamed:@"MessageBubble"];
	UIEdgeInsets outgoingInsets = UIEdgeInsetsMake(17, 21, 17.5, 26.5);
	image = [[image colorImageWithColor:[UIColor outgoingBubbleImageColor]]
			 resizableImageWithCapInsets:outgoingInsets];
	
	return image;
}
@end
