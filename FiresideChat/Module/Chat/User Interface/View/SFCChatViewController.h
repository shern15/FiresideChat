//
//  SFCChatViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCChatCreationDelegate.h"
#import "SFCContextConsumer.h"

@interface SFCChatViewController : UIViewController<SFCChatCreationDelegate, SFCContextConsumer>

@end
