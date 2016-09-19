//
//  NSUserDefaults+SHStoredUserDefaults.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (SHStoredUserDefaults)

+ (nullable NSString *)currentPhoneNumber;

+ (void)setCurrentPhoneNumber:(nonnull NSString *)phoneNumber;

@end
