//
//  SFCContactImporter.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;
#import <Contacts/Contacts.h>

@class NSManagedObject;
static NSString * _Nonnull kSFCDidFetchContactsNotification = @"didFetchContactsNotification";
@interface SFCContactImporter : NSObject

- (nonnull instancetype)initWithManagedObjectContext:(nonnull NSManagedObjectContext *)context;
- (void)fetchContacts;
- (void)addObservers;
- (nonnull instancetype)init NS_UNAVAILABLE;

@end
