//
//  SFCDataSourceDelegate.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;

@protocol SFCDataSourceInterface;

@protocol SFCDataSourceDelegate <NSObject>
@optional
- (void)dataSourceDidRefreshData:(nonnull id<SFCDataSourceInterface>)dataSource;
- (void)dataSourceWillChangeContent:(nonnull id<SFCDataSourceInterface>)dataSource;
- (void)dataSourceDidChangeContent:(nonnull id<SFCDataSourceInterface>)dataSource;
- (void)dataSource:(nonnull id<SFCDataSourceInterface>)dataSource didUpdateRowAtIndexPath:(nonnull NSIndexPath *)indexPath withObject:(nonnull id)object;
- (void)dataSource:(nonnull id<SFCDataSourceInterface>)dataSource didMoveRowsFromIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPathsArray toNewIndexPaths:(nonnull NSArray<NSIndexPath *> *)newIndexPaths;
- (void)dataSource:(nonnull id<SFCDataSourceInterface>)dataSource didDeleteRowsAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPathsArray;
- (void)dataSource:(nonnull id<SFCDataSourceInterface>)dataSource didInsertRowsAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPathsArray;
- (void)dataSource:(nonnull id<SFCDataSourceInterface>)dataSource didInsertSectionsAtIndex:(NSUInteger)sectionIndex;
- (void)dataSource:(nonnull id<SFCDataSourceInterface>)dataSource didDeleteSectionsAtIndex:(NSUInteger)sectionIndex;

@end
