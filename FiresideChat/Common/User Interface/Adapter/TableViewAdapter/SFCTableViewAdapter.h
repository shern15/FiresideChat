//
//  SFCChatTableViewAdapter.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;
#import "SFCAdapter.h"
#import "SFCDataSourceDelegate.h"
#import "SFCDataSourceInterface.h"

@interface SFCTableViewAdapter : NSObject<SFCAdapter, SFCDataSourceDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nullable, nonatomic, readonly) UITableView *tableView;
@property (nullable, nonatomic, readonly) id<SFCDataSourceInterface> dataSource;


- (nonnull instancetype)initWithTableView:(nonnull UITableView *)tableView
							andDataSource:(nonnull id<SFCDataSourceInterface>)dataSource;

- (nonnull instancetype)init NS_UNAVAILABLE;
@end
