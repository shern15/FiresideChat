//
//  SFCAddParticipantsViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCChatCreationDelegate.h"
#import "SFCAdapterDelegate.h"

@class SFCChat;

@interface SFCAddParticipantsViewController : UIViewController<SFCAdapterDelegate>

@property (nullable, nonatomic) NSManagedObjectContext *composeChatContext;
@property (nullable, nonatomic, weak) id<SFCChatCreationDelegate> delegate;
@property (nullable, nonatomic, weak) SFCChat *chat;

@end
