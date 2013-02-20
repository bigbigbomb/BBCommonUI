//
//  BB3DTransition
//  BBCommonUI
//
//  Created by leebrenner on 2/19/13.
//  Copyright 2013 BigBig Bomb, LLC. All rights reserved



#import <objc/runtime.h>
#import "BB3DTransition.h"
#import "UIView+BBCommon.h"

static float BB3DTopLeftRadianValues[] = {(float) RADIANS(0), (float) RADIANS(20), (float) RADIANS(-90), (float) RADIANS(90), (float) RADIANS(-15), (float) RADIANS(0)};
static float BB3DBottomRightRadianValues[] ={(float) RADIANS(0), (float) RADIANS(-20), (float) RADIANS(90), (float) RADIANS(-90), (float) RADIANS(15), (float) RADIANS(0)};
static char kBB3DIsFlipping;
static char kBB3DOriginalAnchorPointXKey;
static char kBB3DOriginalAnchorPointYKey;
static char kBB3DOriginalPositionXKey;
static char kBB3DOriginalPositionYKey;

static float _perspectiveAmount;
static float _flipDuration;
static float _spinDuration;
static float _clockFlipDuration;

@implementation BB3DTransition

+ (void) initialize {
    if ([self class] == [NSObject class]) {
    }
    _perspectiveAmount = 1.0 / -500;
    _flipDuration = 0.2;
    _spinDuration = 0.75;
    _clockFlipDuration = 0.3;
}

