//
//  XYPhotoBrowserController.m
//  CKWebPhotoViewer
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserController.h"
#import "XYPhotoBrowserDataSource.h"
#import "XYPBArrayDataSource.h"
#import "XYPhotoBrowserTransitionController.h"
#import "XYPBScalingImageView.h"
#import "XYPhotoBrowserItem.h"
#import "XYPBControllerOverlayView.h"
#import "XYPBDefaultCaptionView.h"
#import "XYPhotoBrowserCategory.h"

#ifdef ANIMATED_GIF_SUPPORT
#import <FLAnimatedImage/FLAnimatedImage.h>
#endif

const struct XYPhotoBrowserControllerNotification XYPhotoBrowserControllerNotification = {
	.didNavigateToPhotoPage = @"XYPhotoBrowserControllerNotification.didNavigateToPhotoPage",
	.willDismiss = @"XYPhotoBrowserControllerNotification.willDismiss",
	.didDismiss = @"XYPhotoBrowserControllerNotification.didDismiss",
};

static const CGFloat XYPhotoBrowserControllerOverlayAnimationDuration = 0.2;
static const CGFloat XYPhotoBrowserControllerInterPhotoSpacing = 16.0;
static const UIEdgeInsets XYPhotoBrowserControllerCloseButtonImageInsets = {3, 0, -3, 0};

@interface XYPhotoBrowserController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, XYPhotoBrowserChildControllerDelegate>

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) XYPhotoBrowserTransitionController *transitionController;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;

@property (nonatomic) XYPBControllerOverlayView *overlayView;

// 自定义notificationCenter，作用限于`XYPhotoBrowserController`的实例
@property (nonatomic) NSNotificationCenter *notificationCenter;

@property (nonatomic) BOOL shouldHandleLongPress;
@property (nonatomic) BOOL overlayWasHiddenBeforeTransition;

@property (nonatomic, readonly) XYPhotoBrowserChildController *currentPhotoViewController;
@property (nonatomic, readonly) UIView *referenceViewForCurrentPhoto;
@property (nonatomic, readonly) CGPoint boundsCenterPoint;

@property (nonatomic, nullable) id<XYPhotoBrowserItem> initialPhoto;

@end

@implementation XYPhotoBrowserController

#pragma mark - NSObject

- (void)dealloc {
    _pageViewController.dataSource = nil;
    _pageViewController.delegate = nil;
}

#pragma mark - NSObject(UIResponderStandardEditActions)

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setImage:self.currentlyDisplayedPhoto.image];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.shouldHandleLongPress && action == @selector(copy:) && self.currentlyDisplayedPhoto.image) {
        return YES;
    }
    
    return NO;
}

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithDataSource:[XYPBArrayDataSource dataSourceWithPhotos:@[]] initialPhoto:nil delegate:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self commonInitWithDataSource:[XYPBArrayDataSource dataSourceWithPhotos:@[]] initialPhoto:nil delegate:nil];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configurePageViewControllerWithInitialPhoto];

    self.view.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.pageViewController.view.backgroundColor = [UIColor clearColor];

    [self.pageViewController.view addGestureRecognizer:self.panGestureRecognizer];
    [self.pageViewController.view addGestureRecognizer:self.singleTapGestureRecognizer];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self addOverlayView];
    
    self.transitionController.startingView = self.referenceViewForCurrentPhoto;
    
    UIView *endingView;
    if (self.currentlyDisplayedPhoto.image || self.currentlyDisplayedPhoto.placeholderImage) {
		if ([self.currentPhotoViewController.scalingImageView respondsToSelector:@selector(imageView)]) {
			endingView = self.currentPhotoViewController.scalingImageView.imageView;
		}
    }
    
    self.transitionController.endingView = endingView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.overlayWasHiddenBeforeTransition) {
        [self setOverlayViewHidden:NO animated:YES];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.pageViewController.view.frame = self.view.bounds;
    self.overlayView.frame = self.view.bounds;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
	if (self.presentedViewController) {
		[super dismissViewControllerAnimated:animated completion:completion];
	} else {
		[self dismissViewControllerAnimated:animated userInitiated:NO completion:completion];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// 内存释放
	[self.dataSource didReceiveMemoryWarning];
}

#pragma mark - XYPhotoBrowserController

- (instancetype)initWithDataSource:(id <XYPhotoBrowserDataSource>)dataSource {
    return [self initWithDataSource:dataSource initialPhoto:nil delegate:nil];
}

- (instancetype)initWithDataSource:(id <XYPhotoBrowserDataSource>)dataSource initialPhotoIndex:(NSInteger)initialPhotoIndex delegate:(nullable id <XYPhotoBrowserControllerDelegate>)delegate {
    id <XYPhotoBrowserItem> initialPhoto = [dataSource photoAtIndex:initialPhotoIndex];
    return [self initWithDataSource:dataSource initialPhoto:initialPhoto delegate:delegate];
}

- (instancetype)initWithDataSource:(id <XYPhotoBrowserDataSource>)dataSource initialPhoto:(nullable id <XYPhotoBrowserItem>)initialPhoto delegate:(nullable id <XYPhotoBrowserControllerDelegate>)delegate {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self commonInitWithDataSource:dataSource initialPhoto:initialPhoto delegate:delegate];
    }
    return self;
}

