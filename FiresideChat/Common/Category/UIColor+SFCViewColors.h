//
//  UIColor+SFCViewColors.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;

#import "UIColor+SFCViewColors.h"
#import "UIColor+HexString.h"

static NSString * const kSecondaryColorHex = @"#FF9800";
static NSString * const kNavigationBarColorHex = @"#FF5722";
static NSString * const kBarItemTintColorHex = @"#FFFF00";

@interface UIColor (SFCViewColors)

+ (UIColor *)incomingBubbleImageColor;
+ (UIColor *)outgoingBubbleImageColor;
+ (UIColor *)sectionHeaderBackgroundColor;
+ (UIColor *)unreadCountLabelColor;
+ (UIColor *)navigationBarTintColor;
+ (UIColor *)navigationBarItemTintColor;
+ (UIColor *)secondaryColor;


@end
