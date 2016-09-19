//
//  SFCComposeChatViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCChatCreationDelegate.h"
#import "SFCContextConsumer.h"

@interface SFCComposeChatViewController : UIViewController<SFCContextConsumer>

@property (nullable, nonatomic, weak) id<SFCChatCreationDelegate> delegate;

@end
