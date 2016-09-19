//
//  SFCSelectContactsViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez on 9/15/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCContextConsumer.h"
#import "SFCAdapterDelegate.h"
#import "SFCSelectContactsDelegate.h"

@interface SFCSelectContactsViewController : UIViewController<SFCAdapterDelegate, SFCContextConsumer>

@property (nullable, nonatomic, weak) id<SFCSelectContactsDelegate> delegate;
@property (nullable, nonatomic) NSString *dismissBarButtonItemTitle;
@property (nullable, nonatomic) NSPredicate *searchPredicate;
@property (nonatomic) NSUInteger numberOfSelectionsRequiredToProceed;

- (nonnull instancetype)initWithNumberOfSelectionsRequiredToProceed:(NSUInteger)numberOfSelectionsRequiredToProceed context:(nullable NSManagedObjectContext *)context
						searchPredicate:(nullable NSPredicate *)searchPredicate dismissBarButtonItemTitle:(nullable NSString *)dismissBarButtonItemTitle
					viewControllerTitle:(nullable NSString *)viewControllerTitle;

- (nonnull instancetype)initWithNumberOfSelectionsRequiredToProceed:(NSUInteger)numberOfSelectionsRequiredToProceed context:(nullable NSManagedObjectContext *)context;

@end
