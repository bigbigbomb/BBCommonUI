//
// Created by brian on 7/25/12.
//
//


#import "BBLabel.h"


@implementation BBLabel

@synthesize insets;

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

- (void)resizeHeightToFitText {
    CGRect frame = [self bounds];
    CGFloat textWidth = frame.size.width - (self.insets.left + self.insets.right);

    CGSize newSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(textWidth, 1000000) lineBreakMode:self.lineBreakMode];
    frame.size.height = newSize.height + self.insets.top + self.insets.bottom;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, frame.size.height);
}

@end