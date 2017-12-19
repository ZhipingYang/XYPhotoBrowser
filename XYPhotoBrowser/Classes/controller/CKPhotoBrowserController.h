//
//  CKPhotoBrowserController.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

#import "CKPBRecommendMoreView.h"
@import UIKit;
@class CKPBControllerOverlayView;

@protocol CKPhotoBrowserItem;
@protocol CKPhotoBrowserControllerDelegate;
@protocol CKPhotoBrowserDataSource;

NS_ASSUME_NONNULL_BEGIN

//通知名字
FOUNDATION_EXPORT const struct CKPhotoBrowserControllerNotification {
	__unsafe_unretained NSString *didNavigateToPhoto; // 跳转到不同的photo
	__unsafe_unretained NSString *willDismiss;	// 即将消失，包括手势消失
	__unsafe_unretained NSString *didDismiss;	// 已经消失
	
} CKPhotoBrowserControllerNotification;


@interface CKPhotoBrowserController : UIViewController

/**
 手势下滑消失，可设置enble来关闭
 */
@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;

/**
 单击，显示或关闭图片上的其他信息（overlayView 标题、内容等等），可设置enble来关闭
 NOTE：代理方法 photosViewController:handleSingleTapForPhoto:withGestureRecognizer: 可配置不同的photo交互，比如广告单击做跳转且不隐藏 overlayView
 */
@property (nonatomic, readonly) UITapGestureRecognizer *singleTapGestureRecognizer;

/**
 viewDidLoad 初始化横向滚动视图控制器
 */
@property (nonatomic, readonly, nullable) UIPageViewController *pageViewController;

/**
 当前显示的photo，也是 dataSource 中的某一个
 */
@property (nonatomic, readonly, nullable) id <CKPhotoBrowserItem> currentlyDisplayedPhoto;

/**
 viewDidLoad 时创建的视图覆盖物，包含导航栏、标题、输入框等等（输入框需要配置）
 */
@property (nonatomic, readonly, nullable) CKPBControllerOverlayView *overlayView;

@property (nonatomic, nullable) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, copy, nullable) NSArray <UIBarButtonItem *> *leftBarButtonItems;
@property (nonatomic, nullable) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, copy, nullable) NSArray <UIBarButtonItem *> *rightBarButtonItems;

/**
 photo的资源数据来源
 Note：替换数据源时，调用`-reloadPhotosAnimated:`
 */
@property (nonatomic, weak, nullable) id <CKPhotoBrowserDataSource> dataSource;

/**
 photo的代理及相关UI&交互配置
 */
@property (nonatomic, weak, nullable) id <CKPhotoBrowserControllerDelegate> delegate;

/**
 实例方法
 NOTE:默认展示 dataSource 中第一张图片
 */
- (instancetype)initWithDataSource:(id <CKPhotoBrowserDataSource>)dataSource;

/**
 实例方法，初始化 dataSource 的 第（initialPhotoIndex）张照片
 */
- (instancetype)initWithDataSource:(id <CKPhotoBrowserDataSource>)dataSource initialPhotoIndex:(NSInteger)initialPhotoIndex delegate:(nullable id <CKPhotoBrowserControllerDelegate>)delegate;

/**
 指定构造器
 */