+ (void)clockFlip:(UIView *)fromView toView:(UIView *)toView withClockFlipDirection:(BB3DClockFlipDirection)clockFlipDirection completion:(void(^)(BOOL finished))completion shadowImage:(UIImage *)shadowImage shineImage:(UIImage *)shineImage {
    /*
        1.)Create a container in superview of fromView to hold the effect.
        2.)Create top and bottom UIImageViews from the fromView, add them to the container, hide the fromView
        3.)If flipping from top create a bottom UIImageView from the toView, add it to the container
            - OR -
           If flipping from bottom create a top UIImageView from the toView, ad it to the container
        4.)If flipping from top animate the top image of the fromView 90 degrees, then animate the bottom of the toView 90 degrees
            - OR -
           If flipping from bottom animate the bottom image of the fromView 90 degrees then the top of the toView 90 degrees
        5.)Remove the container and unhide the fromView
     */
    float perspective = _perspectiveAmount * 2.0;
    UIView *parent = [fromView superview];
    UIView *container = [[UIView alloc] initWithFrame:fromView.frame];
    [parent addSubview:container];

    UIImageView *fromViewTopHalf = [[UIImageView alloc] initWithImage:[fromView getRegionScreenshot:CGRectMake(0, 0, fromView.frame.size.width, floorf(fromView.frame.size.height * 0.5))]];
    fromViewTopHalf.frame = CGRectMake(0, 0, fromView.frame.size.width, floorf(fromView.frame.size.height * 0.5));
    fromViewTopHalf.layer.anchorPoint = CGPointMake(.5, 1);
    fromViewTopHalf.layer.position = CGPointMake(fromViewTopHalf.layer.position.x, floorf(fromViewTopHalf.layer.position.y + fromViewTopHalf.frame.size.height * 0.5));
    UIImageView *fromViewBottomHalf = [[UIImageView alloc] initWithImage:[fromView getRegionScreenshot:CGRectMake(0, floorf(fromView.frame.size.height * 0.5), fromView.frame.size.width, floorf(fromView.frame.size.height * 0.5))]];
    fromViewBottomHalf.frame = CGRectMake(0, floorf(fromView.frame.size.height * 0.5), fromView.frame.size.width, floorf(fromView.frame.size.height * 0.5));
    fromViewBottomHalf.layer.position = CGPointMake(fromViewBottomHalf.layer.position.x, floorf(fromViewBottomHalf.layer.position.y - fromViewBottomHalf.frame.size.height * 0.5));
    fromViewBottomHalf.layer.anchorPoint = CGPointMake(.5, 0);
    [container addSubview:fromViewTopHalf];
    [container addSubview:fromViewBottomHalf];
    fromView.hidden = YES;

    CATransform3D fromT = CATransform3DIdentity;
    fromT.m34 = perspective;
    fromT = CATransform3DRotate(fromT, (float) RADIANS(0), 1.0f, 0.0f, 0.0f);

    UIImageView *toViewSection = [[UIImageView alloc] initWithImage:[toView getRegionScreenshot:CGRectMake(0, clockFlipDirection == BB3DClockFlipFromTop ? floorf((toView.frame.size.height * 0.5)) : 0, toView.frame.size.width, floorf(toView.frame.size.height * 0.5))]];
    toViewSection.frame = CGRectMake(0, clockFlipDirection == BB3DClockFlipFromTop ? floorf(toView.frame.size.height * 0.5) : 0, toView.frame.size.width, floorf(toView.frame.size.height * 0.5));
    toViewSection.layer.anchorPoint = CGPointMake(.5, clockFlipDirection == BB3DClockFlipFromTop ? 0 : 1);
    toViewSection.layer.position = CGPointMake(toViewSection.layer.position.x, toViewSection.layer.position.y + clockFlipDirection == BB3DClockFlipFromTop ? -floorf(toView.frame.size.height * 0.5) : floorf(toView.frame.size.height * 0.5));
    [container addSubview:toViewSection];

    CATransform3D toT = CATransform3DIdentity;
    toT.m34 = perspective;
    toT = CATransform3DRotate(toT, clockFlipDirection == BB3DClockFlipFromTop ? (float) RADIANS(90) : (float) RADIANS(-90), 1.0f, 0.0f, 0.0f);
    toViewSection.layer.transform = toT;

    UIImageView *shine;
    UIImageView *shadow;
    UIImageView *bottomShadow;

    if (shineImage){
        shine = [[UIImageView alloc] initWithImage:shineImage];
        shine.backgroundColor = [UIColor clearColor];
        shadow = [[UIImageView alloc] initWithImage:shadowImage];
        shadow.backgroundColor = [UIColor clearColor];
        bottomShadow = [[UIImageView alloc] initWithImage:shadowImage];
        bottomShadow.backgroundColor = [UIColor clearColor];
    }
    else {
        shine = [[UIImageView alloc] init];
        shine.backgroundColor = [UIColor whiteColor];
        shadow = [[UIImageView alloc] init];
        shadow.backgroundColor = [UIColor blackColor];
        bottomShadow = [[UIImageView alloc] init];
        bottomShadow.backgroundColor = [UIColor blackColor];
    }

    if (clockFlipDirection == BB3DClockFlipFromTop) {
        [fromViewBottomHalf insertSubview:bottomShadow atIndex:0];
        bottomShadow.alpha = 0;
        fromViewTopHalf.layer.transform = fromT;
        [fromViewTopHalf insertSubview:shadow atIndex:0];
        shadow.frame = CGRectMake(0, 0, BBW(fromViewTopHalf), BBH(fromViewTopHalf));
        shadow.alpha = 0;
        [toViewSection insertSubview:shine atIndex:0];
        shine.frame = CGRectMake(0, 0, toViewSection.bounds.size.width, toViewSection.bounds.size.height);
        shine.alpha = .8;
        [UIView animateWithDuration:_clockFlipDuration * 0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CATransform3D endT = CATransform3DIdentity;
                             endT.m34 = perspective;
                             endT = CATransform3DRotate(endT, (float) RADIANS(-90), 1.0f, 0.0f, 0.0f);
                             fromViewTopHalf.layer.transform = endT;
                             shadow.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:_clockFlipDuration * 0.5
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  CATransform3D endT = CATransform3DIdentity;
                                                  endT.m34 = perspective;
                                                  endT = CATransform3DRotate(endT, (float) RADIANS(0), 1.0f, 0.0f, 0.0f);
                                                  toViewSection.layer.transform = endT;
                                                  shine.alpha = 0;
                                                  bottomShadow.alpha = 0.8;
                                              }
                                              completion:^(BOOL finished2){
                                                  [container removeFromSuperview];
                                                  if (completion)
                                                      completion(finished2);
                                              }];
                         }];
    }
    else {
        [fromViewTopHalf insertSubview:bottomShadow atIndex:0];
        bottomShadow.alpha = 0.8;
        fromViewBottomHalf.layer.transform = fromT;
        [fromViewBottomHalf insertSubview:shine atIndex:0];
        shine.frame = CGRectMake(0, 0, BBW(fromViewBottomHalf), BBH(fromViewBottomHalf));
        shine.alpha = 0;
        [toViewSection insertSubview:shadow atIndex:0];
        shadow.frame = CGRectMake(0, 0, toViewSection.bounds.size.width, toViewSection.bounds.size.height);
        shadow.alpha = 1;
        [UIView animateWithDuration:_clockFlipDuration * 0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CATransform3D endT = CATransform3DIdentity;
                             endT.m34 = _perspectiveAmount;
                             endT = CATransform3DRotate(endT, (float) RADIANS(90), 1.0f, 0.0f, 0.0f);
                             fromViewBottomHalf.layer.transform = endT;
                             shine.alpha = .8;
                             bottomShadow.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:_clockFlipDuration * 0.5
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  CATransform3D endT = CATransform3DIdentity;
                                                  endT.m34 = _perspectiveAmount;
                                                  endT = CATransform3DRotate(endT, (float) RADIANS(0), 1.0f, 0.0f, 0.0f);
                                                  toViewSection.layer.transform = endT;
                                                  shadow.alpha = 0;
                                              }
                                              completion:^(BOOL finished2){
                                                  [container removeFromSuperview];
                                                  if (completion)
                                                      completion(finished2);
                                              }];
                         }];
    }
}

