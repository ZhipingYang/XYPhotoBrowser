//
//  PhotoItem.h
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKPhotoBrowserItem.h"

@interface PhotoItem : NSObject <CKPhotoBrowserItem>

@property (nonatomic) CKWebPhotoType type;

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImageData:(NSData *)imageData;

- (instancetype)initWithImageUrl:(NSString *)imageUrl;

- (void)updateImage:(UIImage *)image;
- (void)updateImageData:(NSData *)imageData;

- (void)loadImageIfNeed;

@end