- (instancetype)initWithDataSource:(id <CKPhotoBrowserDataSource>)dataSource initialPhoto:(nullable id <CKPhotoBrowserItem>)initialPhoto delegate:(nullable id <CKPhotoBrowserControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
 指定photo展示，如果 photo 不在datasource中则无反应
 @param photo    当前photo对象.
 @param animated 是否动画滚动.
 */
- (void)displayPhoto:(nullable id <CKPhotoBrowserItem>)photo animated:(BOOL)animated;

/**
 更新 photoIndex 索引下的photo
 比如
 1.下载好图片
 2.更新图片的文案信息等等
 NOTE：超出datasource有效range则无效
 */
- (void)updatePhotoAtIndex:(NSInteger)photoIndex;

/**
 更新 datasource 中指定的photo
 NOTE：超出datasource有效range则无效
 */
- (void)updatePhoto:(id<CKPhotoBrowserItem>)photo;

/**
 重载datasource资源，或者替换datasource时调用
 */
- (void)reloadPhotosAnimated:(BOOL)animated;

@end

@protocol CKPhotoBrowserControllerDelegate <CKPBRecommendMoreViewDelegate>

@optional

/**
 滑动展示photo时回调
 */
- (void)photosViewController:(CKPhotoBrowserController *)photosViewController didNavigateToPhoto:(id <CKPhotoBrowserItem>)photo atIndex:(NSUInteger)photoIndex;

- (void)photosViewControllerWillDismiss:(CKPhotoBrowserController *)photosViewController;
- (void)photosViewControllerDidDismiss:(CKPhotoBrowserController *)photosViewController;

/**
 配置当前photo的导航栏title
 当delegate没有添加此方法或者 Return `nil` 则默认展示 title "1 of 4"
 */
- (NSString * _Nullable)photosViewController:(CKPhotoBrowserController *)photosViewController titleForPhoto:(id <CKPhotoBrowserItem>)photo atIndex:(NSInteger)photoIndex totalPhotoCount:(nullable NSNumber *)totalPhotoCount;

/**
 不同类型的photo或者不同app可以配置不同的加载view
 默认：UIActivityIndicatorView
 */
- (UIView * _Nullable)photosViewController:(CKPhotoBrowserController *)photosViewController loadingViewForPhoto:(id <CKPhotoBrowserItem>)photo;

/**
 配置照片show & dimiss 时对应的转场 view 动画
 NOTE：可针对photo动态配置
 */
- (UIView * _Nullable)photosViewController:(CKPhotoBrowserController *)photosViewController referenceViewForPhoto:(id <CKPhotoBrowserItem>)photo;

/**
 自定义功能View，可以导入CKPBFunctionView，配置功能类似今日头条的输入框、收藏、分享等
 */
- (UIView * _Nullable)photosViewController:(CKPhotoBrowserController *)photosViewController functionViewForPhoto:(id <CKPhotoBrowserItem>)photo;

/**
 不同图片的放大倍数，比如广告（类型是CKWebPhotoTypeAd）不放大
 */
- (CGFloat)photosViewController:(CKPhotoBrowserController *)photosViewController maximumZoomScaleForPhoto:(id <CKPhotoBrowserItem>)photo;

/**
 图片长按回调，可以针对photo类型配置长按的交互方式（下载、分享等等）
 NOTE: 不配置或return yes，则默认 UIMenuController 的 copy 图片操作
 */
- (BOOL)photosViewController:(CKPhotoBrowserController *)photosViewController handleLongPressForPhoto:(id <CKPhotoBrowserItem>)photo withGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

/**
 图片单击回调，针对photo类型配置是否允许单击交互（广告单击拦截跳转可以在这里设置）
 NOTE: 不配置或return yes，则单击会显示或隐藏overlayView
 */
- (BOOL)photosViewController:(CKPhotoBrowserController *)photosViewController handleSingleTapForPhoto:(id <CKPhotoBrowserItem>)photo withGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 是否开启导航栏rightBarItem的默认功能
 YES 则 弹出 UIActivityViewController 后续交互添加 photosViewController:actionCompletedWithActivityType
 NO 用户自定义
 */
- (BOOL)photosViewController:(CKPhotoBrowserController *)photosViewController handleActionButtonTappedForPhoto:(id <CKPhotoBrowserItem>)photo;

/**
 依赖于 photosViewController:handleActionButtonTappedForPhoto return YES，则 UIActivityViewController show 成功
 分享&保存等功能根据 activityType判断
 */
- (void)photosViewController:(CKPhotoBrowserController *)photosViewController actionCompletedWithActivityType:(NSString * _Nullable)activityType;

@end

NS_ASSUME_NONNULL_END
