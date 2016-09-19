//
//  SFCCustomButton.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "UIButton+SHButtonAnimation.h"

IB_DESIGNABLE
@interface SFCCustomButton : UIButton

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic, nonnull) IBInspectable UIColor* fontColor;

@end
