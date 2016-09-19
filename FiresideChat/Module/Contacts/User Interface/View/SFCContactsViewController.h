//
//  SFCContactsViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCContextConsumer.h"
#import "SFCTableViewAdapter.h"

@interface SFCContactsViewController : UIViewController<SFCContextConsumer, SFCAdapterDelegate>

@end
