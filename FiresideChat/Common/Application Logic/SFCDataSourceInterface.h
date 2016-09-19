//
//  SFCDataSourceInterface.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;

@protocol SFCDataSourceDelegate;
@protocol SFCDataSourceInterface <NSObject>
@property (nullable, nonatomic, weak) id<SFCDataSourceDelegate> delegate;

- (nonnull NSArray *)fetchedObjects;
- (void)refreshDataInSource;
- (void)refreshDataInSourceWithPredicate:(nullable NSPredicate *)predicate;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (nonnull NSString *)cellIdentifier;
- (nullable id)objectAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (nullable NSIndexPath *)indexPathForObject:(nonnull id)object;
@optional
- (NSUInteger)numberOfSections;
- (void)insertObject:(nonnull id)object;
- (void)insertObject:(nonnull id)object atIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)removeObject:(nonnull id)object;
- (void)removeObjectAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (nullable NSString *)titleForHeaderInSection:(NSUInteger)section;
- (nullable NSString *)titleForRowInIndexPath:(nonnull NSIndexPath *)indexPath;

@end
