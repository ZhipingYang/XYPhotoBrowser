//
//  PhotoManager.m
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 09/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "PhotoManager.h"
#import "PhotoItem.h"
#import "PhotoDataSource.h"
#import "CKPhotoBrowserController.h"
#import "CKPBFunctionView.h"
#import <UIImage+GIF.h>

@interface PhotoManager()<CKPhotoBrowserControllerDelegate, PhotoDataSourceDelegate, CKPBFunctionViewDelegate>

@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, weak, nullable) UIView *referenceView;
@property (nonatomic, strong) PhotoDataSource *photoDataSource;
@property (nonatomic, strong) CKPhotoBrowserController *photosViewController;
@property (nonatomic, strong) CKPBFunctionView *functionView;

@end

@implementation PhotoManager

+ (instancetype)share
{
	static PhotoManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[self alloc] init];
	});
	return manager;
}

+ (void)showWithNewsId:(NSString *)newsId onReferenceView:(UIView *)referenceView
{
	PhotoManager *manger = [PhotoManager share];
	manger.newsId = newsId;
	manger.referenceView = referenceView;
	manger.functionView = [[CKPBFunctionView alloc] init];
	manger.functionView.commentNumber = 0;
	manger.functionView.starView.selected = NO;
	manger.functionView.delegate = manger;
	
	manger.photoDataSource = [[PhotoDataSource alloc] initWithDelegate:manger newsID:newsId referenceView:referenceView];
	manger.photosViewController = [[CKPhotoBrowserController alloc] initWithDataSource:manger.photoDataSource initialPhoto:[manger.photoDataSource photoAtIndex:0] delegate:manger];
	manger.photosViewController.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:manger action:@selector(dismissPhotosController)];
	manger.photosViewController.delegate = manger;
//	[[UIApplication sharedApplication].topViewController presentViewController:manger.photosViewController animated:YES completion:nil];
}

- (void)dismissPhotosController
{
	[_photosViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(id)contextInfo
{
	[[CKUIManager sharedManager] showMessageHUDInWindow:image ? @"保存成功":(error.localizedDescription ?: @"保存失败")];
}

- (void)sharePhoto:(id<CKPhotoBrowserItem>)photo
{
	NSArray *shareActions = [self getShareActionsWithImage:photo.image ?: [UIImage imageWithData:photo.imageData]];
	NSArray *toolActions = [self getToolActionsWithImage:photo.image ?: [UIImage imageWithData:photo.imageData]];
	CKShareController *controller = [CKShareController shareControllerWithShareActions:shareActions toolActions:toolActions];
	controller.title = @"分享到";
	[[UIApplication sharedApplication].topViewController presentViewController:controller animated:YES completion:nil];
}

- (NSArray <CKShareAction *> *)getShareActionsWithImage:(UIImage *)image
{
	NSMutableArray *shareActions = [NSMutableArray array];
	
	CKShareAction *wexinHyAction = [CKShareAction actionWithType:CKShareActionTypeWXHy handler:^(CKShareAction *action) {
//		[self executeShareAction:action image:image];
	}];
	[shareActions addObject:wexinHyAction];
	
	CKShareAction *wexinPyqAction = [CKShareAction actionWithType:CKShareActionTypeWXPyq handler:^(CKShareAction *action) {
//		[self executeShareAction:action image:image];
	}];
	[shareActions addObject:wexinPyqAction];
	
	CKShareAction *qqAction = [CKShareAction actionWithType:CKShareActionTypeQQ handler:^(CKShareAction *action) {
//		[self executeShareAction:action image:image];
	}];
	[shareActions addObject:qqAction];
	
	CKShareAction *sinaAction = [CKShareAction actionWithType:CKShareActionTypeSina handler:^(CKShareAction *action) {
//		[self executeShareAction:action image:image];
	}];
	[shareActions addObject:sinaAction];
	
	return shareActions;
}

- (NSArray <CKShareAction *> *)getToolActionsWithImage:(UIImage *)image
{
	NSMutableArray *toolActions = [NSMutableArray array];
	
	if (image) {
		CKShareAction *downloadImageAction = [CKShareAction actionWithType:CKShareActionTypeDownloadImage handler:^(CKShareAction *action) {
//			[self executeShareAction:action image:image];
		}];
		[toolActions addObject:downloadImageAction];
	} else {
		CKShareAction *copyLinkAction = [CKShareAction actionWithType:CKShareActionTypeCopyLink handler:^(CKShareAction *action) {
//			[self executeShareAction:action image:image];
		}];
		[toolActions addObject:copyLinkAction];
	}
	
	return toolActions;
}


#pragma mark - CKPhotoBrowserControllerDelegate

- (void)photosViewController:(CKPhotoBrowserController *)photosViewController didNavigateToPhoto:(id <CKPhotoBrowserItem>)photo atIndex:(NSUInteger)photoIndex
{
	if (![NSObject checkIsEmpty:photo.imageUrl] && photo.imageData==nil && photo.image==nil) {
		[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:photo.imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
			if ([image isGIF]) {
				[(PhotoItem *)photo updateImageData:data];
			} else if (image) {
				[(PhotoItem *)photo updateImage:image];
			}
			[photosViewController updatePhotoAtIndex:photoIndex];
		}];
	} else {
		[photosViewController updatePhotoAtIndex:photoIndex];
	}
}

- (UIView *)photosViewController:(CKPhotoBrowserController *)photosViewController referenceViewForPhoto:(id<CKPhotoBrowserItem>)photo
{
	return _referenceView;
}

- (NSString *)photosViewController:(CKPhotoBrowserController *)photosViewController titleForPhoto:(id<CKPhotoBrowserItem>)photo atIndex:(NSInteger)photoIndex totalPhotoCount:(NSNumber *)totalPhotoCount
{
	PhotoItem *item = photo;
	switch (item.type) {
		case CKWebPhotoTypeAd:
			return @"广告";
		case CKWebPhotoTypeMore:
			return @"更多资讯推荐";
		default: {
			__block NSInteger sum = self.photoDataSource.numberOfPhotos.integerValue;
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
			return [NSString stringWithFormat:@"%zd / %zd",index,sum];
		}
	}
}

- (CGFloat)photosViewController:(CKPhotoBrowserController *)photosViewController maximumZoomScaleForPhoto:(id <CKPhotoBrowserItem>)photo
{
	return 2;
}

- (UIView *)photosViewController:(CKPhotoBrowserController *)photosViewController functionViewForPhoto:(id<CKPhotoBrowserItem>)photo
{
	return photo.type == CKWebPhotoTypeDefault ? _functionView : nil;
}

- (BOOL)photosViewController:(CKPhotoBrowserController *)photosViewController handleLongPressForPhoto:(id <CKPhotoBrowserItem>)photo withGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
	if (photo.type == CKWebPhotoTypeDefault && (photo.image || photo.imageData)) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:photo.attributedCaptionTitle.string message:photo.attributedCaptionSummary.string preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
		[alert addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			UIImageWriteToSavedPhotosAlbum(photo.image ?: [UIImage imageWithData:photo.imageData], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
		}]];
		[alert addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[self sharePhoto:photo];
		}]];
		[[UIApplication sharedApplication].topViewController presentViewController:alert animated:YES completion:nil];
	}
	
	return YES;
}

