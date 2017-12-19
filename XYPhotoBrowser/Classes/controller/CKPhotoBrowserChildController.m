//
//  CKPhotoBrowserChildController.m
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//
//

#import "CKPhotoBrowserChildController.h"
#import "CKPhotoBrowserItem.h"
#import "CKPBScalingImageView.h"
#import "CKPBRecommendMoreView.h"
#import "CKPhotoBrowserCategory.h"
#ifdef ANIMATED_GIF_SUPPORT
#import <FLAnimatedImage/FLAnimatedImage.h>
#endif
#import <SDWebImage/UIImage+GIF.h>

NSString * const CKPhotoBrowserChildControllerPhotoImageUpdatedNotification = @"CKPhotoBrowserChildControllerPhotoImageUpdatedNotification";

@interface CKPhotoBrowserChildController () <UIScrollViewDelegate>

@property (nonatomic) id <CKPhotoBrowserItem> photo;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@property (nonatomic) CKPBScalingImageView *scalingImageView;
@property (nonatomic) UIView *loadingView;
@property (nonatomic) NSNotificationCenter *notificationCenter;
@property (nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, strong) CKPBRecommendMoreView *moreView;

@end

@implementation CKPhotoBrowserChildController

#pragma mark - NSObject

- (void)dealloc {
    _scalingImageView.delegate = nil;
    [_notificationCenter removeObserver:self];
}

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithPhoto:nil loadingView:nil notificationCenter:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitWithPhoto:nil loadingView:nil notificationCenter:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (_photo.type != CKWebPhotoTypeMore) {
		self.scalingImageView.frame = self.view.bounds;
		[self.view addSubview:self.scalingImageView];
		
		[self.view addSubview:self.loadingView];
		[self.loadingView sizeToFit];
		
		[self.view addGestureRecognizer:self.doubleTapGestureRecognizer];
		[self.view addGestureRecognizer:self.longPressGestureRecognizer];
	} else {
		[self.view addSubview:self.moreView];
	}
    [self.notificationCenter addObserver:self selector:@selector(photoImageUpdatedWithNotification:) name:CKPhotoBrowserChildControllerPhotoImageUpdatedNotification object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
	
	if (_photo.type != CKWebPhotoTypeMore) {
		self.scalingImageView.frame = self.view.bounds;
		[self.loadingView sizeToFit];
		self.loadingView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	} else {
		_moreView.frame = CGRectMake(0, (self.view.ckpb_height-300)/2.0, self.view.ckpb_width, 300);
	}
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)setDelegate:(id<CKPhotoBrowserChildControllerDelegate>)delegate
{
	_delegate = delegate;
	_moreView.delegate = _delegate;
}

#pragma mark - CKPhotoBrowserChildController

- (instancetype)initWithPhoto:(id <CKPhotoBrowserItem>)photo loadingView:(UIView *)loadingView notificationCenter:(NSNotificationCenter *)notificationCenter {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
		if (photo.type != CKWebPhotoTypeMore) {
			[self commonInitWithPhoto:photo loadingView:loadingView notificationCenter:notificationCenter];
		} else {
			[self commonInitMorePhoto:photo];
		}
    }
    return self;
}

- (void)commonInitWithPhoto:(id <CKPhotoBrowserItem>)photo loadingView:(UIView *)loadingView notificationCenter:(NSNotificationCenter *)notificationCenter {
    _photo = photo;
	
	if (photo.imageData) {
		_scalingImageView = [[CKPBScalingImageView alloc] initWithImageData:photo.imageData frame:CGRectZero];
	} else {
		UIImage *photoImage = photo.image ?: photo.placeholderImage;
		_scalingImageView = [[CKPBScalingImageView alloc] initWithImage:photoImage frame:CGRectZero];
		
		if (!photo.image) {
			[self setupLoadingView:loadingView];
		}
	}
	_scalingImageView.delegate = self;
	_notificationCenter = notificationCenter;
	[self setupGestureRecognizers];
}

- (void)commonInitMorePhoto:(id <CKPhotoBrowserItem>)photo
{
	_photo = photo;
	NSArray *array = photo.morePhotos.count>4 ? [photo.morePhotos subarrayWithRange:NSMakeRange(0, 4)] : photo.morePhotos;
	_moreView = [[CKPBRecommendMoreView alloc] initWithPhotos:array];
	_moreView.delegate = _delegate;
}

- (void)setupLoadingView:(UIView *)loadingView {
    self.loadingView = loadingView;
    if (!loadingView) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicator startAnimating];
        self.loadingView = activityIndicator;
    }
}

- (void)photoImageUpdatedWithNotification:(NSNotification *)notification {
    id <CKPhotoBrowserItem> photo = notification.object;
    if ([photo conformsToProtocol:@protocol(CKPhotoBrowserItem)] && [photo isEqual:self.photo]) {
        [self updateImage:photo.image imageData:photo.imageData];
    }
}

- (void)updateImage:(UIImage *)image imageData:(NSData *)imageData {
    if (imageData) {
        [self.scalingImageView updateImageData:imageData];
    } else {
        [self.scalingImageView updateImage:image];
    }
    
    if (imageData || image) {
        [self.loadingView removeFromSuperview];
    } else {
        [self.view addSubview:self.loadingView];
    }
}

#pragma mark - Gesture Recognizers

- (void)setupGestureRecognizers {
    self.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapWithGestureRecognizer:)];
    self.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressWithGestureRecognizer:)];
	if (_photo.type != CKWebPhotoTypeDefault) {
		self.longPressGestureRecognizer.enabled = NO;
		self.doubleTapGestureRecognizer.enabled = NO;
	}
}

- (void)didDoubleTapWithGestureRecognizer:(UITapGestureRecognizer *)recognizer {
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

- (void)didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(photoViewController:didLongPressWithGestureRecognizer:)]) {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            [self.delegate photoViewController:self didLongPressWithGestureRecognizer:recognizer];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.scalingImageView.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.panGestureRecognizer.enabled = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scrollView.zoomScale == scrollView.minimumZoomScale) {
        scrollView.panGestureRecognizer.enabled = NO;
    }
}

@end
