//
//  XYPhotoBrowserContainer.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//
//
@import Foundation;
@protocol XYPhotoBrowserItem;

/**
 遵从协议对象必须包含包含一个photo容器
 */
@protocol XYPhotoBrowserContainer <NSObject>

@required
@property (nonatomic, readonly) id <XYPhotoBrowserItem> photo;

@end
