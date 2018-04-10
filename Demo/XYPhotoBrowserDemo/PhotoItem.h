//
//  PhotoItem.h
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYPhotoBrowserItem.h"

typedef NS_ENUM(NSInteger, CKWebPhotoType) {
	CKWebPhotoTypeDefault, // 图片类型（包含gif）
	CKWebPhotoTypeAd, // 全屏广告
	CKWebPhotoTypeMore, // 更多阅读
};

NS_ASSUME_NONNULL_BEGIN

@interface PhotoItem : NSObject <XYPhotoBrowserItem>

@property (nonatomic) CKWebPhotoType type;
@property (nonatomic, nullable) NSString *imageUrl;
@property (nonatomic, strong, nullable) NSArray <PhotoItem *> *morePhotos;

- (instancetype)initWithImage:(nullable UIImage *)image;
- (instancetype)initWithImageData:(nullable NSData *)imageData;
- (instancetype)initWithImageUrl:(NSString *)imageUrl;
- (instancetype)initWithPhotos:(nullable NSArray <PhotoItem *> *)photos;

- (void)updateImage:(nullable UIImage *)image;
- (void)updateImageData:(nullable NSData *)imageData;
- (void)updateTitle:(nullable NSString *)title summary:(nullable NSString *)summary credit:(nullable NSString *)credit;

- (void)loadImageIfNeed;

@end

NS_ASSUME_NONNULL_END
