//
//  XYPhotoBrowserContainer.h
//  CKWebPhotoViewer
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

@import UIKit;

/**
 遵从协议对象必须是个UIView子类，并实现 sizeThatFits 方法
 */
@protocol XYPhotoBrowserViewResize <NSObject>

- (CGSize)sizeThatFits:(CGSize)size;

@end
