//
//  SFCSelectContactsTableViewAdapter.m
//  FiresideChat
//
//  Created by Sean Hernandez on 9/15/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import "SFCSelectContactsTableViewAdapter.h"

@implementation SFCSelectContactsTableViewAdapter

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	if ([self.dataSource respondsToSelector:@selector(removeObjectAtIndexPath:)]) {
		[self.dataSource removeObjectAtIndexPath:indexPath];
	}
}


@end