- (void)commonInitWithDataSource:(id <XYPhotoBrowserDataSource>)dataSource initialPhoto:(nullable id <XYPhotoBrowserItem>)initialPhoto delegate:(nullable id <XYPhotoBrowserControllerDelegate>)delegate {
    _dataSource = dataSource;
    _delegate = delegate;
    _initialPhoto = initialPhoto;

    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanWithGestureRecognizer:)];
    _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapWithGestureRecognizer:)];

    _transitionController = [[XYPhotoBrowserTransitionController alloc] init];
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = _transitionController;
    self.modalPresentationCapturesStatusBarAppearance = YES;

    _overlayView = ({
        XYPBControllerOverlayView *v = [[XYPBControllerOverlayView alloc] init];
        v.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage xypb_imageWithName:@"xypb_close"] landscapeImagePhone:[UIImage xypb_imageWithName:@"xypb_close_landscape"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped:)];
        v.leftBarButtonItem.imageInsets = XYPhotoBrowserControllerCloseButtonImageInsets;
        v;
    });
	
    _notificationCenter = [NSNotificationCenter new];
	
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(XYPhotoBrowserControllerInterPhotoSpacing)}];

    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
}

- (void)configurePageViewControllerWithInitialPhoto
{
    XYPhotoBrowserChildController *initialPhotoViewController;

    if (self.initialPhoto != nil && [self.dataSource indexOfPhoto:self.initialPhoto] != NSNotFound) {
        initialPhotoViewController = [self newPhotoViewControllerForPhoto:self.initialPhoto];
    } else {
        initialPhotoViewController = [self newPhotoViewControllerForPhoto:[self.dataSource photoAtIndex:0]];
    }
	
    [self setCurrentlyDisplayedViewController:initialPhotoViewController animated:NO];
}

- (void)addOverlayView {
    NSAssert(self.overlayView != nil, @"_overlayView must be set during initialization, to provide bar button items for this %@", NSStringFromClass([self class]));
	
    [self updateOverlayInformation];
    [self.view addSubview:self.overlayView];
    
    [self setOverlayViewHidden:YES animated:NO];
}

