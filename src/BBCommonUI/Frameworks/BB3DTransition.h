//
//  BB3DTransition
//  BBCommonUI
//
//  Created by leebrenner on 2/19/13.
//  Copyright 2013 BigBig Bomb, LLC. All rights reserved



#import <Foundation/Foundation.h>

typedef enum {
    BB3DFlipInFromTop,
    BB3DFlipInFromBottom,
    BB3DFlipInFromLeft,
    BB3DFlipInFromRight,
    BB3DFlipOutFromTop,
    BB3DFlipOutFromBottom,
    BB3DFlipOutFromLeft,
    BB3DFlipOutFromRight
} BB3DFlipDirection;

typedef enum {
    BB3DSpinFromTop,
    BB3DSpinFromBottom,
    BB3DSpinFromRight,
    BB3DSpinFromLeft
} BB3DSpinDirection;


typedef enum {
    BB3DClockFlipFromTop,
    BB3DClockFlipFromBottom
} BB3DClockFlipDirection;

@interface BB3DTransition : NSObject

+ (void)flip:(UIView *)view withFlipDirection:(BB3DFlipDirection)flipDirection completion:(void(^)(BOOL finished))completion;
+ (void)spin:(UIView *)fromView toView:(UIView *)toView spinDirection:(BB3DSpinDirection)spinDirection fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion;
+ (void)clockFlip:(UIView *)fromView toView:(UIView *)toView withClockFlipDirection:(BB3DClockFlipDirection)clockFlipDirection completion:(void(^)(BOOL finished))completion;
+ (void)clockFlip:(UIView *)fromView toView:(UIView *)toView withClockFlipDirection:(BB3DClockFlipDirection)clockFlipDirection completion:(void(^)(BOOL finished))completion shadowImage:(UIImage *)shadowImage bottomShadowImage:(UIImage *)bottomShadowImage shineImage:(UIImage *)shineImage;

+ (void)setPerspectiveAmount:(float)amount;
+ (float)getPerspectiveAmount;
+ (void)setFlipDuration:(float)duration;
+ (float)getFlipDuration;
+ (void)setSpinDuration:(float)duration;
+ (float)getSpinDuration;
+ (void)setClockFlipDuration:(float)duration;
+ (float)getClockFlipDuration;

@end


@interface BB3DTransitionResponder : NSObject

@property (nonatomic, copy) void (^completionBlock)(BOOL);

- (id)initWithCompletion:(void (^)(BOOL))completionBlock;

@end