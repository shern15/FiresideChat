//
//  UITableView+SFCAdditions.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;

@interface UITableView (SFCAdditions)

- (void)scrollToLastRowInSection:(NSUInteger)section;
- (void)scrollToBottom;

@end
