//
//  UINavigationBar+SFCNavigationBarAppearance.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "UINavigationBar+SFCNavigationBarAppearance.h"

@implementation UINavigationBar (SFCNavigationBarAppearance)

+ (void)stylizeNavigationBarAppearance
{
	[[self appearance] setTintColor:[UIColor navigationBarItemTintColor]];
	[[self appearance] setBarTintColor:[UIColor navigationBarTintColor]];
	[[self appearance]
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

@end
