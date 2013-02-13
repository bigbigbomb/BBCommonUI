//
//  Created by Lee Fastenau on 7/12/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBWrapView.h"

@implementation BBWrapView

@synthesize itemPadding = _itemPadding;
@synthesize lineHeight = _lineHeight;
@synthesize currentPosition = _currentPosition;
@synthesize edgeInsets = _edgeInsets;

- (id)initWithLineHeight:(float)lineHeight itemPadding:(float)itemPadding edgeInsets:(UIEdgeInsets)edgeInsets {
    self = [super init];
    if (self) {
        _lineHeight = lineHeight;
        _itemPadding = itemPadding;
        _edgeInsets = edgeInsets;
        _currentPosition = CGPointMake(edgeInsets.left, edgeInsets.top);
    }

    return self;
}

//- (void)addSubview:(UIView *)view {
//    CGPoint nextPosition = CGPointMake(self.currentPosition.x + view.frame.size.width, self.currentPosition.y);
//    if (nextPosition.x > self.frame.size.width - self.edgeInsets.right)
//    {
//        self.currentPosition = CGPointMake(self.edgeInsets.left, self.currentPosition.y + self.lineHeight);
//    }
//    view.frame = CGRectMake(self.currentPosition.x, self.currentPosition.y, view.frame.size.width, view.frame.size.height);
//    self.currentPosition = CGPointMake(self.currentPosition.x + view.frame.size.width + self.itemPadding, self.currentPosition.y);
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.currentPosition.y + self.lineHeight + self.edgeInsets.bottom);
//    [super addSubview:view];
//}
//
//- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
//    CGPoint nextPosition = CGPointMake(self.currentPosition.x + view.frame.size.width, self.currentPosition.y);
//        if (nextPosition.x > self.frame.size.width - self.edgeInsets.right)
//        {
//            self.currentPosition = CGPointMake(self.edgeInsets.left, self.currentPosition.y + self.lineHeight);
//        }
//        view.frame = CGRectMake(self.currentPosition.x, self.currentPosition.y, view.frame.size.width, view.frame.size.height);
//        self.currentPosition = CGPointMake(self.currentPosition.x + view.frame.size.width + self.itemPadding, self.currentPosition.y);
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.currentPosition.y + self.lineHeight + self.edgeInsets.bottom);
//    [super insertSubview:view atIndex:index];
//}

- (void)layoutSubviewsCore {
    for (UIView *view in [self subviews]) {
        if (self.currentPosition.x + view.frame.size.width > self.frame.size.width + self.edgeInsets.right)
            self.currentPosition = CGPointMake(self.edgeInsets.left, self.currentPosition.y + self.lineHeight);
        view.frame = CGRectMake(self.currentPosition.x, self.currentPosition.y, view.frame.size.width, view.frame.size.height);
        self.currentPosition = CGPointMake(self.currentPosition.x + view.frame.size.width + self.itemPadding, self.currentPosition.y);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.currentPosition.y + self.lineHeight + self.edgeInsets.bottom);
    }
}

- (void)didAddSubview:(UIView *)subview {
    [self layoutSubviewsCore];
}

- (void)willRemoveSubview:(UIView *)subview {
    [self layoutSubviewsCore];
}

@end