//
// Created by brian on 2/14/13.
//
//


#import "NSObject+Selectors.h"


@implementation NSObject (Selectors)

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay {
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)())block {
    block();
}

@end