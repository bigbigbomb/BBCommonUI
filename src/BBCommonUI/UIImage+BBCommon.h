// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.
//
//  Modified by leebrenner on 3/8/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved
//



#import <Foundation/Foundation.h>

@interface UIImage (BBCommon)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

- (UIImage *)rotateImage;
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)resizePreservingAspect:(CGFloat)size;
@end