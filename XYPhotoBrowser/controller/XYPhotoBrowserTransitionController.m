//
//  XYPhotoBrowserTransitionController.m
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/13/15.
//
//

#import "XYPhotoBrowserTransitionController.h"
#import "XYPBTransitionAnimator.h"
#import "XYPhotoBrowserDismissalInteractionController.h"

@interface XYPhotoBrowserTransitionController ()

@property (nonatomic) XYPBTransitionAnimator *animator;
@property (nonatomic) XYPhotoBrowserDismissalInteractionController *interactionController;

@end

@implementation XYPhotoBrowserTransitionController

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _animator = [[XYPBTransitionAnimator alloc] init];
        _interactionController = [[XYPhotoBrowserDismissalInteractionController alloc] init];
        _forcesNonInteractiveDismissal = YES;
    }
    
    return self;
}

#pragma mark - XYPhotoBrowserTransitionController

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    [self.interactionController didPanWithPanGestureRecognizer:panGestureRecognizer viewToPan:viewToPan anchorPoint:anchorPoint];
}

- (UIView *)startingView {
    return self.animator.startingView;
}

- (void)setStartingView:(UIView *)startingView {
    self.animator.startingView = startingView;
}

- (UIView *)endingView {
    return self.animator.endingView;
}

- (void)setEndingView:(UIView *)endingView {
    self.animator.endingView = endingView;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.animator.dismissing = NO;
    
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	if (![dismissed isKindOfClass:NSClassFromString(@"XYPhotoBrowserController")]) {
		return nil;
	}
    self.animator.dismissing = YES;
    //
    return self.animator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.forcesNonInteractiveDismissal) {
        return nil;
    }
    
    // The interaction controller will be hiding the ending view, so we should get and set a visible version now.
    self.animator.endingViewForAnimation = [[self.animator class] newAnimationViewFromView:self.endingView];
    
    self.interactionController.animator = animator;
    self.interactionController.shouldAnimateUsingAnimator = self.endingView != nil;
    self.interactionController.viewToHideWhenBeginningTransition = self.startingView ? self.endingView : nil;
    
    return self.interactionController;
}

@end
