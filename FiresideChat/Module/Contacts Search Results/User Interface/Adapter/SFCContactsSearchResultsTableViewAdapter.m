//
//  SFCContactsSearchResultsTableViewAdapter.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCContactsSearchResultsTableViewAdapter.h"

@implementation SFCContactsSearchResultsTableViewAdapter

- (void)dataSourceDidRefreshData:(id<SFCDataSourceInterface>)dataSource {
	[self.tableView reloadData];
}

@end
