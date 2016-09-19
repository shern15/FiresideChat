//
//  SFCAddParticipantsTableViewAdapter.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCAddParticipantsTableViewAdapter.h"

@implementation SFCAddParticipantsTableViewAdapter

//MARK: UITableView Delegate
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
