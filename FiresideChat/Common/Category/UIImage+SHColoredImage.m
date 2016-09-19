//
//  UIImage+SHColoredImage.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "UIImage+SHColoredImage.h"

@implementation UIImage (SHColoredImage)

- (nonnull UIImage *)colorImageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
	
	UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawInRect:imageRect];
	
	CGContextSetRGBFillColor(context, red, green, blue, alpha);
	CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
	CGContextFillRect(context, imageRect);
	
	UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if (resultImage) {
		return resultImage;
	}
	
	return self;
}

- (nonnull UIImage *)colorImageWithColor:(UIColor *)color {
	CGFloat red, green, blue, alpha;
	
	[color getRed:&red green:&green blue:&blue alpha:&alpha];
	
	return [self colorImageWithRed:red green:green blue:blue alpha:alpha];
}

@end
