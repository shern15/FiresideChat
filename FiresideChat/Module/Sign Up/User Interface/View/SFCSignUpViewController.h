//
//  SFCSignUpViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;

#import "SFCLoginStateDelegate.h"

@protocol SFCRemoteStoreInterface;
@class SFCContactImporter;

static  NSString * _Nonnull kSFCSignUpViewControllerIdentifier = @"SFCSignUpViewController";
@interface SFCSignUpViewController : UIViewController

@property (nullable, nonatomic, weak) id<SFCRemoteStoreInterface> remoteStore;
@property (nullable, nonatomic, weak) SFCContactImporter *contactImporter;
@property (nullable, nonatomic, weak) id<SFCLoginStateDelegate> delegate;

@end
