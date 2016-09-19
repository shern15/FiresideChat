//
//  UIColor+SFCViewColors.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "UIColor+SFCViewColors.h"

@implementation UIColor (SFCViewColors)

+ (UIColor *)incomingBubbleImageColor {
	return [UIColor colorWithRed:225.0f/255 green:225.0f/255 blue:225.0f/255 alpha:1];
}

+ (UIColor *)outgoingBubbleImageColor {
	return [UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:229.0f/255 alpha:1];
}

+ (UIColor *)sectionHeaderBackgroundColor {
	return [UIColor colorWithRed:153.0f/255 green:204.0f/255 blue:255.0f/255 alpha:1.0f];
}

+ (UIColor *)unreadCountLabelColor {
	return [UIColor colorWithRed:25.0f/255 green:175.0f/255 blue:225.0f/255 alpha:1.0f];
}

+ (UIColor *)navigationBarTintColor
{
	return [UIColor colorWithHexString:kNavigationBarColorHex];
}

+ (UIColor *)navigationBarItemTintColor
{
	return [UIColor colorWithHexString:kBarItemTintColorHex];
}

+ (UIColor *)secondaryColor
{
	return [UIColor colorWithHexString:kSecondaryColorHex];
}

@end
