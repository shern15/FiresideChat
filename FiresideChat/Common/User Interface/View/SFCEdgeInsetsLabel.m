//
//  SFCInsetsLabel.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCEdgeInsetsLabel.h"

@implementation SFCEdgeInsetsLabel

- (void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets {
	_labelEdgeInsets = labelEdgeInsets;
	[self invalidateIntrinsicContentSize];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	CGRect textRect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, _labelEdgeInsets)
						limitedToNumberOfLines:numberOfLines];
	
	textRect.origin.x -= _labelEdgeInsets.left;
	textRect.origin.y -= _labelEdgeInsets.top;
	textRect.size.width += (_labelEdgeInsets.left + _labelEdgeInsets.right);
	textRect.size.height += (_labelEdgeInsets.top + _labelEdgeInsets.bottom);
	
	return textRect;
}

- (void)drawTextInRect:(CGRect)rect
{
	[super drawTextInRect:UIEdgeInsetsInsetRect(rect, _labelEdgeInsets)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
