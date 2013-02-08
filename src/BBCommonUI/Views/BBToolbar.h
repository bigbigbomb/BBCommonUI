//
// Created by brian on 9/10/12.
//
//


#import <Foundation/Foundation.h>


@interface BBToolbar : UIToolbar

@property(nonatomic, strong, readonly) NSArray *controls;

+ (id)newInputAccessoryToolbar:(NSArray *)controls;

@end