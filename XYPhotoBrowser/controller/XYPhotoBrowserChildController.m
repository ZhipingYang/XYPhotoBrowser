//
//  XYPhotoBrowserChildController.m
//  CKWebPhotoViewer
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserChildController.h"
#import "XYPhotoBrowserItem.h"
#import "XYPBScalingImageView.h"
#import "XYPhotoBrowserCategory.h"
#ifdef ANIMATED_GIF_SUPPORT
#import <FLAnimatedImage/FLAnimatedImage.h>
#endif

NSString * const XYPhotoBrowserChildControllerPhotoImageUpdatedNotification = @"XYPhotoBrowserChildControllerPhotoImageUpdatedNotification";

@interface XYPhotoBrowserChildController ()

@property (nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation XYPhotoBrowserChildController

#pragma mark - UIViewController

- (void)dealloc
{
	if (_notificationCenter) {
		[_notificationCenter removeObserver:self];
	}
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self setupGestureRecognizers];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self setupGestureRecognizers];
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view addGestureRecognizer:self.doubleTapGestureRecognizer];
	[self.view addGestureRecognizer:self.longPressGestureRecognizer];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
	
	_scalingImageView.frame = self.view.bounds;
	
	if (_loadingView) {
		[_loadingView sizeToFit];
		_loadingView.center = CGPointMake(self.view.xypb_width/2.0, self.view.xypb_height/2.0);
		[self.view bringSubviewToFront:_loadingView];
	}
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

#pragma mark - set / get

- (void)setScalingImageView:(UIView<XYPhotoBrowserContentView> *)scalingImageView
{
	if (_scalingImageView == scalingImageView) { return; }
	[_scalingImageView removeFromSuperview];
	_scalingImageView = scalingImageView;
	_loadingView.hidden = _scalingImageView.photo.hasData;
	[self.view addSubview:_scalingImageView];
	[self.view setNeedsLayout];
}

- (void)setLoadingView:(UIView *)loadingView
{
	if (_loadingView == loadingView && _loadingView!=nil) { return; }
	[_loadingView removeFromSuperview];
	_loadingView = loadingView;
	if (!loadingView) {
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[activityIndicator startAnimating];
		// 😂 防止moveToView后才开始startAnimating，自动设置hidden = NO
		activityIndicator.hidesWhenStopped = NO;
		_loadingView = activityIndicator;
		_loadingView.hidden = _scalingImageView.photo.hasData;
	}
	[self.view addSubview:_loadingView];
	[self.view setNeedsLayout];
}

- (void)setNotificationCenter:(NSNotificationCenter *)notificationCenter
{
	if (_notificationCenter == notificationCenter && _notificationCenter != nil) { return; }
	[_notificationCenter removeObserver:self];
	_notificationCenter = notificationCenter;
	[_notificationCenter addObserver:self selector:@selector(photoImageUpdatedWithNotification:) name:XYPhotoBrowserChildControllerPhotoImageUpdatedNotification object:nil];
}

- (id<XYPhotoBrowserItem>)photo
{
	return _scalingImageView.photo;
}

#pragma mark - XYPhotoBrowserChildController

- (void)photoImageUpdatedWithNotification:(NSNotification *)notification
{
	id <XYPhotoBrowserItem> photo = notification.object;
	
    if ([photo conformsToProtocol:@protocol(XYPhotoBrowserItem)] && [photo isEqual:self.photo]) {
		
		[self.scalingImageView updatePhoto:self.photo];
		
		if ([photo hasData]) {
			[self.loadingView removeFromSuperview];
		} else {
			[self.view addSubview:self.loadingView];
		}
    }
}

#pragma mark - Gesture Recognizers

- (void)setupGestureRecognizers
{
    self.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapWithGestureRecognizer:)];
    self.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressWithGestureRecognizer:)];
}

- (void)didDoubleTapWithGestureRecognizer:(UITapGestureRecognizer *)recognizer
{
	if (![_scalingImageView respondsToSelector:@selector(zoomToRect:animated:)]) { return; }
	if (![_scalingImageView respondsToSelector:@selector(zoomScale)]) { return; }
	if (![_scalingImageView respondsToSelector:@selector(maximumZoomScale)]) { return; }
	if (![_scalingImageView respondsToSelector:@selector(minimumZoomScale)]) { return; }
	
    CGPoint pointInView = [recognizer locationInView:self.scalingImageView.imageView];
    
    CGFloat newZoomScale = self.scalingImageView.maximumZoomScale;

    if (self.scalingImageView.zoomScale >= self.scalingImageView.maximumZoomScale
        || ABS(self.scalingImageView.zoomScale - self.scalingImageView.maximumZoomScale) <= 0.01) {
        newZoomScale = self.scalingImageView.minimumZoomScale;
    }
    
    CGSize scrollViewSize = self.scalingImageView.bounds.size;
    
    CGFloat width = scrollViewSize.width / newZoomScale;
    CGFloat height = scrollViewSize.height / newZoomScale;
    CGFloat originX = pointInView.x - (width / 2.0);
    CGFloat originY = pointInView.y - (height / 2.0);
    
    CGRect rectToZoomTo = CGRectMake(originX, originY, width, height);
    
    [self.scalingImageView zoomToRect:rectToZoomTo animated:YES];
}

- (void)didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)recognizer
{
	if ([self.delegate respondsToSelector:@selector(photoViewController:didLongPressWithGestureRecognizer:)]) {
		if (recognizer.state == UIGestureRecognizerStateBegan) {
			[self.delegate photoViewController:self didLongPressWithGestureRecognizer:recognizer];
		}
	}
}

@end
