//
//  SFCFirebaseModel.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Foundation;

@class NSManagedObjectContext;

@protocol SFCFirebaseModel <NSObject>

- (void)uploadToFirebaseRoot:(FIRDatabaseReference *)databaseRoot withContext:(NSManagedObjectContext *)context;
@optional
- (void)removeFromFirebaseRoot:(FIRDatabaseReference *)databaseRoot withContext:(NSManagedObjectContext *)context;
@end
