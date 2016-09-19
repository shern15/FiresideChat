//
//  SFCPhoneNumber.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import <Contacts/Contacts.h>
#import "SFCPhoneNumber.h"
#import "SFCContact.h"

@interface SFCPhoneNumber ()

+ (NSString *)removeFormattingForPhoneNumber:(CNPhoneNumber *)phoneNumber;

@end

@implementation SFCPhoneNumber

+ (nonnull instancetype)phoneNumberWithContactPhoneNumber:(CNPhoneNumber *)contactPhoneNumber
							   andContactPhoneNumberOwner:(SFCContact *)ownerContact
												  andKind:(nullable NSString *)kind
								   inManagedObjectContext:(NSManagedObjectContext *)context
{
	SFCPhoneNumber *coreDataPhoneNumber = [NSEntityDescription
										   insertNewObjectForEntityForName:kSFCPhoneNumberEntityName
										   inManagedObjectContext:context];
	
	coreDataPhoneNumber.value = [self removeFormattingForPhoneNumber:contactPhoneNumber];
	coreDataPhoneNumber.contact = ownerContact;
	if (kind) {
		coreDataPhoneNumber.kind = kind;
	}
	
	return coreDataPhoneNumber;
}

- (void)updatePhoneNumberWithCNPhoneNumber:(CNPhoneNumber *)phoneNumber
								andContact:(SFCContact *)contact
								   andKind:(nullable NSString *)kind {
	self.value = [[self class] removeFormattingForPhoneNumber:phoneNumber];
	if (contact) {
		self.contact = contact;
	}
	
	if(!contact) {
		printf("\nDebugContact Nil");
	}
	
	if (kind) {
		self.kind = kind;
	}
}


+ (NSString *)removeFormattingForPhoneNumber:(CNPhoneNumber *)phoneNumber
{
	NSString *regexString = @"[()\\-\\s]*";
	NSString *phoneNumberString = phoneNumber.stringValue;
	return [phoneNumberString stringByReplacingOccurrencesOfString:regexString
														withString:@""
														   options:NSRegularExpressionSearch
																range:NSMakeRange(0, phoneNumberString.length)];
}

@end
