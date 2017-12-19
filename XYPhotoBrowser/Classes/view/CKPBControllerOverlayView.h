//
//  CKPBControllerOverlayView.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "CKPBCaptionView.h"
NS_ASSUME_NONNULL_BEGIN

/**
 `CKPhotoBrowserController` 上层视图显示，包括navBar，navItem、title、cation 和 functionView
 */
@interface CKPBControllerOverlayView : UIView

@property (nonatomic, readonly) UINavigationBar *navigationBar;

@property (nonatomic, copy, nullable) NSString *title;
@property(nonatomic, copy, nullable) NSDictionary <NSString *, id> *titleTextAttributes;

@property (nonatomic, nullable) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, copy, nullable) NSArray <UIBarButtonItem *> *leftBarButtonItems;
@property (nonatomic, nullable) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, copy, nullable) NSArray <UIBarButtonItem *> *rightBarButtonItems;

/**
 字幕文案显示
 */
@property (nonatomic, nullable) CKPBCaptionView *captionView;

/**
 必须要重载sizeThatFits方法
 */
@property (nonatomic, nullable) UIView *funtionView;

@end

NS_ASSUME_NONNULL_END
