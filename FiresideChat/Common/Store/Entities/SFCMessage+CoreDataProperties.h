//
//  SFCMessage+CoreDataProperties.h
//  
//
//  Created by Sean Hernandez.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SFCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFCMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sectionIdentifier;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) SFCChat *chat;
@property (nullable, nonatomic, retain) SFCContact *sender;

@end

NS_ASSUME_NONNULL_END
