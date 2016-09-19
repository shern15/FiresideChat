//
//  SFCMessagesParticipantsHeaderView.h
//  FiresideChat
//
//  Created by Sean Hernandez on 9/14/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCMessagesParticipantsHeaderView : UIView

-(void)setParticipantsNamesWithArray:(NSArray<NSString *> *)namesArray;
-(void)setParticipantsNamesWithString:(NSString *)namesString;

@end
