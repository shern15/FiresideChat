//
//  SFCLoginStateDelegate.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import <Foundation/Foundation.h>

@protocol SFCLoginStateDelegate <NSObject>

- (void)didLoginFromViewController:(UIViewController *)sourceViewController;
@optional
- (void)didLogoutFromViewController:(UIViewController *)sourceViewController;

@end
