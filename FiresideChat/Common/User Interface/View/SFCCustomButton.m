//
//  SFCCustomButton.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCCustomButton.h"

@implementation SFCCustomButton

- (void)awakeFromNib {
	[super awakeFromNib];
	[self setupView];
}

- (void)prepareForInterfaceBuilder {
	[super prepareForInterfaceBuilder];
	[self setupView];
}

- (void)setupView {
	self.layer.cornerRadius = self.cornerRadius;
	
	[self addTarget:self action:@selector(scaleToSmallAnimation) forControlEvents:UIControlEventTouchDown];
	[self addTarget:self action:@selector(scaleToSmallAnimation) forControlEvents:UIControlEventTouchDragEnter];
	[self addTarget:self action:@selector(scaleToDefaultAnimation) forControlEvents:UIControlEventTouchDragExit];
	[self addTarget:self action:@selector(springScaleAnimation) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
	_cornerRadius = cornerRadius;
	self.layer.cornerRadius = cornerRadius;
}

- (void)setFontColor:(UIColor *)fontColor {
	_fontColor = fontColor;
	self.tintColor = fontColor;
}

- (void)dealloc {
	[self removeTarget:self action:@selector(scaleToSmallAnimation) forControlEvents:UIControlEventTouchDown];
	[self removeTarget:self action:@selector(scaleToSmallAnimation) forControlEvents:UIControlEventTouchDragEnter];
	[self removeTarget:self action:@selector(scaleToDefaultAnimation) forControlEvents:UIControlEventTouchDragExit];
	[self removeTarget:self action:@selector(springScaleAnimation) forControlEvents:UIControlEventTouchUpInside];
}
@end
