//
//  Created by Lee Fastenau on 7/12/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BBWrapView : UIView {
    
@private
    float _rightMargin;
    float _lineHeight;
    CGPoint _currentPosition;
    UIEdgeInsets _edgeInsets;
    
}

@property(nonatomic) float rightMargin;
@property(nonatomic) float lineHeight;
@property(nonatomic) CGPoint currentPosition;
@property(nonatomic) UIEdgeInsets edgeInsets;

- (id)initWithLineHeight:(float)lineHeight rightMargin:(float)rightMargin edgeInsets:(UIEdgeInsets)edgeInsets;

@end