- (BOOL)photosViewController:(CKPhotoBrowserController *)photosViewController handleSingleTapForPhoto:(id<CKPhotoBrowserItem>)photo withGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
	if (photo.type == CKWebPhotoTypeAd) {
		CKViewController *vc = [CKViewController new];
		vc.title = @"这是一个广告页面";
		vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:vc action:@selector(backAction)];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
		[[UIApplication sharedApplication].topViewController presentViewController:nav animated:YES completion:nil];
	}
	return photo.type == CKWebPhotoTypeDefault;
}

- (void)photosViewController:(CKPhotoBrowserController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType
{
	if ([activityType isEqualToString:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
		[[CKUIManager sharedManager] showSuccessHUDHintInWindow:@"保存成功"];
	}
}

#pragma mark - CKPBRecommendMoreViewDelegate

- (void)moreItemView:(UIImageView *)view didClickOnPhoto:(id<CKPhotoBrowserItem>)photo
{
	[_photoDataSource updateDataWithPhotoItem:(PhotoItem *)photo];
}

#pragma mark - PhotoDataSourceDelegate

- (void)photoDataSourceStartLoading
{
	[[CKUIManager sharedManager] showLoadingHUDMessageInWindow:@""];
}

- (void)photoDataSourceLoadingSuccess:(BOOL)sucess
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[[CKUIManager sharedManager] stopLoadingHUD];
	});
	if (sucess) {
		[_photosViewController reloadPhotosAnimated:NO];
	}
}

#pragma mark - CKPBFunctionViewDelegate

- (void)functionView:(CKPBFunctionView *)view inputViewDidClick:(UITextField *)inputView
{
	
}

- (void)functionView:(CKPBFunctionView *)view commentViewDidClick:(UIButton *)commentView
{
	CKViewController *vc = [CKViewController new];
	vc.title = @"评论列表";
	vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:vc action:@selector(backAction)];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[[UIApplication sharedApplication].topViewController presentViewController:nav animated:YES completion:nil];
}

- (void)functionView:(CKPBFunctionView *)view starViewDidClick:(UIButton *)starView
{
	starView.selected = !starView.selected;
}

- (void)functionView:(CKPBFunctionView *)view shareViewDidClick:(UIButton *)shareView
{
	[self sharePhoto:_photosViewController.currentlyDisplayedPhoto];
}


@end