- (void)updateOverlayInformation {
	
    NSAttributedString *overlayTitle;
    NSUInteger photoIndex = [self.dataSource indexOfPhoto:self.currentlyDisplayedPhoto];
    NSInteger displayIndex = photoIndex + 1;
    
    if ([self.delegate respondsToSelector:@selector(photosViewController:titleForPhoto:atIndex:totalPhotoCount:)]) {
        overlayTitle = [self.delegate photosViewController:self titleForPhoto:self.currentlyDisplayedPhoto atIndex:photoIndex totalPhotoCount:self.dataSource.numberOfPhotos];
    }

    if (!overlayTitle && self.dataSource.numberOfPhotos <= 0) {
        overlayTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd", displayIndex] attributes:nil];
    }
    
    if (!overlayTitle && self.dataSource.numberOfPhotos > 1) {
		overlayTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd of %zd",displayIndex, self.dataSource.numberOfPhotos] attributes:nil];
    }
    
    self.overlayView.title = overlayTitle;
	
	UIBarButtonItem *rightItem;
	if ([self.delegate respondsToSelector:@selector(photosViewController:rightBarItemForPhoto:)]) {
		rightItem = [self.delegate photosViewController:self rightBarItemForPhoto:self.currentlyDisplayedPhoto];
		if (rightItem && (rightItem.target==nil || rightItem.action==nil)) {
			rightItem.target = self;
			rightItem.action = @selector(actionButtonTapped:);
		}
	} else {
		rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
	}
	self.overlayView.rightBarButtonItem = rightItem;
	
	// caption显示逻辑
	if ([self.delegate respondsToSelector:@selector(photosViewController:captionViewForPhoto:)]) {
		self.overlayView.captionView = [self.delegate photosViewController:self captionViewForPhoto:self.currentlyDisplayedPhoto];
	} else {
		self.overlayView.captionView = [[XYPBDefaultCaptionView alloc] initWithPhoto:self.currentlyDisplayedPhoto];
	}
	
	// 底部功能显示逻辑
	if ([self.delegate respondsToSelector:@selector(photosViewController:functionViewForPhoto:)]) {
		self.overlayView.funtionView = [self.delegate photosViewController:self functionViewForPhoto:self.currentlyDisplayedPhoto];
	}
}

- (void)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES userInitiated:YES completion:nil];
}

- (void)actionButtonTapped:(id)sender {
    BOOL clientDidHandle = NO;
    
    if ([self.delegate respondsToSelector:@selector(photosViewController:handleActionButtonTappedForPhoto:)]) {
        clientDidHandle = [self.delegate photosViewController:self handleActionButtonTappedForPhoto:self.currentlyDisplayedPhoto];
    }
    
    if (!clientDidHandle && (self.currentlyDisplayedPhoto.image || self.currentlyDisplayedPhoto.imageData)) {
        UIImage *image = self.currentlyDisplayedPhoto.image ? self.currentlyDisplayedPhoto.image : [UIImage imageWithData:self.currentlyDisplayedPhoto.imageData];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
        activityViewController.popoverPresentationController.barButtonItem = sender;
        activityViewController.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
            if (completed && [self.delegate respondsToSelector:@selector(photosViewController:actionCompletedWithActivityType:)]) {
                [self.delegate photosViewController:self actionCompletedWithActivityType:activityType];
            }
        };

        [self displayActivityViewController:activityViewController animated:YES];
    }
}

- (void)displayActivityViewController:(UIActivityViewController *)controller animated:(BOOL)animated {

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:controller animated:animated completion:nil];
    }
    else {
        controller.popoverPresentationController.barButtonItem = self.rightBarButtonItem;
        [self presentViewController:controller animated:animated completion:nil];
    }
}

- (UIBarButtonItem *)leftBarButtonItem {
    return self.overlayView.leftBarButtonItem;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    self.overlayView.leftBarButtonItem = leftBarButtonItem;
}

- (NSArray *)leftBarButtonItems {
    return self.overlayView.leftBarButtonItems;
}

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems {
    self.overlayView.leftBarButtonItems = leftBarButtonItems;
}

- (UIBarButtonItem *)rightBarButtonItem {
    return self.overlayView.rightBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    self.overlayView.rightBarButtonItem = rightBarButtonItem;
}

