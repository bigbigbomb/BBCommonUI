//
//  Created by Lee Fastenau on 8/3/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//

#import "BBCommonUI.h"

@implementation UILabel(BBCommon)

+ (void)labelWithTextCommon:(UILabel *)label text:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment {
    label.text = text;
    label.font = font;
    label.lineBreakMode = lineBreakMode;
    label.textAlignment = alignment;

    // resize
    if (frame.size.width == 0 || frame.size.height == 0) {
        if (frame.size.width == 0) {
            label.numberOfLines = 1;
        } else {
            // todo: Assumes wrapping on width provided - don't do this
            label.numberOfLines = 0;
        }
        [label sizeToFit];
        BBResizeFrame(label, frame.size.width == 0 ? BBW(label) : frame.size.width, frame.size.height == 0 ? BBH(label) : frame.size.height);
    }

    // adjust alignment
    if (BBW(label) != frame.size.width && alignment != NSTextAlignmentLeft) {
        float xDelta = (frame.size.width - BBW(label)) / (alignment == NSTextAlignmentCenter ? 2.0f : 1.0f);
        BBMoveFrame(label, BBX(label) + xDelta, BBY(label));
    }

#ifndef BB_DEBUG_LABELS
    label.backgroundColor = [UIColor clearColor];
#else
    label.backgroundColor = [UIColor colorWithRed:BBRnd green:BBRnd blue:BBRnd alpha:0.2];
#endif
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [self labelWithTextCommon:label text:text font:font frame:frame lineBreakMode:lineBreakMode alignment:alignment];
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode {
    return [self labelWithText:text font:font frame:frame lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font {
    return [self labelWithText:text font:font frame:BBEmptyRect(0, 0) lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
}

- (CGFloat)getFrameHeightWithMaxWidth:(CGFloat)maxWidth {
    return [UILabel getFrameHeightFromStringWithMaxHeight:self.text withFont:self.font withMaxWidth:maxWidth withMaxHeight:NSIntegerMax];
}

- (CGFloat)getFrameHeightWithMaxSize:(CGSize)maxSize {
    return [UILabel getFrameHeightFromStringWithMaxHeight:self.text withFont:self.font withMaxWidth:maxSize.width withMaxHeight:maxSize.height];
}

+ (CGFloat)getFrameHeightFromStringWithMaxHeight:(NSString *)string
						  withFont:(UIFont *)font
					  withMaxWidth:(CGFloat)maxWidth
					 withMaxHeight:(CGFloat)maxHeight {
	CGSize stringSize = [string sizeWithFont:font
						   constrainedToSize:CGSizeMake(maxWidth, maxHeight)
							   lineBreakMode:NSLineBreakByWordWrapping];

	return stringSize.height;
}

- (void)frameWithOptimalFontForWidth:(float)width
                          withOrigin:(CGPoint)origin
                     withMaxFontSize:(float)maxFontSize
                     withMinFontSize:(float)minFontSize
                        withMaxLines:(int)maxLines {

    //First, set the initial frame to prep for optimizational synchronizingliness
    self.frame = CGRectMake(origin.x, origin.y, width, [@"A" sizeWithFont:self.font].height);
    CGSize stringSize = [self.text sizeWithFont:self.font];
    UIFont *font = self.font;
    int currentLineCount = 1;

    //Algorithm:
    //  1.)Measure string
    //  2.)If it fits, done.
    //  3.)Keep shrinking down to min font size through maxLines trying to find best size
    while(currentLineCount <= maxLines){
        font = [font fontWithSize:self.font.pointSize];
        stringSize = [self.text sizeWithFont:font];
        while (stringSize.width / currentLineCount > self.frame.size.width - 20 && font.pointSize >= minFontSize) {
            font = [font fontWithSize:font.pointSize - 1];
            stringSize = [self.text sizeWithFont:font];
            if (stringSize.width / currentLineCount <= self.frame.size.width - 20) {
                break;
            }
        }

        if (font.pointSize < minFontSize) {
            currentLineCount++;
        }
        else {
            break;
        }
    }

    //Finally, set the fully synchronized frame based on optimized font size
    currentLineCount = MIN(maxLines, currentLineCount);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, stringSize.height * currentLineCount);
    self.numberOfLines = currentLineCount;
    self.font = font;
}

- (void)frameWithOptimalFontForSize:(CGSize)size
                         withOrigin:(CGPoint)origin
                    withMaxFontSize:(float)maxFontSize
                    withMinFontSize:(float)minFontSize
                       withMaxLines:(int)maxLines {

    //Similar to the width optimization method, except that it also respects height
    //First, set the initial frame to prep for optimizational synchronizingliness
    self.frame = CGRectMake(origin.x, origin.y, size.width, [@"A" sizeWithFont:self.font].height);
    CGSize stringSize = [self.text sizeWithFont:self.font];
    UIFont *font = self.font;
    int currentLineCount = 1;

    //Algorithm:
    //  1.)Measure string
    //  2.)If it fits, done.
    //  3.)Keep shrinking down to min font size through maxLines trying to find best size that also is within the specified height
    while(currentLineCount <= maxLines){
        font = [font fontWithSize:self.font.pointSize];
        stringSize = [self.text sizeWithFont:font];
        while ((stringSize.width / currentLineCount > self.frame.size.width - 20 || stringSize.height * currentLineCount > size.height) && font.pointSize >= minFontSize) {
            font = [font fontWithSize:font.pointSize - 1];
            stringSize = [self.text sizeWithFont:font];
            if (stringSize.width / currentLineCount <= self.frame.size.width - 20 && stringSize.height * currentLineCount <= size.height) {
                break;
            }
        }

        if (font.pointSize < minFontSize) {
            currentLineCount++;
        }
        else {
            break;
        }
    }

    //Finally, set the fully synchronized frame based on optimized font size
    currentLineCount = MIN(maxLines, currentLineCount);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, stringSize.height * currentLineCount);
    self.numberOfLines = currentLineCount;
    self.font = font;
}

- (void)resizeFrameToSizeThatFitsText {
    CGSize size = [self.text sizeWithFont:self.font];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

@end


@implementation BBLabel(BBCommon)

+ (BBLabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment {
    BBLabel *label = [[BBLabel alloc] initWithFrame:frame];
    [self labelWithTextCommon:label text:text font:font frame:frame lineBreakMode:lineBreakMode alignment:alignment];
    return label;
}

+ (BBLabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode {
    return [self labelWithText:text font:font frame:frame lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft];
}

+ (BBLabel *)labelWithText:(NSString *)text font:(UIFont *)font {
    return [self labelWithText:text font:font frame:BBEmptyRect(0, 0) lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
}

@end