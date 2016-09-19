//
//  SFCFetchedResultsControllerDataSource.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
@import CoreData;
#import "SFCDataSourceInterface.h"

@class SFCMessage;
@protocol SFCAdapter;

@interface SFCFetchedResultsControllerDataSource : NSObject<SFCDataSourceInterface, NSFetchedResultsControllerDelegate>

- (nonnull instancetype)initWithFetchedResultsController:(nonnull NSFetchedResultsController *)fetchedResultsController
									  andCelllIdentifier:(nonnull NSString *)cellIdentifier;

- (nonnull instancetype)init NS_UNAVAILABLE;

@end
