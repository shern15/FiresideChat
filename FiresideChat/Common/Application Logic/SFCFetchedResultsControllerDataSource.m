//
//  SFCFetchedResultsControllerDataSource.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import CoreData;
#import "SFCFetchedResultsControllerDataSource.h"
#import "SFCMessage.h"
#import "SFCMessageTableViewCell.h"
#import "SFCDataSourceDelegate.h"

@interface SFCFetchedResultsControllerDataSource()
{
	__weak id<SFCDataSourceDelegate> _delegate;
}

@property (nonnull, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonnull, nonatomic) NSString *cellIdentifier;

@end

@implementation SFCFetchedResultsControllerDataSource
@synthesize delegate = _delegate;

- (nonnull instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
									  andCelllIdentifier:(NSString *)cellIdentifier
{
	if ((self = [super init])) {
		_fetchedResultsController = fetchedResultsController;
		_fetchedResultsController.delegate = self;
		_cellIdentifier = cellIdentifier;
	}
	
	return self;
}

- (nonnull id <NSFetchedResultsSectionInfo>)sectionInfoForSection:(NSInteger)section {
	return self.fetchedResultsController.sections[section];
}

- (NSArray *)fetchedObjects {
	if (!self.fetchedResultsController.fetchedObjects) {
		return @[];
	}
	
	return [NSArray arrayWithArray:self.fetchedResultsController.fetchedObjects];
}

- (void)refreshDataInSource {
	[self performDataFetch];
}

- (void)refreshDataInSourceWithPredicate:(nullable NSPredicate *)predicate {
	_fetchedResultsController.fetchRequest.predicate = predicate;
	[self performDataFetch];
}

//MARK: DataSource Interface

- (NSString *)cellIdentifier {
	return _cellIdentifier;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section
{
	return _fetchedResultsController.sections[section].numberOfObjects;
}

- (NSUInteger)numberOfSections {
	return _fetchedResultsController.sections.count;
}

- (NSIndexPath *)indexPathForObject:(id)object {
	return [_fetchedResultsController indexPathForObject:object];
}

- (nullable id)objectAtIndexPath:(NSIndexPath *)indexPath {
	
	return [_fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSString *)titleForHeaderInSection:(NSUInteger)section {
	return self.fetchedResultsController.sections[section].name;
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
	id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[_fetchedResultsController.managedObjectContext performBlock:^{
		[_fetchedResultsController.managedObjectContext deleteObject:object];
	}];
}

//MARK: NSFetchedController delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	if ([_delegate respondsToSelector:@selector(dataSourceWillChangeContent:)]) {
		[_delegate dataSourceWillChangeContent:self];
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	if ([_delegate respondsToSelector:@selector(dataSourceDidChangeContent:)]) {
		[_delegate dataSourceDidChangeContent:self];
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	if (type == NSFetchedResultsChangeUpdate) {
		if ([_delegate respondsToSelector:@selector(dataSource:didUpdateRowAtIndexPath:withObject:)]) {
			id object = [self objectAtIndexPath:indexPath];
			[_delegate dataSource:self didUpdateRowAtIndexPath:indexPath withObject:object];
		}
	}
	else if (type == NSFetchedResultsChangeInsert) {
		if ([_delegate respondsToSelector:@selector(dataSource:didInsertRowsAtIndexPaths:)]) {
			[_delegate dataSource:self didInsertRowsAtIndexPaths:@[newIndexPath]];
		}
	}
	else if (type == NSFetchedResultsChangeMove) {
		if ([_delegate respondsToSelector:@selector(dataSource:didMoveRowsFromIndexPaths:toNewIndexPaths:)]) {
			[_delegate dataSource:self didMoveRowsFromIndexPaths:@[indexPath] toNewIndexPaths:@[newIndexPath]];
		}
	}
	else if (type == NSFetchedResultsChangeDelete) {
		if ([_delegate respondsToSelector:@selector(dataSource:didDeleteRowsAtIndexPaths:)]) {
			[_delegate dataSource:self didDeleteRowsAtIndexPaths:@[indexPath]];
		}
	}

}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	if (type == NSFetchedResultsChangeInsert) {
		if ([_delegate respondsToSelector:@selector(dataSource:didInsertSectionsAtIndex:)]) {
			[_delegate dataSource:self didInsertSectionsAtIndex:sectionIndex];
		}
	}
	else if (type == NSFetchedResultsChangeDelete) {
		if ([_delegate respondsToSelector:@selector(dataSource:didDeleteSectionsAtIndex:)]) {
			[_delegate dataSource:self didDeleteSectionsAtIndex:sectionIndex];
		}
	}
}

//MARK: Helper functions
- (nullable NSArray *)objectsInSection:(NSUInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
	
	return sectionInfo.objects;
}

- (void)performDataFetch
{
	__block NSError *error;
	[_fetchedResultsController performFetch:&error];
	if (error) {
		NSLog(@"Error reloading data: \n%@\nErrorUserInfo:\n\n%@\n\n",error,error.userInfo);
		return;
	}
	
	if([_delegate respondsToSelector:@selector(dataSourceDidRefreshData:)]) {
		[_delegate dataSourceDidRefreshData:self];
	}

}

@end
