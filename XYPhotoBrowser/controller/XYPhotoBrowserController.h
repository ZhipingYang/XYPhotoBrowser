//
//  XYPhotoBrowserController.h
//  CKWebPhotoViewer
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserViewResize.h"
#import "XYPhotoBrowserContentView.h"

@import UIKit;
@class XYPBControllerOverlayView;

@protocol XYPhotoBrowserItem;
@protocol XYPhotoBrowserControllerDelegate;
@protocol XYPhotoBrowserDataSource;

NS_ASSUME_NONNULL_BEGIN

//通知名字
FOUNDATION_EXPORT const struct XYPhotoBrowserControllerNotification {
	__unsafe_unretained NSString *didNavigateToPhoto; // 跳转到不同的photo
	__unsafe_unretained NSString *willDismiss;	// 即将消失，包括手势消失
	__unsafe_unretained NSString *didDismiss;	// 已经消失
	
} XYPhotoBrowserControllerNotification;


@interface XYPhotoBrowserController : UIViewController

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
@property (nonatomic, readonly, nullable) id <XYPhotoBrowserItem> currentlyDisplayedPhoto;

/**
 viewDidLoad 时创建的视图覆盖物，包含导航栏、标题、输入框等等（输入框需要配置）
 */
@property (nonatomic, readonly, nullable) XYPBControllerOverlayView *overlayView;

@property (nonatomic, nullable) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, copy, nullable) NSArray <UIBarButtonItem *> *leftBarButtonItems;
@property (nonatomic, nullable) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, copy, nullable) NSArray <UIBarButtonItem *> *rightBarButtonItems;

/**
 photo的资源数据来源
 Note：替换数据源时，调用`-reloadPhotosAnimated:`
 */
@property (nonatomic, weak, nullable) id <XYPhotoBrowserDataSource> dataSource;

/**
 photo的代理及相关UI&交互配置
 */
@property (nonatomic, weak, nullable) id <XYPhotoBrowserControllerDelegate> delegate;

/**
 实例方法
 NOTE:默认展示 dataSource 中第一张图片
 */
- (instancetype)initWithDataSource:(id <XYPhotoBrowserDataSource>)dataSource;

/**
 实例方法，初始化 dataSource 的 第（initialPhotoIndex）张照片
 */
- (instancetype)initWithDataSource:(id <XYPhotoBrowserDataSource>)dataSource initialPhotoIndex:(NSInteger)initialPhotoIndex delegate:(nullable id <XYPhotoBrowserControllerDelegate>)delegate;

/**
 指定构造器
 */
