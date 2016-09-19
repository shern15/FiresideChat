//
//  SFCFavoriteContactCell.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCFavoriteContactCell.h"
#import "SFCContact.h"
#import "SFCPhoneNumber.h"

@interface SFCFavoriteContactCell()

@property (nonnull, nonatomic) UILabel *phoneTypeLabel;

@end

@implementation SFCFavoriteContactCell

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
	_phoneTypeLabel = [UILabel new];
	[self.contentView addSubview:_phoneTypeLabel];

	_phoneTypeLabel.textColor = [UIColor lightGrayColor];
	_phoneTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
	
	[_phoneTypeLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
	[_phoneTypeLabel.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor].active = YES;

	self.detailTextLabel.textColor = [UIColor lightGrayColor];
	self.accessoryType = UITableViewCellAccessoryDetailButton;
	self.backgroundColor = [UIColor clearColor];
}

- (void)setObject:(id)object
{
	SFCContact *contact = object;
	self.textLabel.text = contact.fullName;
	self.detailTextLabel.text = contact.status ? contact.status : @"***no status***";
	_phoneTypeLabel.text = [contact.phoneNumbers
							filteredSetUsingPredicate:
							 [NSPredicate predicateWithFormat:@"isRegistered == YES"]].allObjects.firstObject.kind;
//_phoneTypeLabel.text = contact.phoneNumbers.allObjects.firstObject.kind;
}

@end
