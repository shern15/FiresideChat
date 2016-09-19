//
//  UITableView+SFCAdditions.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "UITableView+SFCAdditions.h"

@implementation UITableView (SFCAdditions)

- (void)scrollToLastRowInSection:(NSUInteger)section {
	if (self.numberOfSections == 0) {
		return;
	}
	NSUInteger numberOfRowsInSection = [self numberOfRowsInSection:section];
	
	if (numberOfRowsInSection == 0) {
		return;
	}
	
	NSUInteger row = numberOfRowsInSection - 1;
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
												inSection:section];
	
	[self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)scrollToBottom {
	if (self.numberOfSections == 0) {
		return;
	}
	
	NSUInteger section = self.numberOfSections - 1;
	
	[self scrollToLastRowInSection:section];
}

@end
