//
//  XYPBControllerOverlayView.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "XYPhotoBrowserViewResize.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `XYPhotoBrowserController` 上层视图显示，包括navBar，navItem、title、cation 和 functionView
 */
@interface XYPBControllerOverlayView : UIView

@property (nonatomic, readonly) UINavigationBar *navigationBar;

@property (nonatomic, copy, nullable) NSAttributedString *title;

@property (nonatomic, nullable) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, copy, nullable) NSArray <UIBarButtonItem *> *leftBarButtonItems;
@property (nonatomic, nullable) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, copy, nullable) NSArray <UIBarButtonItem *> *rightBarButtonItems;

/**
 字幕文案显示
 */
@property (nonatomic, strong, nullable) UIView <XYPhotoBrowserViewResize> *captionView;

/**
 必须要重载sizeThatFits方法
 */
@property (nonatomic, strong, nullable) UIView <XYPhotoBrowserViewResize> *funtionView;

@end

NS_ASSUME_NONNULL_END
