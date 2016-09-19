//
//  SFCContactsSearchResultsViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCAdapterDelegate.h"
#import "SFCContextConsumer.h"

@class SFCArrayDataSource;
@protocol SFCAdapterDelegate;

@interface SFCContactsSearchResultsViewController : UIViewController<SFCAdapterDelegate, UISearchResultsUpdating>

@property (nonnull, nonatomic) SFCArrayDataSource *dataSource;
@property (nullable, nonatomic, weak) id<SFCAdapterDelegate> delegate;

@end
