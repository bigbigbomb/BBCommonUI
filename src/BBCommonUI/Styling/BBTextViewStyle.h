//
//  Created by Brian Romanko on 6/1/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BBTextField;
@class BBLabelStyle;
@class BBTextView;

@interface BBTextViewStyle : NSObject {

@private
    BBLabelStyle *_textStyle;
    UIImage *_background;
    UIEdgeInsets _textInsets;
}

@property(nonatomic, strong) BBLabelStyle *textStyle;
@property(nonatomic, strong) BBLabelStyle *placeholderStyle;
@property(nonatomic, strong) UIImage *background;
@property(nonatomic) UIEdgeInsets textInsets;

@property(copy) void (^textViewCustomizer)(BBTextView *, BBTextViewStyle *);

- (BBTextView *)bbTextViewWithFrame:(CGRect)frame;

@end