//
//  Created by Lee Fastenau on 8/3/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BBLabel.h"

//#define BB_DEBUG_LABELS

/**
 * Category helper methods for UILabel. Most of these methods support fluent programming or method chaining.
 */
@interface UILabel(BBCommon)

/*
 * Creates a label using the supplied text, frame, line break mode, and alignment. Setting the frame width and/or height to 0 will cause the label to autosize to the text's width and/or height, respectively.
 * This is pretty awesome, really. Because the autosizing will honor the supplied alignment and reposition your shit... err... stuff so that your text is registered properly.
 */
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font;

- (CGFloat)getFrameHeightWithMaxWidth:(CGFloat)maxWidth;
- (CGFloat)getFrameHeightWithMaxSize:(CGSize)maxSize;
+ (CGFloat)getFrameHeightFromStringWithMaxHeight:(NSString *)string withFont:(UIFont *)font withMaxWidth:(CGFloat)maxWidth withMaxHeight:(CGFloat)maxHeight;

- (void)frameWithOptimalFontForWidth:(float)width
                          withOrigin:(CGPoint)origin
                     withMaxFontSize:(float)maxFontSize
                     withMinFontSize:(float)minFontSize
                        withMaxLines:(int)maxLines;

- (void)frameWithOptimalFontForSize:(CGSize)size
                         withOrigin:(CGPoint)origin
                    withMaxFontSize:(float)maxFontSize
                    withMinFontSize:(float)minFontSize
                       withMaxLines:(int)maxLines;

- (void)resizeFrameToSizeThatFitsText;

@end

/**
 * Category helper methods for UILabel. Most of these methods support fluent programming or method chaining.
 */
@interface BBLabel(BBCommon)

/*
 * Creates a label using the supplied text, frame, line break mode, and alignment. Setting the frame width and/or height to 0 will cause the label to autosize to the text's width and/or height, respectively.
 * This is pretty awesome, really. Because the autosizing will honor the supplied alignment and reposition your shit... err... stuff so that your text is registered properly.
 */
+ (BBLabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment;
+ (BBLabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode;
+ (BBLabel *)labelWithText:(NSString *)text font:(UIFont *)font;

@end