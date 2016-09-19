//
//  SFCCustomTextField.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCCustomTextField.h"

@implementation SFCCustomTextField

-(void)awakeFromNib {
	[super awakeFromNib];
	[self setupView];
}

- (void)prepareForInterfaceBuilder {
	[super prepareForInterfaceBuilder];
	[self setupView];
}


- (void)setupView {
	self.cornerRadius = 5;
	self.inset = 5;
	self.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
	
	self.layer.cornerRadius = self.cornerRadius;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
	return CGRectInset(bounds, self.inset, self.inset);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return CGRectInset(bounds, self.inset, self.inset);
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
	_cornerRadius = cornerRadius;
	self.layer.cornerRadius = cornerRadius;
}

@end