- (NSArray *)rightBarButtonItems {
    return self.overlayView.rightBarButtonItems;
}

- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems {
    self.overlayView.rightBarButtonItems = rightBarButtonItems;
}

- (void)displayPhoto:(id <XYPhotoBrowserItem>)photo animated:(BOOL)animated {
    if ([self.dataSource indexOfPhoto:photo] == NSNotFound) {
        return;
    }
	
    XYPhotoBrowserChildController *photoViewController = [self newPhotoViewControllerForPhoto:photo];
    [self setCurrentlyDisplayedViewController:photoViewController animated:animated];
    [self updateOverlayInformation];
	
	if ([self.delegate respondsToSelector:@selector(photosViewController:didNavigateToPhotoPage:atIndex:)]) {
		[self.delegate photosViewController:self didNavigateToPhotoPage:photoViewController atIndex:[self.dataSource indexOfPhoto:photo]];
	}
}

- (void)updatePhotoAtIndex:(NSInteger)photoIndex {
    id<XYPhotoBrowserItem> photo = [self.dataSource photoAtIndex:photoIndex];
    if (!photo) {
        return;
    }
    [self updatePhoto:photo];
}

- (void)updatePhoto:(id<XYPhotoBrowserItem>)photo {
    if ([self.dataSource indexOfPhoto:photo] == NSNotFound) {
        return;
    }
	
    [self.notificationCenter postNotificationName:XYPhotoBrowserChildControllerPhotoImageUpdatedNotification object:photo];

    if ([self.currentlyDisplayedPhoto isEqual:photo]) {
        [self updateOverlayInformation];
    }
}

- (void)reloadPhotosAnimated:(BOOL)animated {
    id<XYPhotoBrowserItem> newCurrentPhoto;

    if ([self.dataSource indexOfPhoto:self.currentlyDisplayedPhoto] != NSNotFound) {
        newCurrentPhoto = self.currentlyDisplayedPhoto;
    } else {
        newCurrentPhoto = [self.dataSource photoAtIndex:0];
    }

    [self displayPhoto:newCurrentPhoto animated:animated];

    if (self.overlayView.hidden) {
        [self setOverlayViewHidden:NO animated:animated];
    }
}

#pragma mark - Gesture Recognizers

- (void)didSingleTapWithGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
	BOOL goAhead = YES;
	if ([_delegate respondsToSelector:@selector(photosViewController:handleSingleTapForPhoto:withGestureRecognizer:)]) {
		goAhead = [_delegate photosViewController:self handleSingleTapForPhoto:self.currentlyDisplayedPhoto withGestureRecognizer:tapGestureRecognizer];
	}
	if (goAhead) {
		[self setOverlayViewHidden:!self.overlayView.hidden animated:YES];
	}
}

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.transitionController.forcesNonInteractiveDismissal = NO;
		CGPoint velocityPoint = [panGestureRecognizer velocityInView:[UIApplication sharedApplication].delegate.window];
		NSLog(@"velocityPoint %@", NSStringFromCGPoint(velocityPoint));
		//		self.transitionController
        [self dismissViewControllerAnimated:YES userInitiated:YES completion:nil];
    }
    else {
        self.transitionController.forcesNonInteractiveDismissal = YES;
        [self.transitionController didPanWithPanGestureRecognizer:panGestureRecognizer viewToPan:self.pageViewController.view anchorPoint:self.boundsCenterPoint];
    }
}

#pragma mark - View Controller Dismissal
    
