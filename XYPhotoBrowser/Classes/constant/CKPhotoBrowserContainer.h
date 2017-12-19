//
//  CKPhotoBrowserContainer.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//
//
@import Foundation;
@protocol CKPhotoBrowserItem;

/**
 遵从协议对象必须包含包含一个photo容器
 */
@protocol CKPhotoBrowserContainer <NSObject>

@property (nonatomic, readonly) id <CKPhotoBrowserItem> photo;

@end
