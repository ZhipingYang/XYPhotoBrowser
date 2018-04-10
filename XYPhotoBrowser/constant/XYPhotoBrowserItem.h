//
//  XYPhotoBrowserItem.h
//  CKWebPhotoViewer
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

@import UIKit;

#if __has_include(<FLAnimatedImage/FLAnimatedImage.h>) || __has_include("FLAnimatedImage.h")
#define ANIMATED_GIF_SUPPORT
#endif

NS_ASSUME_NONNULL_BEGIN

@protocol XYPhotoBrowserItem <NSObject>

/**
 判断是否有数据, 即是否已加载完数据 (涉及到loadingView的展示)
 NOTE: 通常情况下 `return image!=nil || imageData!=nil`
 */
@property (nonatomic, readonly) BOOL hasData;

/**
 正常显示图片
 */
@property (nonatomic, readonly, nullable) UIImage *image;

/**
 gif 图片
 */
@property (nonatomic, readonly, nullable) NSData *imageData;

/**
 占位图
 */
@property (nonatomic, readonly, nullable) UIImage *placeholderImage;

#pragma mark - Caption

/**
 字母标题
 */
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCaptionTitle;

/**
 字幕内容
 */
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCaptionSummary;

/**
 落款
 */
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCaptionCredit;

@optional
/**
 内存释放，可在内存警告时 或 不展示的时候调用
 NOTE: photo对象有资源引用路径比如 PHAsset，NSURL，filePath 时，可及时清理 image & imageData
 */
- (void)unloadUnderlyingImage;

@end

NS_ASSUME_NONNULL_END