+ (void)clockFlip:(UIView *)fromView toView:(UIView *)toView withClockFlipDirection:(BB3DClockFlipDirection)clockFlipDirection completion:(void(^)(BOOL finished))completion {
    [self clockFlip:fromView toView:toView withClockFlipDirection:clockFlipDirection completion:completion shadowImage:nil shineImage:nil];
}

+ (BOOL)isFlipping:(UIView *)view {
    return [((NSNumber *) objc_getAssociatedObject(view, &kBB3DIsFlipping)) boolValue];
}

+ (void)setFlipping:(UIView *)view value:(BOOL)val {
    objc_setAssociatedObject(view, &kBB3DIsFlipping, [NSNumber numberWithBool:val], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)flipAnimate:(UIView *)view withPoint:(CGPoint)anchorPoint withPosition:(CGPoint)position withStart:(float)start andEnd:(float)end onXAxis:(BOOL)onXAxis completion:(void (^)(BOOL finished))completion {
    if (![self isFlipping:view]){
        [self setFlipping:view value:YES];
        objc_setAssociatedObject(view, &kBB3DOriginalAnchorPointXKey, [NSNumber numberWithFloat:view.layer.anchorPoint.x], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, &kBB3DOriginalAnchorPointYKey, [NSNumber numberWithFloat:view.layer.anchorPoint.y], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, &kBB3DOriginalPositionXKey, [NSNumber numberWithFloat:view.layer.position.x], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, &kBB3DOriginalPositionYKey, [NSNumber numberWithFloat:view.layer.position.y], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        view.layer.anchorPoint = anchorPoint;
        view.layer.position = position;
    }

    CATransform3D startT = CATransform3DIdentity;
    startT.m34 = _perspectiveAmount;
    startT = CATransform3DRotate(startT, start, onXAxis ? 1.0f : 0.0f, onXAxis ? 0.0f : 1.0f, 0.0f);

    view.layer.transform = startT;
    view.hidden = NO;

    CATransform3D endT = CATransform3DIdentity;
    endT.m34 = _perspectiveAmount;
    endT = CATransform3DRotate(endT, end, onXAxis ? 1.0f : 0.0f, onXAxis ? 0.0f : 1.0f, 0.0f);

    [UIView animateWithDuration:_flipDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.layer.transform = endT;
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             if (end != RADIANS(0)) {
                                 view.hidden = YES;
                             }
                             view.layer.transform = CATransform3DIdentity;
                             view.layer.anchorPoint = CGPointMake([(NSNumber *)objc_getAssociatedObject(view, &kBB3DOriginalAnchorPointXKey) floatValue], [(NSNumber *)objc_getAssociatedObject(view, &kBB3DOriginalAnchorPointYKey) floatValue]);
                             view.layer.position = CGPointMake([(NSNumber *)objc_getAssociatedObject(view, &kBB3DOriginalPositionXKey) floatValue], [(NSNumber *)objc_getAssociatedObject(view, &kBB3DOriginalPositionYKey) floatValue]);
                             objc_removeAssociatedObjects(view);
                         }
                         if (completion){
                             completion(finished);
                         }
                     }];
}

