//
//  ViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;

#import "SFCContextConsumer.h"

@class SFCChat;
@interface SFCMessagesViewController : UIViewController

@property (nonnull, nonatomic) SFCChat *parentChat;
@property (nonnull, nonatomic) NSManagedObjectContext *context;

@end

