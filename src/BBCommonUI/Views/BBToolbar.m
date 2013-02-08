//
// Created by brian on 9/10/12.
//
//


#import "BBToolbar.h"

#define kNextPreviousTag 10001
#define kDoneButtonTag 10002


@interface BBToolbar ()
@property(nonatomic, strong, readwrite) NSArray *controls;

@end

@implementation BBToolbar
@synthesize controls = _controls;


#pragma mark - Static

+ (id)newInputAccessoryToolbar:(NSArray *)controls {
    BBToolbar *toolbar = [[BBToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];

    NSMutableArray *items = [NSMutableArray array];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.momentary = YES;
    [segmentedControl addTarget:toolbar action:@selector(accessoryNextPreviousTap:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segmentedButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    segmentedButton.tag = kNextPreviousTag;
    [items insertObject:segmentedButton atIndex:0];
    segmentedControl.selectedSegmentIndex = -1;

    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:toolbar action:@selector(accessoryDoneTap:)];
    button.tag = kDoneButtonTag;
    [items addObject:button];

    toolbar.items = items;
    toolbar.controls = controls;


    // Wire up event handling for the controls
    for (id control in controls) {
        if (![control respondsToSelector:@selector(setInputAccessoryView:)])
            continue;

        [BBToolbar removeToolbar:control];

        [control performSelector:@selector(setInputAccessoryView:) withObject:toolbar];
        if ([control respondsToSelector:@selector(addTarget:action:forControlEvents:)])
            [control addTarget:toolbar action:@selector(accessoryEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];

        if ([control conformsToProtocol:@protocol(UITextInputTraits)]) {
            id<UITextInputTraits> text = control;
            if (text.returnKeyType == UIReturnKeyNext)
                [control addTarget:toolbar action:@selector(accessoryEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }

        if ([control respondsToSelector:@selector(isEnabled)]) {
            [control addObserver:toolbar forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
        }
        if ([control respondsToSelector:@selector(isHidden)]) {
            [control addObserver:toolbar forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
        }
        [[NSNotificationCenter defaultCenter] addObserver:toolbar selector:@selector(accessoryEditingDidBegin:) name:UITextViewTextDidBeginEditingNotification object:control];
    }

    return toolbar;
}

- (void)dealloc {
    for (id control in self.controls)
        [BBToolbar removeToolbar:control];

}

#pragma mark - Private

+ (void)invokeSelector:(SEL)selector target:(id)target returnValue:(void *)returnValue {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
            [[target class] instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:target];
    [invocation invoke];
    [invocation getReturnValue:returnValue];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSInteger indexOfSender = [self.controls indexOfObject:object];

    NSInteger indexOfFirstResponder = -1;
    for (NSUInteger i = 0; i < self.controls.count; i++) {
        id control = [self.controls objectAtIndex:i];
        if (![control respondsToSelector:@selector(isFirstResponder)]) continue;

        BOOL isFirstResponder = NO;
        [BBToolbar invokeSelector:@selector(isFirstResponder) target:control returnValue:&isFirstResponder];
        if (isFirstResponder) {
            indexOfFirstResponder = i;
            break;
        }
    }

    // If the changed control is either previous or next, refresh the buttons
    if ((indexOfFirstResponder >= 0) && ((indexOfFirstResponder == indexOfSender - 1) || (indexOfFirstResponder == indexOfSender + 1)))
        [self accessoryEditingDidBegin:[self.controls objectAtIndex:(NSUInteger) indexOfFirstResponder]];
}

- (void)accessoryEditingDidBegin:(id)sender {
    id sendingControl = sender;
    if ([sender isKindOfClass:[NSNotification class]])
        sendingControl = ((NSNotification *)sender).object;

    NSInteger indexOfSender = [self.controls indexOfObject:sendingControl];
    BOOL previousControlIsEnabled = YES;
    BOOL nextControlIsEnabled = YES;
    BOOL previousControlIsHidden = NO;
    BOOL nextControlIsHidden = NO;
    if (indexOfSender > 0) {
        id previousControl = [self.controls objectAtIndex:(NSUInteger) (indexOfSender - 1)];
        if ([previousControl respondsToSelector:@selector(isEnabled)])
            [BBToolbar invokeSelector:@selector(isEnabled) target:previousControl returnValue:&previousControlIsEnabled];
        if ([previousControl respondsToSelector:@selector(isHidden)])
            [BBToolbar invokeSelector:@selector(isHidden) target:previousControl returnValue:&previousControlIsHidden];
    }
    if (indexOfSender < self.controls.count - 1) {
        id nextControl = [self.controls objectAtIndex:(NSUInteger) (indexOfSender + 1)];
        if ([nextControl respondsToSelector:@selector(isEnabled)])
            [BBToolbar invokeSelector:@selector(isEnabled) target:nextControl returnValue:&nextControlIsEnabled];
        if ([nextControl respondsToSelector:@selector(isHidden)])
            [BBToolbar invokeSelector:@selector(isHidden) target:nextControl returnValue:&nextControlIsHidden];

    }

    UISegmentedControl *segmented = (UISegmentedControl *) [self buttonWithTag:kNextPreviousTag].customView;
    if (indexOfSender == 0) {
        [segmented setEnabled:NO forSegmentAtIndex:0];
        [segmented setEnabled:nextControlIsEnabled &&!nextControlIsHidden forSegmentAtIndex:1];
    } else if (indexOfSender == self.controls.count - 1) {
        [segmented setEnabled:previousControlIsEnabled && !previousControlIsHidden forSegmentAtIndex:0];
        [segmented setEnabled:NO forSegmentAtIndex:1];
    } else {
        [segmented setEnabled:previousControlIsEnabled && !previousControlIsHidden forSegmentAtIndex:0];
        [segmented setEnabled:nextControlIsEnabled && !nextControlIsHidden forSegmentAtIndex:1];
    }
}

- (void)accessoryEditingDidEndOnExit:(id)sender {
    [self nextControl];
}

- (void)accessoryNextPreviousTap:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 0)
        [self previousControl];
    else if ([sender selectedSegmentIndex] == 1)
        [self nextControl];
}

- (NSInteger)indexOfFirstResponder {
    NSInteger selectedIndex = -1;
    for (NSUInteger i = 0; i < self.controls.count; i++) {
        if ([[self.controls objectAtIndex:i] performSelector:@selector(isFirstResponder)]) {
            selectedIndex = i;
            break;
        }
    }
    return selectedIndex;
}

- (void)previousControl {
    NSInteger selectedIndex = [self indexOfFirstResponder];
    if (selectedIndex > 0) {
        id previousControl = [self.controls objectAtIndex:(NSUInteger) (selectedIndex - 1)];
        [self makeControlFirstResponder:previousControl];
    }
}

- (void)nextControl {
    NSInteger selectedIndex = [self indexOfFirstResponder];
    if (selectedIndex <= self.controls.count - 2) {
        id nextControl = [self.controls objectAtIndex:(NSUInteger) (selectedIndex + 1)];
        [self makeControlFirstResponder:nextControl];
    }
}

- (void)makeControlFirstResponder:(UIResponder *)control {
    if (control.canBecomeFirstResponder)
        [control becomeFirstResponder];
    else
        [self accessoryDoneTap:nil];
}

- (void)accessoryDoneTap:(UIBarButtonItem *)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (UIBarButtonItem *)buttonWithTag:(NSInteger)tag {
    id control = nil;
    for (UIBarButtonItem *item in self.items) {
        if ([item respondsToSelector:@selector(tag)] && item.tag == tag) {
            control = item;
            break;
        }
    }
    return control;
}

+ (void)removeToolbar:(id)control {
    if (![control respondsToSelector:@selector(setInputAccessoryView:)]) return;

    BBToolbar *existing = [control performSelector:@selector(inputAccessoryView)];
    if (existing != nil && [existing isKindOfClass:[BBToolbar class]]) {
        if ([control respondsToSelector:@selector(removeTarget:action:forControlEvents:)]) {
            [control removeTarget:existing action:@selector(accessoryEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
            [control removeTarget:existing action:@selector(accessoryEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }

        if ([control respondsToSelector:@selector(isEnabled)]) {
            [control removeObserver:existing forKeyPath:@"enabled"];
        }
        if ([control respondsToSelector:@selector(isHidden)]) {
            [control removeObserver:existing forKeyPath:@"hidden"];
        }

        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:control];

        NSMutableArray *newControls = [existing.controls mutableCopy];
        [newControls removeObject:control];
        existing.controls = newControls;

        [control performSelector:@selector(setInputAccessoryView:) withObject:nil];
    }
}


@end