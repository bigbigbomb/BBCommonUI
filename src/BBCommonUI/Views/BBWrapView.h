//
//  Created by Lee Fastenau on 7/12/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol BBWrapViewDelegate;

@interface BBWrapView : UIView {
@private
    id <BBWrapViewDelegate> __unsafe_unretained _delegate;
}

@property(nonatomic) float itemPadding;
@property(nonatomic) float lineHeight;
@property(nonatomic) UIEdgeInsets edgeInsets;
@property(nonatomic) BOOL verticallyCenterItems;

/**
 * The object acting as the delegate for the wrap view instance.
 */
@property(unsafe_unretained) id <BBWrapViewDelegate> delegate;

- (id)initWithLineHeight:(float)lineHeight itemPadding:(float)itemPadding edgeInsets:(UIEdgeInsets)edgeInsets;

@end

/**
 * Provides information to a delegate receiver about changes to a wrap view.
 */
@protocol BBWrapViewDelegate <NSObject>

@required
/**
 * Called when the wrap view size changes due to a subview being added, removed or resized.
 */
- (void)wrapViewLayoutDidChange:(BBWrapView *)wrapView;

@end