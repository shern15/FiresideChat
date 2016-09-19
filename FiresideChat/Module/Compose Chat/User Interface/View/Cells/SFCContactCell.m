//
//  SFCContactCell.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCContactCell.h"
#import "SFCContact.h"

@implementation SFCContactCell

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	return self;
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

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
	
}

- (void)setObject:(id)object {
	SFCContact *contact = (SFCContact *)object;
	self.textLabel.text = contact.fullName;
}


@end
