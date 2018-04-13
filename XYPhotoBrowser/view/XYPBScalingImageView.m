//
//  XYPBScalingImageView.m
//  CKWebPhotoViewer
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2015 The New York Times Company. All rights reserved.
//

#import "XYPBScalingImageView.h"

#import "tgmath.h"

#ifdef ANIMATED_GIF_SUPPORT
#import <FLAnimatedImage/FLAnimatedImage.h>
#endif

@interface XYPBScalingImageView ()<UIScrollViewDelegate>

#ifdef ANIMATED_GIF_SUPPORT
@property (nonatomic) FLAnimatedImageView *imageView;
#else
@property (nonatomic) UIImageView *imageView;
#endif

@property (nonatomic, strong) id <XYPhotoBrowserItem> photo;

@end

@implementation XYPBScalingImageView

#pragma mark - UIView

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    [self centerScrollViewContents];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateZoomScale];
    [self centerScrollViewContents];
}

#pragma mark - XYPBScalingImageView

- (instancetype)initWithPhoto:(id<XYPhotoBrowserItem>)photo
{
	self = [super initWithFrame:[UIScreen mainScreen].bounds];
	if (self) {
		self.delegate = self;
		[self setupInternalImageViewWithPhoto:photo];
		[self setupImageScrollView];
		[self updateZoomScale];
	}
	return self;
}

#pragma mark - Setup

- (void)setupInternalImageViewWithPhoto:(id<XYPhotoBrowserItem>)photo
{
	UIImage *imageToUse = [UIImage imageWithData:photo.imageData] ?: (photo.image ?: photo.placeholderImage);

#ifdef ANIMATED_GIF_SUPPORT
    self.imageView = [[FLAnimatedImageView alloc] initWithImage:imageToUse];
	if (photo.imageData) {
		self.imageView.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:photo.imageData];
	}
#else
    self.imageView = [[UIImageView alloc] initWithImage:imageToUse];
#endif
	[self updatePhoto:photo];
    [self addSubview:self.imageView];
}

- (void)updatePhoto:(id<XYPhotoBrowserItem>)photo
{
	_photo = photo;
	
#ifdef DEBUG
#ifndef ANIMATED_GIF_SUPPORT
	if (photo.imageData != nil) {
		NSLog(@"[XYPhotoBrowserViewer] 警告! 当前不支持gif，但是你却提供了imageData来呈现 \nYou're providing imageData for a photo, but XYPhotoBrowserViewer was compiled without animated GIF support.");
	}
#endif // ANIMATED_GIF_SUPPORT
#endif // DEBUG
	
	UIImage *imageToUse = [UIImage imageWithData:photo.imageData] ?: (photo.image ?: photo.placeholderImage);

	// 移除所有的转场效果，恢复到默认
	self.imageView.transform = CGAffineTransformIdentity;
	self.imageView.image = imageToUse;
	
#ifdef ANIMATED_GIF_SUPPORT
	// It's necessarry to first assign the UIImage so calulations for layout go right (see above)
	if (photo.imageData) {
		self.imageView.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:photo.imageData];
	}
#endif
	
	self.imageView.frame = CGRectMake(0, 0, imageToUse.size.width, imageToUse.size.height);
	
	self.contentSize = imageToUse.size;
	
	[self updateZoomScale];
	[self centerScrollViewContents];
}

- (void)setupImageScrollView
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
}

- (void)updateZoomScale
{
#ifdef ANIMATED_GIF_SUPPORT
    if (self.imageView.animatedImage || self.imageView.image) {
#else
    if (self.imageView.image) {
#endif
        CGRect scrollViewFrame = self.bounds;
        
        CGFloat scaleWidth = scrollViewFrame.size.width / self.imageView.image.size.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / self.imageView.image.size.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        
        self.minimumZoomScale = minScale;
        self.maximumZoomScale = MAX(minScale, self.maximumZoomScale);
        
        self.zoomScale = self.minimumZoomScale;
        
        // scrollView.panGestureRecognizer.enabled is on by default and enabled by
        // viewWillLayoutSubviews in the container controller so disable it here
        // to prevent an interference with the container controller's pan gesture.
        //
        // This is enabled in scrollViewWillBeginZooming so panning while zoomed-in
        // is unaffected.
        self.panGestureRecognizer.enabled = NO;
    }
}

#pragma mark - Centering

- (void)centerScrollViewContents
{
    CGFloat horizontalInset = 0;
    CGFloat verticalInset = 0;
    
    if (self.contentSize.width < CGRectGetWidth(self.bounds)) {
        horizontalInset = (CGRectGetWidth(self.bounds) - self.contentSize.width) * 0.5;
    }
    
    if (self.contentSize.height < CGRectGetHeight(self.bounds)) {
        verticalInset = (CGRectGetHeight(self.bounds) - self.contentSize.height) * 0.5;
    }
    
    if (self.window.screen.scale < 2.0) {
        horizontalInset = __tg_floor(horizontalInset);
        verticalInset = __tg_floor(verticalInset);
    }
    
    // Use `contentInset` to center the contents in the scroll view. Reasoning explained here: http://petersteinberger.com/blog/2013/how-to-center-uiscrollview/
    self.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
}

#pragma mark - UIScrollViewDelegate
	
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
	self.panGestureRecognizer.enabled = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
	if (self.zoomScale == self.minimumZoomScale) {
		self.panGestureRecognizer.enabled = NO;
	}
}

@end
