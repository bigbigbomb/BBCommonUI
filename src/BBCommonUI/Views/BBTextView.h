//
//  Created by Brian Romanko on 6/1/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBLabelStyle.h"

@interface BBTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) BBLabelStyle *placeholderStyle;


- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;

@end