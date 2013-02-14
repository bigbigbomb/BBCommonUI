//
//  Created by Lee Fastenau on 7/12/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBWrapView.h"

@interface BBWrapView ()
@property(nonatomic, strong) UIView *viewToRemove;
@property(nonatomic) CGPoint currentPosition;

@property(nonatomic, readwrite) float availableRightSpace;
@end

@implementation BBWrapView

- (id)initWithLineHeight:(float)lineHeight itemPadding:(float)itemPadding edgeInsets:(UIEdgeInsets)edgeInsets {
    self = [super initWithFrame:CGRectMake(0, 0, 0, lineHeight)];
    if (self) {
        _lineHeight = lineHeight;
        _itemPadding = itemPadding;
        _edgeInsets = edgeInsets;
        _currentPosition = CGPointMake(edgeInsets.left, edgeInsets.top);
    }

    return self;
}

- (void)setAvailableRightSpace:(float)availableRightSpace {
    _availableRightSpace = availableRightSpace;
    [self.delegate wrapViewLayoutDidChange:self];
}


- (void)willRemoveSubview:(UIView *)subview {
    self.viewToRemove = subview;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.currentPosition = CGPointMake(self.edgeInsets.left, self.edgeInsets.top);
    for (UIView *view in [self subviews]) {
        if (self.viewToRemove == view)
            continue;
        if (self.currentPosition.x + view.frame.size.width > self.frame.size.width + self.edgeInsets.right)
            self.currentPosition = CGPointMake(self.edgeInsets.left, self.currentPosition.y + self.lineHeight);
        view.frame = CGRectMake(self.currentPosition.x, self.currentPosition.y, view.frame.size.width, view.frame.size.height);
        self.currentPosition = CGPointMake(self.currentPosition.x + view.frame.size.width + self.itemPadding, self.currentPosition.y);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.currentPosition.y + self.lineHeight + self.edgeInsets.bottom);
        self.availableRightSpace = self.frame.size.width - self.currentPosition.x - self.edgeInsets.right;
    }
    self.viewToRemove = nil;
}


@end