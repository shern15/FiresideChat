//
//  GroupChatDetailsViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez on 9/14/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCAdapterDelegate.h"

@class SFCContact;

@interface SFCGroupDetailsViewController : UIViewController<SFCAdapterDelegate>

@property (nonnull, nonatomic) NSArray<SFCContact *> *participantsArray;

@end
