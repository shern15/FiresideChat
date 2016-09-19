//
//  NSDate+SHDateComponents.m
//  FiresideChat
//
//  Created by Sean Hernandez
//

#import "NSDate+SHDateComponents.h"

@implementation NSDate (SHDateComponents)

+ (NSTimeInterval)millisecondsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *calendarComponents = [calendar components:NSCalendarUnitNanosecond fromDate:fromDate toDate:toDate options:0];
	
	return ((NSTimeInterval)calendarComponents.nanosecond/1000000);
}

+ (NSTimeInterval)millisecondsFromTimeInterval:(NSTimeInterval)fromTimeInterval toTimeInterval:(NSTimeInterval)toTimeInterval
{
	NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:fromTimeInterval];
	NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:toTimeInterval];
	
	return [self millisecondsFromDate:fromDate toDate:toDate];
}

@end
