//
//  SFCChat+CoreDataProperties.m
//  
//
//  Created by Sean Hernandez on 9/7/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SFCChat+CoreDataProperties.h"

@implementation SFCChat (CoreDataProperties)

@dynamic lastMessageTime;
@dynamic name;
@dynamic storageId;
@dynamic unreadMessagesCount;
@dynamic messages;
@dynamic participants;

@end
