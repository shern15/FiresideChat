//
//  SFCMessagesTableViewAdapter.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCMessagesTableViewAdapter.h"
#import "SFCMessagesSectionHeaderView.h"


@interface SFCMessagesTableViewAdapter()

@end

@implementation SFCMessagesTableViewAdapter

//MARK:UITableView Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	SFCMessagesSectionHeaderView *view = [SFCMessagesSectionHeaderView new];
	NSString *sectionTitle = [self.dataSource titleForHeaderInSection:section];
	NSString *title = [self dateStringFromSectionString:sectionTitle];
	view.title = title;
	return view;
}

//MARK:SFCDataSource Delegate

//MARK:Helper functions

- (nonnull NSString *)dateStringFromSectionString:(NSString *)sectionString
{
	static dispatch_once_t onceToken;
	static NSDateFormatter *dateFormatter;
	dispatch_once(&onceToken, ^{
		dateFormatter = [NSDateFormatter new];
		dateFormatter.calendar = [NSCalendar currentCalendar];
		NSString *formatTemplate = [NSDateFormatter
									dateFormatFromTemplate:@"MMM dd, YYYY" options:0
									locale:[NSLocale currentLocale]];
		
		dateFormatter.dateFormat = formatTemplate;
	});
	
	NSInteger sectionNumber = [sectionString integerValue];
	NSInteger year = sectionNumber / 10000;
	NSInteger month = (sectionNumber / 100) % 100;
	NSInteger day = (sectionNumber % 100);
	
	NSDateComponents *dateComponents = [NSDateComponents new];
	dateComponents.year = year;
	dateComponents.month = month;
	dateComponents.day = day;
	
	NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
	
	NSString *dateString = [dateFormatter stringFromDate:date];
	
	return dateString;
}

@end