- (instancetype)initWithDataSource:(id <XYPhotoBrowserDataSource>)dataSource initialPhoto:(nullable id <XYPhotoBrowserItem>)initialPhoto delegate:(nullable id <XYPhotoBrowserControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
 指定photo展示，如果 photo 不在datasource中则无反应
 @param photo    当前photo对象.
 @param animated 是否动画滚动.
 */
- (void)displayPhoto:(nullable id <XYPhotoBrowserItem>)photo animated:(BOOL)animated;

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
- (void)updatePhoto:(id<XYPhotoBrowserItem>)photo;

/**
 重载datasource资源，或者替换datasource时调用
 */
- (void)reloadPhotosAnimated:(BOOL)animated;

@end


#pragma mark - XYPhotoBrowserControllerDelegate

@protocol XYPhotoBrowserControllerDelegate <NSObject>

@optional

/**
 滑动展示photo时回调
 */
- (void)photosViewController:(XYPhotoBrowserController *)photosViewController didNavigateToPhoto:(id <XYPhotoBrowserItem>)photo atIndex:(NSUInteger)photoIndex;

- (void)photosViewControllerWillDismiss:(XYPhotoBrowserController *)photosViewController;
- (void)photosViewControllerDidDismiss:(XYPhotoBrowserController *)photosViewController;

/**
 不同类型的photo或者不同app可以配置不同的加载view
 默认：UIActivityIndicatorView
 */
- (UIView * _Nullable)photosViewController:(XYPhotoBrowserController *)photosViewController loadingViewForPhoto:(id <XYPhotoBrowserItem>)photo;

/**
 配置照片show & dimiss 时对应的转场 view 动画
 NOTE：可针对photo动态配置，即浏览到某一张照片，则返回某一张照片的承载位置，返回nil则没有回位动画而是向下渐隐消失
 */
- (UIView * _Nullable)photosViewController:(XYPhotoBrowserController *)photosViewController referenceViewForPhoto:(id <XYPhotoBrowserItem>)photo;

/**
 根据photo类型，自定义内容承载的View；不执行或返回nil则默认 `XYPBScalingImageView`
 */
- (UIView<XYPhotoBrowserContentView> * _Nullable)photosViewController:(XYPhotoBrowserController *)photosViewController contentViewForPhoto:(id <XYPhotoBrowserItem>)photo;

#pragma mark - overLayer
/**
 配置当前photo的导航栏title
 当delegate没有添加此方法或者 Return `nil` 则默认展示 title "1 of 4"
 */
- (NSAttributedString * _Nullable)photosViewController:(XYPhotoBrowserController *)photosViewController titleForPhoto:(id <XYPhotoBrowserItem>)photo atIndex:(NSInteger)photoIndex totalPhotoCount:(NSInteger)totalPhotoCount;

/**
 自定义底部功能View，可以导入XYPBDefaultFunctionView，配置功能类似今日头条的输入框、收藏、分享等
 */
- (UIView<XYPhotoBrowserViewResize> * _Nullable)photosViewController:(XYPhotoBrowserController *)photosViewController functionViewForPhoto:(id <XYPhotoBrowserItem>)photo;

/**
 自定义字幕,不需要显示字幕的photo返回 nil 即可, 不载入方法则默认`XYPBDefaultCaptionView`实现
 */
- (UIView<XYPhotoBrowserViewResize> * _Nullable)photosViewController:(XYPhotoBrowserController *)photosViewController captionViewForPhoto:(id <XYPhotoBrowserItem>)photo;

/**
 不同图片的放大倍数，比如自定义界面&广告不放大等等
 */
- (CGFloat)photosViewController:(XYPhotoBrowserController *)photosViewController maximumZoomScaleForPhoto:(id <XYPhotoBrowserItem>)photo;

#pragma mark - gestureRecognizer
/**
 图片长按回调，可以针对photo类型配置长按的交互方式（下载、分享等等）
 NOTE: 不配置或return yes，则默认 UIMenuController 的 copy 图片操作
 */
- (BOOL)photosViewController:(XYPhotoBrowserController *)photosViewController handleLongPressForPhoto:(id <XYPhotoBrowserItem>)photo withGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

/**
 图片单击回调，针对photo类型配置是否允许单击交互（广告单击拦截跳转可以在这里设置）
 NOTE: 不配置或return yes，则单击会显示或隐藏overlayView
 */
- (BOOL)photosViewController:(XYPhotoBrowserController *)photosViewController handleSingleTapForPhoto:(id <XYPhotoBrowserItem>)photo withGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer;

#pragma mark - rightItem
/**
 自定义rightBarItem的默认功能
 NOTE: 不重载方法则系统默认 UIBarButtonSystemItemAction
 */
- (UIBarButtonItem *)photosViewController:(XYPhotoBrowserController *)photosViewController rightBarItemForPhoto:(id <XYPhotoBrowserItem>)photo;

/**
 是否开启导航栏rightBarItem的默认功能
 YES 则 弹出 UIActivityViewController 后续交互添加 photosViewController:actionCompletedWithActivityType
 NO 则用户拦截，便可以自己自定义后续动作
 */
- (BOOL)photosViewController:(XYPhotoBrowserController *)photosViewController handleActionButtonTappedForPhoto:(id <XYPhotoBrowserItem>)photo;

/**
 依赖于 photosViewController:handleActionButtonTappedForPhoto return YES，则 UIActivityViewController show 成功
 分享&保存等功能根据 activityType判断
 */
- (void)photosViewController:(XYPhotoBrowserController *)photosViewController actionCompletedWithActivityType:(NSString * _Nullable)activityType;

@end

NS_ASSUME_NONNULL_END
