//
//  UIImage+SHMirrorImage.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "UIImage+SHMirrorImage.h"

@implementation UIImage (SHMirrorImage)

- (nonnull UIImage *)upMirroredImage {
	CGImageRef cgImage = self.CGImage;
	if (cgImage) {
		return [UIImage imageWithCGImage:cgImage scale:self.scale orientation:UIImageOrientationUpMirrored];
	}
	
	return self;
}

@end
