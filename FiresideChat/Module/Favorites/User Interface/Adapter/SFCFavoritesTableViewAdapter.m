//
//  SFCFavoritesTableViewAdapter.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCFavoritesTableViewAdapter.h"
#import "SFCContact.h"

@implementation SFCFavoritesTableViewAdapter

//MARK: UITableView Datasource
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	SFCContact *contact = [self.dataSource objectAtIndexPath:indexPath];
	if (contact) {
		contact.isFavorite = NO;
		if([self.delegate respondsToSelector:@selector(adapter:didRemoveRowAtIndexPath:withObject:)]) {
			[self.delegate adapter:self didRemoveRowAtIndexPath:indexPath withObject:contact];
		}
	}
}

@end
