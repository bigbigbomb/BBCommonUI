//
//  Created by Lee Fastenau on 7/11/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol BBStackViewDelegate;

/**
 * The orientation of a stack view.
 */
typedef enum {
    BBStackViewOrientationVertical, /**< Vertical layout. */
    BBStackViewOrientationHorizontal /**< Horizontal layout. */
} BBStackViewOrientation;

/**
 * Horizontally or vertically stacking container view.
 * Automatically stacks subviews either horizontally or vertically depending on the provided orientation in the order in which they are added to the superview.
 */
@interface BBStackView : UIView {
    
@private
    BBStackViewOrientation _orientation;
    id <BBStackViewDelegate> __unsafe_unretained _delegate;
    BOOL _isUpdating;
    BOOL _isRemovingSubview;
    
}

@property(nonatomic) BOOL isRemovingSubview;


/**
 * The object acting as the delegate for the stack view instance.
 */
@property(unsafe_unretained) id <BBStackViewDelegate> delegate;

/**
 * The orientation of the subviews. Changing this after subviews have been added will cause the stack view to update its layout to match the provided orientation, how spacers will not adjust their orientation. 
 */
@property(nonatomic) BBStackViewOrientation orientation;

/**
 * Initializes and returns a stack view with the specified frame and orientation.
 * @param frame A rectangle specifying the initial location and size of the stack view in its superview's coordinates. The frame's size will change as subviews are added or resized within the stack view.
 * @param orientation The orientation of the stack view. Horizontal orientation lays a stack view's subviews out in the order they are added from left to right while vertical orientation lays them out from top to bottom. Crazy, huh?
 */
- (id)initWithFrame:(CGRect)frame orientation:(BBStackViewOrientation)orientation;

/**
 * Adds a spacer after the most recently added subview, if any. Spacers are currently implemented as empty UIViews with a frame size of either N x 1 or 1 x N depending on the orientation of the stack view at the time the spacer was added. Changing the orientation of a stack view will not change the orientation (or size) of the spacers, possibly causing an undesired layout.
 * @param length The amount of space to add.
 * @see orientation
 */
- (void)addSpacer:(float)length;

/**
 * Removes a subview and updates the stack view size. Use this instead of removeFromSuperview on subviews, otherwise the stack view will not resize properly.
 * @param subview The subview to remove.
 */
- (void)removeSubview:(UIView *)subview;

@end

/**
 * Provides information to a delegate receiver about changes to a stack view.
 */
@protocol BBStackViewDelegate <NSObject>

@required
    /**
     * Called when the stack view size changes due to a subview being added or resized.
     */
    - (void)stackViewLayoutDidChange:(BBStackView *)stackView;

@end