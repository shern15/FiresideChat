//
//  SFCChatTableViewAdapter.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCTableViewAdapter.h"

@interface SFCTableViewAdapter()
{
	__nullable __weak id<SFCAdapterDelegate> _delegate;
}

@property (nullable, nonatomic, unsafe_unretained) UITableView *tableView;
@property (nullable, nonatomic) id<SFCDataSourceInterface> dataSource;

@end

@implementation SFCTableViewAdapter
@synthesize delegate = _delegate;

- (nonnull instancetype)initWithTableView:(UITableView *)tableView
							andDataSource:(id<SFCDataSourceInterface>)dataSource
{
	if ((self = [super init])) {
		_tableView = tableView;
		_dataSource = dataSource;
		
		_dataSource.delegate = self;
		_tableView.dataSource = self;
		_tableView.delegate = self;
	}
	
	return self;
}

//MARK:TableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_dataSource numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self.dataSource respondsToSelector:@selector(numberOfSections)]) {
		return [_dataSource numberOfSections];
	}
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self configuredCellAtIndexPath:indexPath];
}


//MARK: SFCAdapter
- (void)refreshDataInView {
	[_dataSource refreshDataInSource];
}

- (void)refreshDataInViewWithPredicate:(NSPredicate *)predicate {
	[_dataSource refreshDataInSourceWithPredicate:predicate];
}

- (void)dataSourceWillChangeContent:(id<SFCDataSourceInterface>)dataSource {
	[_tableView beginUpdates];
}

- (void)dataSourceDidChangeContent:(id<SFCDataSourceInterface>)dataSource {
	[_tableView endUpdates];
}

- (void)dataSource:(id<SFCDataSourceInterface>)dataSource didUpdateRowAtIndexPath:(NSIndexPath *)indexPath {
	[self configuredCellAtIndexPath:indexPath];
	[_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSource:(id<SFCDataSourceInterface>)dataSource didInsertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPathsArray {
	[_tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSource:(id<SFCDataSourceInterface>)dataSource didDeleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPathsArray {
	[_tableView deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSource:(id<SFCDataSourceInterface>)dataSource didMoveRowsFromIndexPaths:(NSArray<NSIndexPath *> *)indexPathsArray toNewIndexPaths:(NSArray<NSIndexPath *> *)newIndexPathsArray
{
	[self.tableView deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView insertRowsAtIndexPaths:newIndexPathsArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSource:(id<SFCDataSourceInterface>)dataSource didInsertSectionsAtIndex:(NSUInteger)sectionIndex {
	[_tableView insertSections:[[NSIndexSet alloc] initWithIndex:sectionIndex]
			  withRowAnimation:UITableViewRowAnimationFade];

}

- (void)dataSource:(id<SFCDataSourceInterface>)dataSource didDeleteSectionsAtIndex:(NSUInteger)sectionIndex {
	[_tableView deleteSections:[[NSIndexSet alloc] initWithIndex:sectionIndex]
			  withRowAnimation:UITableViewRowAnimationFade];

}

//MARK:UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([_delegate respondsToSelector:@selector(adapter:didSelectRowAtIndexPath:WithObject:)]) {
		id object = [_dataSource objectAtIndexPath:indexPath];
		[_delegate adapter:self didSelectRowAtIndexPath:indexPath WithObject:object];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([_delegate respondsToSelector:@selector(adapter:didDeselectRowAtIndexPath:WithObject:)]) {
		id object = [_dataSource objectAtIndexPath:indexPath];
		[_delegate adapter:self didDeselectRowAtIndexPath:indexPath WithObject:object];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	if ([_delegate respondsToSelector:@selector(adapter:accessoryButtonTappedForRowWithIndexPath:withObject:)]) {
		id object = [_dataSource objectAtIndexPath:indexPath];
		[_delegate adapter:self accessoryButtonTappedForRowWithIndexPath:indexPath withObject:object];
	}
}

//MARK:Helper Methods
- (UITableViewCell *)configuredCellAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:[_dataSource cellIdentifier] forIndexPath:indexPath];
	if ([cell conformsToProtocol:@protocol(SFCObjectConsumer)]) {
		id object = [_dataSource objectAtIndexPath:indexPath];
		[(id<SFCObjectConsumer>)cell setObject:object];
	}
	
	return cell;
}

@end
