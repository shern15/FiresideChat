//
//  SFCMessageTableViewCell.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCObjectConsumer.h"

static NSString * const _Nonnull kSFCMessageCellIdentifier = @"MessageCell";

@interface SFCMessageTableViewCell : UITableViewCell<SFCObjectConsumer>

@end
