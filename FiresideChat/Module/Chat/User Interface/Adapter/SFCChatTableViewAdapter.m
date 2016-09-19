//
//  SFCChatTableViewAdapter.m
//  FiresideChat
//
//  Created by Sean Hernandez on 9/6/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import "SFCChatTableViewAdapter.h"

@implementation SFCChatTableViewAdapter

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if([self.dataSource respondsToSelector:@selector(removeObjectAtIndexPath:)]) {
			id object = [self.dataSource objectAtIndexPath:indexPath];
			[self.dataSource removeObjectAtIndexPath:indexPath];
			if([self.delegate respondsToSelector:@selector(adapter:didRemoveRowAtIndexPath:withObject:)]) {
				[self.delegate adapter:self didRemoveRowAtIndexPath:indexPath withObject:object];
			}
		}
	}
}

@end
