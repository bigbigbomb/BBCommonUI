//
//  Created by Lee Fastenau on 1/9/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BBTextField;
@class BBLabelStyle;

@interface BBTextFieldStyle : NSObject

@property(nonatomic, strong) BBLabelStyle *textStyle;
@property(nonatomic, strong) BBLabelStyle *placeholderStyle;
@property(nonatomic, strong) UIImage *background;
@property(nonatomic) UIControlContentHorizontalAlignment contentHorizontalAlignment;
@property(nonatomic) UIControlContentVerticalAlignment contentVerticalAlignment;
@property(nonatomic) UIEdgeInsets textInsets;
@property(nonatomic) UIEdgeInsets editingTextInsets;
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic, copy) void (^styleAsValid)(BBTextField *);
@property(nonatomic, copy) void (^styleAsInvalid)(BBTextField *);

- (BBTextField *)bbTextFieldWithFrame:(CGRect)frame;

@end