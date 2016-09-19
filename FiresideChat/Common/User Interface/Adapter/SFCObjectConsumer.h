//
//  SFCObjectConsuming.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;

@protocol SFCObjectConsumer <NSObject>
- (void)setObject:(id)object;
@optional
- (id)object;
@end
