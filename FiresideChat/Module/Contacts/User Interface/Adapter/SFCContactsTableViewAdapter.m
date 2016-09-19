//
//  SFCContactsTableViewAdapter.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCContactsTableViewAdapter.h"

@implementation SFCContactsTableViewAdapter

//MARK: UITableView DataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([self.dataSource respondsToSelector:@selector(titleForHeaderInSection:)]) {
		return [self.dataSource titleForHeaderInSection:section];
	}
	
	return nil;
}

//MARK: UITableView Delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

@implementation SFCContactsTableViewAdapter (SFCDataSourceDelegate)

//- (void)dataSourceDidRefreshData:(id<SFCDataSourceInterface>)dataSource
//{
//	[self.tableView reloadData];
//}

@end