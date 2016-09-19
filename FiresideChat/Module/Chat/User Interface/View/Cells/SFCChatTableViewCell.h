//
//  SFCChatTableViewCell.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCObjectConsumer.h"
static NSString * const _Nonnull kSFCChatCellIdentifier = @"ChatCell";

@interface SFCChatTableViewCell : UITableViewCell<SFCObjectConsumer>

- (void)showUnreadMessageLabel:(BOOL)show;

@end
