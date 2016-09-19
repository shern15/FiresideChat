//
//  NSUserDefaults+SHStoredUserDefaults.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "NSUserDefaults+SHStoredUserDefaults.h"

static NSString * _Nonnull kSFCCurrentPhoneNumberKey = @"currentPhoneNumber";

@implementation NSUserDefaults (SHtoredUserDefaults)

+ (NSString *)currentPhoneNumber {
	return [[self standardUserDefaults] objectForKey:kSFCCurrentPhoneNumberKey];
}

+ (void)setCurrentPhoneNumber:(NSString *)phoneNumber {
	[[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:kSFCCurrentPhoneNumberKey];
}

@end
