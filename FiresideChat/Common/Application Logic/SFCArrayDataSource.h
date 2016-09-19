//
//  SFCArrayDataSource.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import "SFCDataSourceInterface.h"

@interface SFCArrayDataSource : NSObject<SFCDataSourceInterface>

- (nonnull instancetype)initWithObjectsArray:(nonnull NSArray *)objectsArray
								 andCelllIdentifier:(nonnull NSString *)cellIdentifier;

@end
