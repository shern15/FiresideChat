//
//  UIImage+SHColoredImage.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import UIKit;

@interface UIImage (SHColoredImage)

- (nonnull UIImage *)colorImageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (nonnull UIImage *)colorImageWithColor:(nonnull UIColor *)color;


@end
