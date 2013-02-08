//
//  Created by Lee Fastenau on 7/11/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackView.h"

@interface BBStackView (Private)

// \cond
- (void)setLength:(float)newLength;
- (void)registerSubview:(UIView *)view;
- (void)updateLayout;
- (void)viewFrameChanged:(NSDictionary *)change;
// \endcond

@end

@implementation BBStackView

@synthesize isRemovingSubview = _isRemovingSubview;
@synthesize delegate = _delegate;
@synthesize orientation = _orientation;

- (void)setOrientation:(BBStackViewOrientation)orientation {
    _orientation = orientation;
    [self updateLayout];
}

- (void)setLength:(float)newLength {
    if (self.orientation == BBStackViewOrientationVertical) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newLength);
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newLength, self.frame.size.height);
    }
    [self.delegate stackViewLayoutDidChange:self];
}

- (void)registerSubview:(UIView *)view {
    [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:@selector(viewFrameChanged:)];
    [self updateLayout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:(SEL)context withObject:change];
    #pragma clang diagnostic pop
}

- (id)init {
    self = [self initWithFrame:CGRectZero orientation:BBStackViewOrientationVertical];

    return self;
}

- (id)initWithFrame:(CGRect)frame orientation:(BBStackViewOrientation)orientation {
    self = [self initWithFrame:frame];
    if (self)
    {
        _orientation = orientation;
    }

    return self;
}

- (void)updateLayout {
    if (_isUpdating) return;

    _isUpdating = YES;
    float newLength = 0;
    for (UIView *view in self.subviews) {
        if (self.orientation == BBStackViewOrientationVertical) {
            view.frame = CGRectMake(view.frame.origin.x, newLength, view.frame.size.width, view.frame.size.height);
            newLength += view.frame.size.height;
        } else {
            view.frame = CGRectMake(newLength, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            newLength += view.frame.size.width;
        }
    }
    [self setLength:newLength];
    _isUpdating = NO;
}

- (void)viewFrameChanged:(NSDictionary *)change {
    [self updateLayout];
}

- (void)dealloc {
    for (UIView *view in self.subviews)
    {
        [view removeObserver:self forKeyPath:@"frame"];
    }

    self.isRemovingSubview = YES;
}

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    [self registerSubview:subview];
}

- (void)willRemoveSubview:(UIView *)subview {
    DAssert(self.isRemovingSubview, @"Remove subviews from a stack view using the stack view's removeSubview: method or the layout will not be updated.");
    [super willRemoveSubview:subview];
}


- (void)addSpacer:(float)length {
    float width = 1, height = 1;
    if (self.orientation == BBStackViewOrientationHorizontal) {
        width = length;
    } else {
        height = length;
    }
    [self addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)]];
}

- (void)removeSubview:(UIView *)subview {
    self.isRemovingSubview = YES;
    [subview removeObserver:self forKeyPath:@"frame"];
    [subview removeFromSuperview];
    self.isRemovingSubview = NO;
    [self updateLayout];
}

@end
