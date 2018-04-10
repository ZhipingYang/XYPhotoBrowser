//
//  XYPBDefaultCaptionView.h
//  CKWebPhotoViewer
//
//  Created by XcodeYang on 10/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserViewResize.h"
#import "XYPhotoBrowserItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYPBDefaultCaptionView : UITextView <XYPhotoBrowserViewResize>

@property (nonatomic, readonly, nullable) NSAttributedString *attributedTitle;
@property (nonatomic, readonly, nullable) NSAttributedString *attributedSummary;
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCredit;

/**
 字幕显示，
 如果传入的 title、summary、credit 都是nil或空字段，则返回nil

 @param photo title、summary、credit 信息载体
 @return 字幕组对象
 */
- (nullable instancetype)initWithPhoto:(nullable id<XYPhotoBrowserItem>)photo NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer __attribute__((unavailable("此方法已弃用,请使用 initWithPhoto")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("此方法已弃用,请使用 initWithPhoto")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("此方法已弃用,请使用 initWithPhoto")));
- (instancetype)init __attribute__((unavailable("此方法已弃用,请使用 initWithPhoto")));

@end

NS_ASSUME_NONNULL_END
