//
//  Created by Lee Fastenau on 8/11/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBLabelStyle.h"

@class BBButtonStyle;

typedef void (^BBButtonCustomizer)(UIButton *button, BBButtonStyle *currentStyle);

@interface BBButtonStyle : NSObject {

@private
    BBButtonCustomizer _buttonCustomizer;
    NSMutableDictionary *_labelStyleForState;
    NSMutableDictionary *_backgroundImageForState;
    NSMutableDictionary *_imageForState;
}

@property(copy) BBButtonCustomizer buttonCustomizer;

- (BBLabelStyle *)labelStyleForState:(NSUInteger)state;
- (void)setLabelStyle:(BBLabelStyle *)image forState:(NSUInteger)state;
- (UIImage *)backgroundImageForState:(NSUInteger)state;
- (void)setBackgroundImage:(UIImage *)image forState:(NSUInteger)state;
- (UIImage *)imageForState:(NSUInteger)state;
- (void)setImage:(UIImage *)image forState:(NSUInteger)state;

- (void)updateAppearance:(UIButton *)button;

- (UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame;
- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action;
@end