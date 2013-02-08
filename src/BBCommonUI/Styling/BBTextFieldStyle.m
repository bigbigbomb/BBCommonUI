//
//  Created by Lee Fastenau on 1/9/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBTextFieldStyle.h"
#import "BBTextField.h"


@implementation BBTextFieldStyle {
    BOOL _setEditingInsets;
}

@synthesize textStyle = _textStyle;
@synthesize placeholderStyle = _placeholderStyle;
@synthesize background = _background;
@synthesize contentHorizontalAlignment = _contentHorizontalAlignment;
@synthesize contentVerticalAlignment = _contentVerticalAlignment;
@synthesize textInsets = _textInsets;
@synthesize placeholder = _placeholder;
@synthesize editingTextInsets = _editingTextInsets;
@synthesize styleAsValid = _styleAsValid;
@synthesize styleAsInvalid = _styleAsInvalid;


- (id)init {
    self = [super init];
    if (self) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    }

    return self;
}

- (void)setEditingTextInsets:(UIEdgeInsets)anEditingTextInsets {
    _editingTextInsets = anEditingTextInsets;
    _setEditingInsets = YES;
}

- (BBTextField *)bbTextFieldWithFrame:(CGRect)frame {
    BBTextField *field = [[BBTextField alloc] initWithFrame:frame andInsets:self.textInsets];
    if (_setEditingInsets)
        field.editingTextInsets = self.editingTextInsets;
    [self.textStyle applyStyleToTextField:field];
    field.contentVerticalAlignment = self.contentVerticalAlignment;
    field.contentHorizontalAlignment = self.contentHorizontalAlignment;
    field.placeholderStyle = self.placeholderStyle;
    field.background = self.background;
    field.placeholder = self.placeholder;
    field.styleAsValid = self.styleAsValid;
    field.styleAsInvalid = self.styleAsInvalid;
    return field;
}

@end