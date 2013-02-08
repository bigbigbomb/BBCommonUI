//
//  Created by Lee Fastenau on 1/9/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBLabelStyle.h"

@protocol BBTextFieldValidationDelegate;

@interface BBTextField : UITextField

@property(nonatomic, strong) BBLabelStyle *placeholderStyle;
@property(nonatomic) UIEdgeInsets textInsets;
@property(nonatomic) UIEdgeInsets editingTextInsets;
@property(nonatomic, unsafe_unretained) id<BBTextFieldValidationDelegate> validationDelegate;
@property(nonatomic, copy) void (^styleAsValid)(BBTextField *);
@property(nonatomic, copy) void (^styleAsInvalid)(BBTextField *);

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;

- (void)applyValidStyle;

- (void)applyInvalidStyle;

- (BOOL)validate;


@end

@protocol BBTextFieldValidationDelegate <NSObject>

- (BOOL)bbTextField:(BBTextField *)bbTextField validateText:(NSString *)text;

@end