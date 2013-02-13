//
//  Created by Lee Fastenau on 7/12/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BBWrapView : UIView {
    
@private
    float _itemPadding;
    float _lineHeight;
    float _availableRightSpace;
    CGPoint _currentPosition;
    UIEdgeInsets _edgeInsets;
    
}

@property(nonatomic) float itemPadding;
@property(nonatomic) float lineHeight;
@property(nonatomic) float availableRightSpace;
@property(nonatomic) CGPoint currentPosition;
@property(nonatomic) UIEdgeInsets edgeInsets;

- (id)initWithLineHeight:(float)lineHeight itemPadding:(float)itemPadding edgeInsets:(UIEdgeInsets)edgeInsets;

@end