- (void)dismissViewControllerAnimated:(BOOL)animated userInitiated:(BOOL)isUserInitiated completion:(void (^)(void))completion {
    if (self.presentedViewController) {
        [super dismissViewControllerAnimated:animated completion:completion];
        return;
    }
    
    UIView *startingView;
    if (self.currentlyDisplayedPhoto.image || self.currentlyDisplayedPhoto.placeholderImage || self.currentlyDisplayedPhoto.imageData) {
		if ([self.currentPhotoViewController.scalingImageView respondsToSelector:@selector(imageView)]) {
			startingView = self.currentPhotoViewController.scalingImageView.imageView;
		}
    }
    
    self.transitionController.startingView = startingView;
    self.transitionController.endingView = self.referenceViewForCurrentPhoto;

    self.overlayWasHiddenBeforeTransition = self.overlayView.hidden;
    [self setOverlayViewHidden:YES animated:animated];

    // Cocoa convention is not to call delegate methods when you do something directly in code,
    // so we'll not call delegate methods if this is a programmatic dismissal:
    BOOL const shouldSendDelegateMessages = isUserInitiated;
    
    if (shouldSendDelegateMessages && [self.delegate respondsToSelector:@selector(photosViewControllerWillDismiss:)]) {
        [self.delegate photosViewControllerWillDismiss:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XYPhotoBrowserControllerNotification.willDismiss object:self];
    
    [super dismissViewControllerAnimated:animated completion:^{
        BOOL isStillOnscreen = self.view.window != nil; // Happens when the dismissal is canceled.
        
        if (isStillOnscreen && !self.overlayWasHiddenBeforeTransition) {
            [self setOverlayViewHidden:NO animated:YES];
        }
        
        if (!isStillOnscreen) {
            if (shouldSendDelegateMessages && [self.delegate respondsToSelector:@selector(photosViewControllerDidDismiss:)]) {
                [self.delegate photosViewControllerDidDismiss:self];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XYPhotoBrowserControllerNotification.didDismiss object:self];
        }

        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Convenience

- (void)setCurrentlyDisplayedViewController:(UIViewController <XYPhotoBrowserContainer> *)viewController animated:(BOOL)animated
{
	if (!viewController) { return; }
	
    if ([viewController.photo isEqual:self.currentlyDisplayedPhoto]) {
        animated = NO;
    }

    NSInteger currentIdx = [self.dataSource indexOfPhoto:self.currentlyDisplayedPhoto];
    NSInteger newIdx = [self.dataSource indexOfPhoto:viewController.photo];
    UIPageViewControllerNavigationDirection direction = (newIdx < currentIdx) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    
    [self.pageViewController setViewControllers:@[viewController] direction:direction animated:animated completion:nil];
}

- (void)setOverlayViewHidden:(BOOL)hidden animated:(BOOL)animated {
    if (hidden == self.overlayView.hidden) {
        return;
    }
    
    if (animated) {
        self.overlayView.hidden = NO;
        
        self.overlayView.alpha = hidden ? 1.0 : 0.0;
        
        [UIView animateWithDuration:XYPhotoBrowserControllerOverlayAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.overlayView.alpha = hidden ? 0.0 : 1.0;
        } completion:^(BOOL finished) {
            self.overlayView.alpha = 1.0;
            self.overlayView.hidden = hidden;
        }];
    }
    else {
        self.overlayView.hidden = hidden;
    }
}

- (XYPhotoBrowserChildController *)newPhotoViewControllerForPhoto:(id <XYPhotoBrowserItem>)photo
{
    if (photo) {
		
        UIView *loadingView;
        if ([self.delegate respondsToSelector:@selector(photosViewController:loadingViewForPhoto:)]) {
            loadingView = [self.delegate photosViewController:self loadingViewForPhoto:photo];
        }
		
		UIView <XYPhotoBrowserContentView> *contentView;
		if ([self.delegate respondsToSelector:@selector(photosViewController:contentViewForPhoto:)]) {
			contentView = [self.delegate photosViewController:self contentViewForPhoto:photo];
		}
		if (!contentView) {
			contentView = [[XYPBScalingImageView alloc] initWithPhoto:photo];
		}
		
        XYPhotoBrowserChildController *photoViewController = [[XYPhotoBrowserChildController alloc] init];
		photoViewController.scalingImageView = contentView;
		photoViewController.loadingView = loadingView;
		photoViewController.notificationCenter = self.notificationCenter;
        photoViewController.delegate = self;
		
		if (photoViewController.doubleTapGestureRecognizer) {
			[self.singleTapGestureRecognizer requireGestureRecognizerToFail:photoViewController.doubleTapGestureRecognizer];
		}

        if ([self.delegate respondsToSelector:@selector(photosViewController:maximumZoomScaleForPhoto:)]
			&& [photoViewController.scalingImageView respondsToSelector:@selector(setMaximumZoomScale:)]) {
            CGFloat maximumZoomScale = [self.delegate photosViewController:self maximumZoomScaleForPhoto:photo];
            photoViewController.scalingImageView.maximumZoomScale = maximumZoomScale;
        }
		
        return photoViewController;
    }
    
    return nil;
}

- (void)didNavigateToPhotoPage:(XYPhotoBrowserChildController *)photoPage {
    if ([self.delegate respondsToSelector:@selector(photosViewController:didNavigateToPhotoPage:atIndex:)]) {
        [self.delegate photosViewController:self didNavigateToPhotoPage:photoPage atIndex:[self.dataSource indexOfPhoto:photoPage.photo]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XYPhotoBrowserControllerNotification.didNavigateToPhotoPage object:self];
}

- (id <XYPhotoBrowserItem>)currentlyDisplayedPhoto {
    return self.currentPhotoViewController.photo;
}

- (XYPhotoBrowserChildController *)currentPhotoViewController {
    return self.pageViewController.viewControllers.firstObject;
}

- (UIView *)referenceViewForCurrentPhoto {
    if ([self.delegate respondsToSelector:@selector(photosViewController:referenceViewForPhoto:)]) {
        return [self.delegate photosViewController:self referenceViewForPhoto:self.currentlyDisplayedPhoto];
    }
    return nil;
}

- (CGPoint)boundsCenterPoint {
    return CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

#pragma mark - XYPhotoBrowserChildControllerDelegate

- (void)photoViewController:(XYPhotoBrowserChildController *)photoViewController didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    self.shouldHandleLongPress = NO;
    
    BOOL clientDidHandle = NO;
    if ([self.delegate respondsToSelector:@selector(photosViewController:handleLongPressForPhoto:withGestureRecognizer:)]) {
        clientDidHandle = [self.delegate photosViewController:self handleLongPressForPhoto:photoViewController.photo withGestureRecognizer:longPressGestureRecognizer];
    }
    
    self.shouldHandleLongPress = !clientDidHandle;
    
    if (self.shouldHandleLongPress) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        CGRect targetRect = CGRectZero;
        targetRect.origin = [longPressGestureRecognizer locationInView:longPressGestureRecognizer.view];
        [menuController setTargetRect:targetRect inView:longPressGestureRecognizer.view];
        [menuController setMenuVisible:YES animated:YES];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController <XYPhotoBrowserContainer> *)viewController {
    NSUInteger photoIndex = [self.dataSource indexOfPhoto:viewController.photo];
    if (photoIndex == 0 || photoIndex == NSNotFound) {
        return nil;
    }
	
    return [self newPhotoViewControllerForPhoto:[self.dataSource photoAtIndex:(photoIndex - 1)]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController <XYPhotoBrowserContainer> *)viewController {
    NSUInteger photoIndex = [self.dataSource indexOfPhoto:viewController.photo];
    if (photoIndex == NSNotFound) {
        return nil;
    }
	
    return [self newPhotoViewControllerForPhoto:[self.dataSource photoAtIndex:(photoIndex + 1)]];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
		[self updateOverlayInformation];
		
		UIViewController <XYPhotoBrowserContainer> *photoViewController = pageViewController.viewControllers.firstObject;
		[self didNavigateToPhotoPage:photoViewController];
    }
}

@end
