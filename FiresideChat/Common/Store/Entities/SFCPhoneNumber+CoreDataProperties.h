//
//  SFCPhoneNumber+CoreDataProperties.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SFCPhoneNumber.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFCPhoneNumber (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *value;
@property (nullable, nonatomic, retain) NSString *kind;
@property (nonatomic) BOOL isRegistered;
@property (nullable, nonatomic, retain) SFCContact *contact;

@end

NS_ASSUME_NONNULL_END
