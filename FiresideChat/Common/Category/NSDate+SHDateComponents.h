//
//  NSDate+SHDateComponents.h
//  FiresideChat
//
//  Created by Sean Hernandez

#import <Foundation/Foundation.h>

@interface NSDate (SHDateComponents)

+ (NSTimeInterval)millisecondsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSTimeInterval)millisecondsFromTimeInterval:(NSTimeInterval)fromTimeInterval toTimeInterval:(NSTimeInterval)toTimeInterval;

@end
