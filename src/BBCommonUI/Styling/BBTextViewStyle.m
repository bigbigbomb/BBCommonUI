//
//  Created by Brian Romanko on 6/1/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBTextViewStyle.h"
#import "BBTextView.h"


@implementation BBTextViewStyle

@synthesize textStyle = _textStyle;
@synthesize background = _background;
@synthesize textInsets = _textInsets;
@synthesize textViewCustomizer = _textViewCustomizer;
@synthesize placeholderStyle = _placeholderStyle;


- (BBTextView *)bbTextViewWithFrame:(CGRect)frame {
    BBTextView *view = [[BBTextView alloc] initWithFrame:frame andInsets:self.textInsets];
    [self.textStyle applyStyleToTextView:view];
    view.backgroundColor = [UIColor colorWithPatternImage:self.background];
    view.placeholderStyle = self.placeholderStyle;

    if (self.textViewCustomizer) self.textViewCustomizer(view, self);

    return view;
}

@end