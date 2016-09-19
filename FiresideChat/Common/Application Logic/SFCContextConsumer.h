//
//  SFCContextConsumer.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;

@class NSManagedObjectContext;

@protocol SFCContextConsumer <NSObject>

@property (nonnull, nonatomic) NSManagedObjectContext *context;

@end