+ (void)setPoints:(UIView *)view withFlipDirection:(BB3DFlipDirection)flipDirection andStart:(float)start andEnd:(float)end completion:(void(^)(BOOL finished))completion {
    switch (flipDirection) {
        case BB3DFlipInFromBottom:
        case BB3DFlipOutFromBottom:
            [BB3DTransition flipAnimate:view withPoint:CGPointMake(0.5, 1) withPosition:CGPointMake(view.layer.position.x, view.layer.position.y + view.frame.size.height * 0.5) withStart:start andEnd:end onXAxis:YES completion:completion];
            break;
        case BB3DFlipInFromTop:
        case BB3DFlipOutFromTop:
            [BB3DTransition flipAnimate:view withPoint:CGPointMake(0.5, 0) withPosition:CGPointMake(view.layer.position.x, view.layer.position.y - view.frame.size.height * 0.5) withStart:start andEnd:end onXAxis:YES completion:completion];
            break;
        case BB3DFlipInFromLeft:
        case BB3DFlipOutFromLeft:
            [BB3DTransition flipAnimate:view withPoint:CGPointMake(0, 0.5) withPosition:CGPointMake(view.layer.position.x - view.frame.size.width * 0.5, view.layer.position.y) withStart:start andEnd:end onXAxis:NO completion:completion];
            break;
        case BB3DFlipInFromRight:
        case BB3DFlipOutFromRight:
            [BB3DTransition flipAnimate:view withPoint:CGPointMake(1, 0.5) withPosition:CGPointMake(view.layer.position.x + view.frame.size.width * 0.5, view.layer.position.y) withStart:start andEnd:end onXAxis:NO completion:completion];
            break;
    }
}

+ (void)flip:(UIView *)view withFlipDirection:(BB3DFlipDirection)flipDirection completion:(void(^)(BOOL finished))completion {
    switch (flipDirection) {
        case BB3DFlipInFromLeft:
        case BB3DFlipInFromBottom:
            [BB3DTransition setPoints:view withFlipDirection:flipDirection andStart:(float) RADIANS(90) andEnd:(float) RADIANS(0) completion:completion];
            break;
        case BB3DFlipInFromRight:
        case BB3DFlipInFromTop:
            [BB3DTransition setPoints:view withFlipDirection:flipDirection andStart:(float) RADIANS(-90) andEnd:(float) RADIANS(0) completion:completion];
            break;
        case BB3DFlipOutFromLeft:
        case BB3DFlipOutFromBottom:
            [BB3DTransition setPoints:view withFlipDirection:flipDirection andStart:(float) RADIANS(0) andEnd:(float) RADIANS(90) completion:completion];
            break;
        case BB3DFlipOutFromRight:
        case BB3DFlipOutFromTop:
            [BB3DTransition setPoints:view withFlipDirection:flipDirection andStart:(float) RADIANS(0) andEnd:(float) RADIANS(-90) completion:completion];
            break;
    }
}

+ (void)spin:(UIView *)fromView toView:(UIView *)toView spinDirection:(BB3DSpinDirection)spinDirection fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    switch (spinDirection) {
        case BB3DSpinFromBottom:
            [BB3DTransition spinFromBottom:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            break;
        case BB3DSpinFromRight:
            [BB3DTransition spinFromLeft:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            break;
        case BB3DSpinFromLeft:
            [BB3DTransition spinFromRight:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            break;
        case BB3DSpinFromTop:
            [BB3DTransition spinFromTop:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            break;
    }
}

+ (void)fromViewAnimation:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion angleValues:(float *)angleValues effectX:(BOOL)effectX effectY:(BOOL)effectY{
    void(^block)(BOOL)  = ^(BOOL finished){
        fromView.userInteractionEnabled = YES;
            if (finished) {

                if (fromView != toView){
                    fromView.layer.transform = CATransform3DIdentity;
                    fromView.hidden = YES;
                    toView.hidden = NO;
                }

                [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:angleValues effectX:effectX effectY:effectY];
            }

            if (fromViewCompletion)
                fromViewCompletion(finished);

        };
    float duration = _spinDuration * 0.5;
    if (![UIView areAnimationsEnabled]){
        duration = 0;
    }
    BB3DTransitionResponder *frontResponder = [[BB3DTransitionResponder alloc] initWithCompletion:block];
    CAKeyframeAnimation *frontAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    frontAnimation.delegate             = frontResponder;
    frontAnimation.duration             = duration;
    frontAnimation.repeatCount          = 0;
    frontAnimation.removedOnCompletion  = YES;
    frontAnimation.autoreverses         = NO;
    frontAnimation.fillMode             = kCAFillModeForwards;

    CATransform3D tTrans                  = CATransform3DIdentity;
    tTrans.m34                            = _perspectiveAmount;

    frontAnimation.values               = [NSArray arrayWithObjects:
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,angleValues[0],effectX,effectY,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,angleValues[1],effectX,effectY,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,angleValues[2],effectX,effectY,0)],
                                               nil];
    frontAnimation.keyTimes             = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0],
                                              [NSNumber numberWithFloat:0.7],
                                              [NSNumber numberWithFloat:1],
                                               nil];
    frontAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                               nil];
    [fromView.layer addAnimation:frontAnimation forKey:@"transform"];
    fromView.userInteractionEnabled = NO;
    fromView.layer.transform = CATransform3DRotate(tTrans,angleValues[2],effectX,effectY,0);

}

