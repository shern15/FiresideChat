//
//  SFCArrayDataSource.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCArrayDataSource.h"
#import "SFCDataSourceDelegate.h"

@interface SFCArrayDataSource()
{
	_Nullable __weak id<SFCDataSourceDelegate> delegate;
}

@property (nonnull, nonatomic) NSMutableArray *allObjectsArray;
@property (nonnull, nonatomic) NSMutableArray *dataSourceArray;
@property (nonnull, nonatomic) NSString *cellIdentifier;

@end

@implementation SFCArrayDataSource
@synthesize delegate = _delegate;

- (nonnull instancetype)initWithObjectsArray:(NSArray *)objectsArray
				   andCelllIdentifier:(NSString *)cellIdentifier
{
	if ((self = [super init])) {
		_allObjectsArray = [objectsArray mutableCopy];;
		_dataSourceArray = [_allObjectsArray mutableCopy];
		_cellIdentifier = cellIdentifier;
	}
	
	return self;
}

//MARK:SFCDataSource Interface
- (NSArray *)fetchedObjects
{
	return [NSArray arrayWithArray:_dataSourceArray];
}

-(void)refreshDataInSource
{
	_dataSourceArray = [[NSArray arrayWithArray:_allObjectsArray] mutableCopy];
	if ([_delegate respondsToSelector:@selector(dataSourceDidRefreshData:)]) {
		[_delegate dataSourceDidRefreshData:self];
	}
}

- (void)refreshDataInSourceWithPredicate:(NSPredicate *)predicate {
	if (predicate) {
		_dataSourceArray = [[_allObjectsArray filteredArrayUsingPredicate:predicate] mutableCopy];
	} else {
		_dataSourceArray = [[NSArray arrayWithArray:_allObjectsArray] mutableCopy];
	}
	if ([_delegate respondsToSelector:@selector(dataSourceDidRefreshData:)]) {
		[_delegate dataSourceDidRefreshData:self];
	}
}

- (NSString *)cellIdentifier {
	return _cellIdentifier;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section
{
	return _dataSourceArray.count;
}

- (NSIndexPath *)indexPathForObject:(id)object {
	return [NSIndexPath indexPathWithIndex:[_dataSourceArray indexOfObject:object]];
}

- (nullable id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return [_dataSourceArray objectAtIndex:indexPath.row];
}

- (void)removeObject:(id)object {
	if ([_dataSourceArray containsObject:object])
	{
		[self prepareForDataSourceModification];
		
		NSIndexPath *indexPath = [self indexPathForObject:object];
		[_allObjectsArray removeObject:object];
		[_dataSourceArray removeObject:object];
		
		[self didRemoveObjectAtIndexPath:indexPath];
	}
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
	[self prepareForDataSourceModification];
	
	[_allObjectsArray removeObjectAtIndex:indexPath.row];
	[_dataSourceArray removeObjectAtIndex:indexPath.row];
	
	[self didRemoveObjectAtIndexPath:indexPath];
}

- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	if (![_dataSourceArray containsObject:object])
	{
		[self prepareForDataSourceModification];
		
		NSIndexPath *indexPath = [self indexPathForObject:object];
		[_allObjectsArray insertObject:object atIndex:indexPath.row];
		[_dataSourceArray insertObject:object atIndex:indexPath.row];
		
		[self didInsertObjectAtIndexPath:indexPath];
	}

}

- (void)insertObject:(id)object {
	if (![_dataSourceArray containsObject:object])
	{
		[self prepareForDataSourceModification];
		
		[_allObjectsArray addObject:object];
		[_dataSourceArray addObject:object];
		
		NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:_dataSourceArray.count-1];
		
		[self didInsertObjectAtIndexPath:indexPath];
	}
}

- (void)prepareForDataSourceModification
{
	if ([_delegate respondsToSelector:@selector(dataSourceWillChangeContent:)]) {
		[_delegate dataSourceWillChangeContent:self];
	}
}

- (void)didRemoveObjectAtIndexPath:(NSIndexPath *)indexPath
{
	if ([_delegate respondsToSelector:@selector(dataSource:didDeleteRowsAtIndexPaths:)]) {
		[_delegate dataSource:self didDeleteRowsAtIndexPaths:@[indexPath]];
	}
	if ([_delegate respondsToSelector:@selector(dataSourceDidChangeContent:)]) {
		[_delegate dataSourceDidChangeContent:self];
	}
}

- (void)didInsertObjectAtIndexPath:(NSIndexPath *)indexPath
{
	if ([_delegate respondsToSelector:@selector(dataSource:didInsertRowsAtIndexPaths:)]) {
		[_delegate dataSource:self didInsertRowsAtIndexPaths:@[indexPath]];
	}
	if ([_delegate respondsToSelector:@selector(dataSourceDidChangeContent:)]) {
		[_delegate dataSourceDidChangeContent:self];
	}
}


@end
