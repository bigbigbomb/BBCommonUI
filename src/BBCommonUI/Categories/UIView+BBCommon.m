//
//  Created by Lee Fastenau on 8/2/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIView+BBCommon.h"
#import "UIImage+BBCommon.h"

@implementation UIView(BBCommon)

- (UIView *)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment verticalAlignment:(BBVerticalAlignment)verticalAlignment superview:(UIView *)superview {
    DAssert(superview, @"superview cannot be nil when horizontally and vertically aligning a UIView [%@]", [[self class] description]);
    BBMoveFrame(self, BBAlignedOrigin(horizontalAlignment, BBW(superview), BBW(self)), BBAlignedOrigin(verticalAlignment, BBH(superview), BBH(self)));
    return self;
}

- (UIView *)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment verticalAlignment:(BBVerticalAlignment)verticalAlignment {
    return [self horizontalAlignment:horizontalAlignment verticalAlignment:verticalAlignment superview:self.superview];
}

- (UIView *)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment superview:(UIView *)superview {
    DAssert(superview, @"superview cannot be nil when horizontally aligning a UIView [%@]", [[self class] description]);
    BBMoveFrame(self, BBAlignedOrigin(horizontalAlignment, BBW(superview), BBW(self)), BBY(self));
    return self;
}

- (UIView *)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment {
    return [self horizontalAlignment:horizontalAlignment superview:self.superview];
}

- (UIView *)verticalAlignment:(BBVerticalAlignment)verticalAlignment superview:(UIView *)superview {
    DAssert(superview, @"superview cannot be nil when vertically aligning a UIView [%@]", [[self class] description]);
    BBMoveFrame(self, BBX(self), BBAlignedOrigin(verticalAlignment, BBH(superview), BBH(self)));
    return self;
}

- (UIView *)verticalAlignment:(BBVerticalAlignment)verticalAlignment {
    return [self verticalAlignment:verticalAlignment superview:self.superview];
}

- (UIViewController *)findParentViewController {
    UIView *view = self;
    while ([view.nextResponder isKindOfClass:[UIView class]])
        view = (UIView *)view.nextResponder;
    UIViewController *viewController = [view.nextResponder isKindOfClass:[UIViewController class]] ? (UIViewController *)view.nextResponder : nil;
    return viewController;
}


- (UIView *)sizeToSubviews {
    CGSize newSize = CGSizeMake(0, 0);
    for (UIView *view in self.subviews) {
        newSize.width = MAX(newSize.width, BBX(view) + BBW(view));
        newSize.height = MAX(newSize.height, BBY(view) + BBH(view));
    }
    BBResizeFrame(self, newSize.width, newSize.height);
    return self;
}

- (void)addSpacer:(CGSize)size {
    [self addSpacer:size withColor:nil];
}

- (void)addSpacer:(CGSize)size withColor:(UIColor *)color{
    UIView *spacer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    spacer.backgroundColor = color;
    [self addSubview:spacer];
}

- (UIImage *)getScreenshotDuringAnimation:(BOOL)duringAnimation {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CALayer *layer = duringAnimation ? self.layer.presentationLayer : self.layer;
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (UIImage *)getScreenshot{
    return [self getScreenshotDuringAnimation:NO];
}

- (UIImage *)getRegionScreenshot:(CGRect)region {
    return [[self getScreenshotDuringAnimation:NO] crop:region];
}

- (id)addView:(UIView *)subview {
    [self addSubview:subview];
    return subview;
}

- (id)addView:(UIView *)subview atPoint:(CGPoint)point {
    BBMoveFrame(subview, point.x, point.y);
    return [self addView:subview];
}

- (void)makeTopRoundedCornerMask:(float)cornerRadius {
    [self makeRoundedCornerMask:cornerRadius corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}

- (void)makeBottomRoundedCornerMask:(float)cornerRadius {
    [self makeRoundedCornerMask:cornerRadius corners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)];
}

- (void)makeRoundedCornerMask:(float)cornerRadius corners:(UIRectCorner)corners {
    CGRect bounds = self.layer.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;

    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
}

- (void)debugSizes {
    if (self.frame.size.height <= 0 || self.frame.size.width <= 0)
        NSLog(@"ACK! The frame width or height is 0. Width: %f Height: %f", self.frame.size.width, self.frame.size.height);
    if (self.userInteractionEnabled == NO)
        NSLog(@"ACK! The view doesn't have userInteractionEnabled!");
    self.backgroundColor = [UIColor colorWithRed:BBRnd green:BBRnd blue:BBRnd alpha:0.2];
    for (UIView *subview in self.subviews)
        [subview debugSizes];
}


@end