+ (void)toViewAnimation:(UIView *)toView toViewCompletion:(void(^)(BOOL finished))toViewCompletion angleValues:(float *)angleValues effectX:(BOOL)effectX effectY:(BOOL)effectY{
    void(^block)(BOOL)  = ^(BOOL finished){
        toView.userInteractionEnabled = YES;
        if (finished)
            toView.layer.transform = CATransform3DIdentity;

        if (toViewCompletion)
            toViewCompletion(finished);
    };
    float duration = _spinDuration * 0.5;
    if (![UIView areAnimationsEnabled]){
        duration = 0;
    }
    BB3DTransitionResponder *backResponder = [[BB3DTransitionResponder alloc] initWithCompletion:block];
    CAKeyframeAnimation *backAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    backAnimation.delegate             = backResponder;
    backAnimation.duration             = duration;
    backAnimation.repeatCount          = 0;
    backAnimation.removedOnCompletion  = YES;
    backAnimation.autoreverses         = NO;
    backAnimation.fillMode             = kCAFillModeForwards;

    CATransform3D tTrans2                  = CATransform3DIdentity;
    tTrans2.m34                            = _perspectiveAmount;

    backAnimation.values               = [NSArray arrayWithObjects:
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,angleValues[3],effectX,effectY,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,angleValues[4],effectX,effectY,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,angleValues[5],effectX,effectY,0)],
                                               nil];
    backAnimation.keyTimes             = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0],
                                              [NSNumber numberWithFloat:0.7],
                                              [NSNumber numberWithFloat:1],
                                               nil];
    backAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                               nil];
    [toView.layer addAnimation:backAnimation forKey:@"transform"];
    toView.userInteractionEnabled = NO;
    toView.layer.transform = CATransform3DRotate(tTrans2,angleValues[5],effectX,effectY,0);
}

+ (void)spinFromBottom:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView){
        fromView.hidden = NO;
        if (fromView != toView){
            toView.hidden = YES;
        }
        [BB3DTransition fromViewAnimation:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion angleValues:BB3DBottomRightRadianValues effectX:YES effectY:NO];
    }
    else {
        toView.hidden = NO;
        [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:BB3DBottomRightRadianValues effectX:YES effectY:NO];
    }
}

+ (void)spinFromTop:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView){
        fromView.hidden = NO;
        if (fromView != toView){
            toView.hidden = YES;
        }
        [BB3DTransition fromViewAnimation:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion angleValues:BB3DTopLeftRadianValues effectX:YES effectY:NO];
    }
    else {
        toView.hidden = NO;
        [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:BB3DTopLeftRadianValues effectX:YES effectY:NO];
    }
}

+ (void)spinFromLeft:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView){
        fromView.hidden = NO;
        if (fromView != toView){
            toView.hidden = YES;
        }
        [BB3DTransition fromViewAnimation:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion angleValues:BB3DTopLeftRadianValues effectX:NO effectY:YES];
    }
    else {
        toView.hidden = NO;
        [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:BB3DTopLeftRadianValues effectX:NO effectY:YES];
    }
}

+ (void)spinFromRight:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView){
        fromView.hidden = NO;
        if (fromView != toView){
            toView.hidden = YES;
        }
        [BB3DTransition fromViewAnimation:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion angleValues:BB3DBottomRightRadianValues effectX:NO effectY:YES];
    }
    else {
        toView.hidden = NO;
        [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:BB3DBottomRightRadianValues effectX:NO effectY:YES];
    }
}

+ (void)setPerspectiveAmount:(float)amount {
    _perspectiveAmount = amount;
}

+ (float)getPerspectiveAmount {
    return _perspectiveAmount;
}

+ (void)setFlipDuration:(float)duration {
    _flipDuration = duration;
}

+ (float)getFlipDuration {
    return _flipDuration;
}

+ (void)setSpinDuration:(float)duration {
    _spinDuration = duration;
}

+ (float)getSpinDuration {
    return _spinDuration;
}

+ (void)setClockFlipDuration:(float)duration {
    _clockFlipDuration = duration;
}

+ (float)getClockFlipDuration {
    return _clockFlipDuration;
}

@end

@implementation BB3DTransitionResponder

@synthesize completionBlock = _completionBlock;

- (id)initWithCompletion:(void (^)(BOOL))completionBlock {
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (self.completionBlock)
        self.completionBlock(flag);
}

@end