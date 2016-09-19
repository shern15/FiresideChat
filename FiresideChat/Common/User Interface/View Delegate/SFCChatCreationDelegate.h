//
//  SFCComposeChatViewControllerDelegate.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;

@class SFCComposeChatViewController;
@class SFCChat;

@protocol SFCChatCreationDelegate <NSObject>

- (void)composeChatViewController:(UIViewController *)controller
			   didComposeChat:(SFCChat *)chat inManagedObjectContext:(NSManagedObjectContext *)context;

@optional
- (void)composeChatViewControllerDidCancelChatComposition:(UIViewController *)controller;
@end
