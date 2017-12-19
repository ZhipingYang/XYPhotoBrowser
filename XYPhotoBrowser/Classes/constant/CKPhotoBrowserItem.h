//
//  CKPhotoBrowserItem.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;

#define ANIMATED_GIF_SUPPORT

typedef NS_ENUM(NSInteger, CKWebPhotoType) {
	CKWebPhotoTypeDefault, // 图片类型（包含gif）
	CKWebPhotoTypeAd, // 全屏广告
	CKWebPhotoTypeMore, // 更多阅读
};

NS_ASSUME_NONNULL_BEGIN

@protocol CKPhotoBrowserItem <NSObject>

@property (nonatomic, readonly) CKWebPhotoType type;

@property (nonatomic, readonly, nullable) NSString *imageUrl;

@property (nonatomic, readonly, nullable) UIImage *image;
@property (nonatomic, readonly, nullable) NSData *imageData;
@property (nonatomic, readonly, nullable) UIImage *placeholderImage;

#pragma mark Caption
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCaptionTitle;
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCaptionSummary;
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCaptionCredit;

@property (nonatomic, readonly, nullable) NSArray <id<CKPhotoBrowserItem>> *morePhotos;

- (void)unloadUnderlyingImage;

@end

NS_ASSUME_NONNULL_END
