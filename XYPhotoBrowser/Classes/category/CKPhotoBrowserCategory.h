//
//  CKPhotoBrowserCategory.h
//  CLPhotoBrowser
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView(CKPhotoBrowserCategory)
/**
 *  UIView -> UIImage
 */
- (UIImage *)ckpb_getImageFromView;

@property (nonatomic) CGFloat ckpb_left;
@property (nonatomic) CGFloat ckpb_top;
@property (nonatomic) CGFloat ckpb_right;
@property (nonatomic) CGFloat ckpb_bottom;
@property (nonatomic) CGFloat ckpb_width;
@property (nonatomic) CGFloat ckpb_height;
@property (nonatomic) CGFloat ckpb_centerX;
@property (nonatomic) CGFloat ckpb_centerY;

@end

@interface UIDevice(CKPhotoBrowserCategory)

+ (BOOL)ckpb_isIPhone;
+ (BOOL)ckpb_isIPhoneX;

@end

@interface UIImage (CKPhotoBrowserCategory)

/**
 *  本地 UIImage 获取
 */
+ (nullable instancetype)ckpb_imageWithName:(NSString *)imageName;

+ (UIImage *)ckpb_imageWithColor:(UIColor *)color;

@end


@interface NSBundle(CKPhotoBrowserCategory)
/**
 *  pod库本地bundle文件获取
 */
+ (instancetype)ckpb_photoViewerResourceBundle;

@end


NS_ASSUME_NONNULL_END
