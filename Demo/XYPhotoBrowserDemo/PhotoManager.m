//
//  PhotoManager.m
//  XYImageBrowserDemo
//
//  Created by XcodeYang on 09/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "PhotoManager.h"
#import "PhotoItem.h"
#import "PhotoDataSource.h"
#import "XYPhotoBrowser.h"
#import "XYPBRecommendMoreView.h"
#import "CustomView.h"

#import <UIImage+GIF.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import <UUKeyboardInputView.h>
#import <MBProgressHUD/MBProgressHUD.h>
//#import <FLAnimatedImageView+WebCache.h>
#import <SDWebImageCodersManager.h>
#import <SDWebImageGIFCoder.h>

@interface PhotoManager()<XYPhotoBrowserControllerDelegate, PhotoDataSourceDelegate, XYPBDefaultFunctionViewDelegate, XYPBRecommendMoreViewDelegate>

@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, weak, nullable) UIView *referenceView;
@property (nonatomic, strong) PhotoDataSource *photoDataSource;
@property (nonatomic, strong) XYPhotoBrowserController *photosViewController;
@property (nonatomic, strong) XYPBDefaultFunctionView *functionView;

@end

@implementation PhotoManager

+ (instancetype)share
{
	static PhotoManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[self alloc] init];
		[[SDWebImageCodersManager sharedInstance] addCoder:[SDWebImageGIFCoder sharedCoder]];
	});
	return manager;
}

+ (void)showWithNewsId:(NSString *)newsId onReferenceView:(UIView *)referenceView
{
	PhotoManager *manger = [PhotoManager share];
	manger.newsId = newsId;
	manger.referenceView = referenceView;
	
	XYPBDefaultFunctionView *functionView = [[XYPBDefaultFunctionView alloc] init];
	functionView.commentNumber = 0;
	functionView.starView.selected = NO;
	functionView.delegate = manger;
	manger.functionView = functionView;
	
	manger.photoDataSource = [[PhotoDataSource alloc] initWithDelegate:manger newsID:newsId referenceView:referenceView];
	
	XYPhotoBrowserController *photosViewController = [[XYPhotoBrowserController alloc] initWithDataSource:manger.photoDataSource initialPhoto:[manger.photoDataSource photoAtIndex:0] delegate:manger];
	photosViewController.delegate = manger;
	[[UIViewController xypb_topViewController] presentViewController:photosViewController animated:YES completion:nil];
	manger.photosViewController = photosViewController;
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(id)contextInfo
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
	hud.label.text = !error ? @"保存成功":(error.localizedDescription ?: @"保存失败");
	[hud hideAnimated:YES afterDelay:1];
}

#pragma mark - XYPhotoBrowserControllerDelegate

- (void)photosViewController:(XYPhotoBrowserController *)photosViewController didNavigateToPhotoPage:(nonnull XYPhotoBrowserChildController *)photoPage atIndex:(NSUInteger)photoIndex
{
	[(PhotoItem *)[_photoDataSource photoAtIndex:photoIndex+1] loadImageIfNeed];
	[(PhotoItem *)[_photoDataSource photoAtIndex:photoIndex-1] loadImageIfNeed];
	PhotoItem *photoItem = photoPage.photo;
	
	if (photoItem.type == CKWebPhotoTypeDefault && (!photoItem.image && !photoItem.imageData)) {
//		[photoPage.scalingImageView.imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.imageUrl] placeholderImage:photoItem.placeholderImage];
		photoPage.scalingImageView.imageView.sd_imageTransition = SDWebImageTransition.fadeTransition;
//		[photoPage.scalingImageView.imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.imageUrl] placeholderImage:photoItem.placeholderImage];
		[photoPage.scalingImageView.imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.imageUrl] placeholderImage:photoItem.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
			[photosViewController updatePhotoAtIndex:photoIndex];
		}];
	}
}

- (UIView *)photosViewController:(XYPhotoBrowserController *)photosViewController referenceViewForPhoto:(id<XYPhotoBrowserItem>)photo
{
	return _referenceView;
}

- (NSAttributedString *)photosViewController:(XYPhotoBrowserController *)photosViewController titleForPhoto:(id<XYPhotoBrowserItem>)photo atIndex:(NSInteger)photoIndex totalPhotoCount:(NSInteger)totalPhotoCount
{
	NSMutableAttributedString *(^creatAttributedStringBlock)(NSString *str, CGFloat fontSize, UIColor *textColor) = ^(NSString *str, CGFloat fontSize, UIColor *textColor) {
		return [[NSMutableAttributedString alloc] initWithString:str
													  attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName : textColor }];
	};
	
	PhotoItem *item = photo;
	switch (item.type) {
		case CKWebPhotoTypeAd:
			return creatAttributedStringBlock(@"- 广告 -", 14, [UIColor whiteColor]);
		case CKWebPhotoTypeMore:
			return creatAttributedStringBlock(@"更多资讯推荐", 16, [UIColor whiteColor]);
		default: {
			__block NSInteger sum = totalPhotoCount;
			__block NSInteger index = 0;
			__block BOOL hasFoundIndex = NO;
			[self.photoDataSource.items enumerateObjectsUsingBlock:^(PhotoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				if (obj.type != CKWebPhotoTypeDefault) {
					sum -= 1;
				} else if (obj != photo && !hasFoundIndex) {
					index += 1;
				} else if (obj == photo && !hasFoundIndex) {
					index += 1;
					hasFoundIndex = YES;
				}
			}];
			NSMutableAttributedString *title = creatAttributedStringBlock([NSString stringWithFormat:@"%zd ",index], 18, [UIColor whiteColor]);
			[title appendAttributedString:creatAttributedStringBlock([NSString stringWithFormat:@"/ %zd",sum], 12, [UIColor colorWithWhite:1 alpha:0.8])];
			return title;
		}
	}
}

