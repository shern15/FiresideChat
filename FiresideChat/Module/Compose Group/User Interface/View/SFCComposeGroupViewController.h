//
//  ComposeGroupViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCSelectContactsDelegate.h"
#import "SFCChatCreationDelegate.h"
#import "SFCContextConsumer.h"

@interface SFCComposeGroupViewController : UIViewController<SFCContextConsumer, SFCSelectContactsDelegate>

@property (nullable, nonatomic, weak) id<SFCChatCreationDelegate> delegate;

@end
