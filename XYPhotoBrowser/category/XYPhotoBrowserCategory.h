//
//  XYPhotoBrowserCategory.h
//  XYPhotoBrowserDemo
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ckph_alphaBlack [UIColor colorWithWhite:0 alpha:0.5]

NS_ASSUME_NONNULL_BEGIN

@interface UIView(XYPhotoBrowserCategory)
/**
 *  UIView -> UIImage
 */
- (UIImage *)xypb_getImageFromView;

@property (nonatomic) CGFloat xypb_left;
@property (nonatomic) CGFloat xypb_top;
@property (nonatomic) CGFloat xypb_right;
@property (nonatomic) CGFloat xypb_bottom;
@property (nonatomic) CGFloat xypb_width;
@property (nonatomic) CGFloat xypb_height;
@property (nonatomic) CGFloat xypb_centerX;
@property (nonatomic) CGFloat xypb_centerY;

@end

@interface UIViewController(XYPhotoBrowserCategory)

+ (UIViewController *)xypb_topViewController;

+ (nullable UINavigationController *)xypb_topNavigationController;

@end

@interface UIDevice(XYPhotoBrowserCategory)

/**
 是否是iPhone，还是iPad
 */
+ (BOOL)xypb_isIPhone;

/**
 是否是iPhoneX
 */
+ (BOOL)xypb_isIPhoneX;

@end

@interface UIImage (XYPhotoBrowserCategory)

/**
 *  本地 UIImage 获取
 */
+ (nullable instancetype)xypb_imageWithName:(NSString *)imageName;

/**
 UIColor 转出一个像素的 UIImage
 */
+ (UIImage *)xypb_imageWithColor:(UIColor *)color;

@end


@interface NSBundle(XYPhotoBrowserCategory)
/**
 *  pod库本地bundle文件获取
 */
+ (instancetype)xypb_photoViewerResourceBundle;

@end


NS_ASSUME_NONNULL_END