- (CGFloat)photosViewController:(XYPhotoBrowserController *)photosViewController maximumZoomScaleForPhoto:(id <XYPhotoBrowserItem>)photo
{
	if ([(PhotoItem *)photo type] == CKWebPhotoTypeDefault) {
		return 2;
	}
	return 0;
}

- (UIView *)photosViewController:(XYPhotoBrowserController *)photosViewController functionViewForPhoto:(id<XYPhotoBrowserItem>)photo
{
	return [(PhotoItem *)photo type] == CKWebPhotoTypeDefault ? _functionView : nil;
}

- (UIView<XYPhotoBrowserContentView> *)photosViewController:(XYPhotoBrowserController *)photosViewController contentViewForPhoto:(id<XYPhotoBrowserItem>)photo
{
	if ([(PhotoItem *)photo type] == CKWebPhotoTypeMore) {
		XYPBRecommendMoreView *moreView = [[XYPBRecommendMoreView alloc] initWithPhoto:photo];
		moreView.delegate = self;
		return moreView;
	}
	else if ([(PhotoItem *)photo type] == CKWebPhotoTypeAd) {
		CustomView *view = [[CustomView alloc] initWithPhoto:photo];
		__weak typeof(photosViewController) weakVC = photosViewController;
		view.moreViewClickBlock = ^{
			NSInteger index = [weakVC.dataSource indexOfPhoto:photo];
			id<XYPhotoBrowserItem> nextPhoto = [weakVC.dataSource photoAtIndex:++index];
			if (nextPhoto) {
				[photosViewController displayPhoto:nextPhoto animated:YES];
			}
		};
		return view;
	}
	
	return nil;
}

- (UIView *)photosViewController:(XYPhotoBrowserController *)photosViewController captionViewForPhoto:(id<XYPhotoBrowserItem>)photo
{
	if ([(PhotoItem *)photo type] != CKWebPhotoTypeDefault) {
		return nil;
	}
	return [[XYPBDefaultCaptionView alloc] initWithPhoto:photo];
}

- (BOOL)photosViewController:(XYPhotoBrowserController *)photosViewController handleLongPressForPhoto:(id <XYPhotoBrowserItem>)photo withGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
	if ([(PhotoItem *)photo type] == CKWebPhotoTypeDefault && (photo.image || photo.imageData)) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:photo.attributedCaptionTitle.string message:photo.attributedCaptionSummary.string preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
		[alert addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:nil]];
		[alert addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			UIImageWriteToSavedPhotosAlbum(photo.image ?: [UIImage imageWithData:photo.imageData], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
		}]];
		[[UIViewController xypb_topViewController] presentViewController:alert animated:YES completion:nil];
	}
	
	return YES;
}

- (BOOL)photosViewController:(XYPhotoBrowserController *)photosViewController handleSingleTapForPhoto:(id<XYPhotoBrowserItem>)photo withGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
	if ([(PhotoItem *)photo type] == CKWebPhotoTypeAd) {
		UIViewController *vc = [UIViewController new];
		vc.title = @"这是一个广告页面";
		vc.view.backgroundColor = [UIColor whiteColor];
		vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:vc action:@selector(dismissModalViewControllerAnimated:)];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
		[[UIViewController xypb_topViewController] presentViewController:nav animated:YES completion:nil];
	}
	return [(PhotoItem *)photo type] == CKWebPhotoTypeDefault;
}

- (UIBarButtonItem *)photosViewController:(XYPhotoBrowserController *)photosViewController rightBarItemForPhoto:(id<XYPhotoBrowserItem>)photo
{
	if ([(PhotoItem *)photo type] == CKWebPhotoTypeDefault) {
		return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
	}
	return nil;
}

- (void)photosViewController:(XYPhotoBrowserController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType
{
	if ([activityType isEqualToString:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
		hud.label.text = @"保存成功";
		[hud hideAnimated:YES afterDelay:0.6];
	}
}

#pragma mark - XYPBRecommendMoreViewDelegate

- (void)moreItemView:(UIImageView *)view didClickOnPhoto:(id<XYPhotoBrowserItem>)photo
{
	[_photoDataSource updateDataWithPhotoItem:(PhotoItem *)photo];
}

#pragma mark - PhotoDataSourceDelegate

- (void)photoDataSourceStartLoading
{
	[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
}

- (void)photoDataSourceLoadingSuccess:(BOOL)sucess
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
	});
	if (sucess) {
		[_photosViewController reloadPhotosAnimated:NO];
	}
}

#pragma mark - XYPBDefaultFunctionViewDelegate

- (void)functionView:(XYPBDefaultFunctionView *)view inputViewDidClick:(UITextField *)inputView
{
	[UUKeyboardInputView showBlock:^(NSString * _Nullable contentStr) {
		//
	}];
}

- (void)functionView:(XYPBDefaultFunctionView *)view commentViewDidClick:(UIButton *)commentView
{
	UIViewController *vc = [UIViewController new];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	vc.title = @"评论列表";
	vc.view.backgroundColor = [UIColor purpleColor];
	vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nav action:@selector(dismissModalViewControllerAnimated:)];
	[self.photosViewController presentViewController:nav animated:YES completion:nil];
}

- (void)functionView:(XYPBDefaultFunctionView *)view starViewDidClick:(UIButton *)starView
{
	starView.selected = !starView.selected;
}

- (void)functionView:(XYPBDefaultFunctionView *)view shareViewDidClick:(UIButton *)shareView
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享" message:@"分享xxx" preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"cacnel" style:UIAlertActionStyleCancel handler:nil]];
	[self.photosViewController presentViewController:alert animated:YES completion:nil];
}

@end
