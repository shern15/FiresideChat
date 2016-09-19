//
//  SFCSelectContactsDelegate.h
//  FiresideChat
//
//  Created by Sean Hernandez on 9/15/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFCContact;
@class SFCSelectContactsViewController;

@protocol SFCSelectContactsDelegate <NSObject>

- (void)controller:(SFCSelectContactsViewController *)controller didSelectContacts:(NSArray<SFCContact *> *)selectedContacts;

@end
