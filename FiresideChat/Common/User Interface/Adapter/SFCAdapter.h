//
//  SFCDataSoourceAdapterProtocol.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCObjectConsumer.h"
#import "SFCAdapterDelegate.h"

@protocol SFCAdapter <NSObject>

@property (nullable, nonatomic, weak) id<SFCAdapterDelegate> delegate;

- (void)refreshDataInViewWithPredicate:(nullable NSPredicate *)predicate;
- (void)refreshDataInView;
@end
