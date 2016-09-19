//
//  SFCMessage.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCMessage.h"
#import "SFCChat.h"
#import "SFCContact.h"
#import "SFCAppDelegate.h"



@interface SFCMessage()

@property (nonnull, nonatomic) NSDate *primitiveTimestamp;
@property (nonnull, nonatomic) NSString *primitiveSectionIdentifier;

@end

@implementation SFCMessage
@dynamic primitiveSectionIdentifier;
@dynamic primitiveTimestamp;

+ (nonnull instancetype)messageWithText:(NSString *)text timestamp:(NSDate *)timestamp
				 inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
	SFCMessage *message = [NSEntityDescription insertNewObjectForEntityForName:kSFCMessageEntityName
														inManagedObjectContext:managedObjectContext];
	message.text = text;
	message.timestamp = timestamp ? timestamp : [NSDate new];
	
	return message;
}

// Insert code here to add functionality to your managed object subclass
- (BOOL)isIncoming {
	return self.sender != nil;
}

//MARK:Section Identifier Getter
- (NSString *)sectionIdentifier {
	[self willAccessValueForKey:kSFCSectionIdentifierKey];
	NSString *cachedSectionIdentifier = self.primitiveSectionIdentifier;
	[self didAccessValueForKey:kSFCSectionIdentifierKey];
	
	if (!cachedSectionIdentifier) {
		NSCalendar *calendar = [NSCalendar currentCalendar];
		
		NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.timestamp];
		
		cachedSectionIdentifier = [NSString stringWithFormat:@"%ld", (components.year * 10000 + components.month * 100 + components.day)];
		
		self.primitiveSectionIdentifier = cachedSectionIdentifier;
	}
	
	return cachedSectionIdentifier;
}

//MARK:Timestamp setter
- (void)setTimestamp:(NSDate *)newTimestamp {
	[self willChangeValueForKey:kSFCTimestampKey];
	self.primitiveTimestamp = newTimestamp;
	[self didChangeValueForKey:kSFCTimestampKey];
	
	//Invalidate Section Identifier;
	self.sectionIdentifier = nil;
}

//MARK:Key path dependencies
+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier {
	return [NSSet setWithObject:kSFCTimestampKey];
}

@end