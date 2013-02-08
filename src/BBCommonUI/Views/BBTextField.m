//
//  Created by Lee Fastenau on 1/9/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBTextField.h"
#import "NSString+BBCommon.h"

@implementation BBTextField
@synthesize placeholderStyle = _placeholderStyle;
@synthesize textInsets = _textInsets;
@synthesize editingTextInsets = _editingTextInsets;
@synthesize validationDelegate = _validationDelegate;
@synthesize styleAsInvalid = _styleAsInvalid;
@synthesize styleAsValid = _styleAsValid;

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame andInsets:UIEdgeInsetsZero];
    return  self;
}

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if (self) {
        self.textInsets = insets;
        self.editingTextInsets = insets;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing) name:UITextFieldTextDidEndEditingNotification object:self];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    _validationDelegate = nil;

}

- (void)applyValidStyle {
    if (self.styleAsValid != nil)
        self.styleAsValid(self);
}

- (void)applyInvalidStyle {
    if (self.styleAsInvalid != nil)
        self.styleAsInvalid(self);
}

- (CGRect)newBounds:(CGRect)bounds insets:(UIEdgeInsets)insets {
    return CGRectMake(bounds.origin.x + insets.left,
            bounds.origin.y + insets.top,
            bounds.size.width - insets.left - insets.right,
            bounds.size.height - insets.top - insets.bottom);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self newBounds:bounds insets:self.textInsets];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (![NSString isEmpty:self.text])
        return [self newBounds:bounds insets:self.editingTextInsets];
    else
        return [self newBounds:bounds insets:self.textInsets];
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [self.placeholderStyle.color setFill];
    [self.placeholder drawInRect:rect withFont:self.placeholderStyle.font lineBreakMode:NSLineBreakByWordWrapping alignment:self.textAlignment];
}

- (BOOL)validate {
    if (![self.validationDelegate respondsToSelector:@selector(bbTextField:validateText:)]) return YES;

    if ([self.validationDelegate bbTextField:self validateText:self.text]) {
        [self applyValidStyle];
        return YES;
    } else {
        [self applyInvalidStyle];
        return NO;
    }
}

- (void)didEndEditing {
    [self validate];
}

@end