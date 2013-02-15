//
// Created by brian on 2/14/13.
//
//


#import <Foundation/Foundation.h>

@interface NSObject (Selectors)

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end