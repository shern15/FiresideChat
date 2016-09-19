//
//  SFCComposeChatTableViewAdapter.m
//  FiresideChat
//
//  Created by Sean Hernandez on 4/25/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import "SFCComposeChatTableViewAdapter.h"

@implementation SFCComposeChatTableViewAdapter

//MARK:UITableView Datasource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([self.dataSource respondsToSelector:@selector(titleForHeaderInSection:)]) {
		return [self.dataSource titleForHeaderInSection:section];
	}
	
	return nil;
}

@end

@implementation SFCTableViewAdapter(SFCDataSourceDelegate)

- (void)dataSourceDidRefreshData:(id<SFCDataSourceInterface>)dataSource
{
	[self.tableView reloadData];
}

@end
