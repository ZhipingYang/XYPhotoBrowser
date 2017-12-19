//
//  CKPBRecommendMoreView.m
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 10/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "CKPBRecommendMoreView.h"
#import "CKPhotoBrowserCategory.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface CKPBRecommendMoreViewButton: UIButton

@property (nonatomic, strong) id<CKPhotoBrowserItem> photo;

+ (instancetype)buttonWithPhoto:(id<CKPhotoBrowserItem>)photo;

@end

@implementation CKPBRecommendMoreViewButton

+ (instancetype)buttonWithPhoto:(id<CKPhotoBrowserItem>)photo
{
	CKPBRecommendMoreViewButton *button = [super buttonWithType:UIButtonTypeCustom];
	button.photo = photo;
	[button setTitle:photo.attributedCaptionTitle.string forState:UIControlStateNormal];
	if (photo.imageData) {
		[button setImage:[UIImage imageWithData:photo.imageData] forState:UIControlStateNormal];
	} else if (photo.image) {
		[button setImage:photo.image forState:UIControlStateNormal];
	} else if (photo.imageUrl) {
		[button sd_setImageWithURL:[NSURL URLWithString:photo.imageUrl] forState:UIControlStateNormal placeholderImage:photo.placeholderImage];
	}
	[button setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:13];
	button.titleLabel.textAlignment = NSTextAlignmentLeft;
	button.titleLabel.numberOfLines = 2;
	button.imageView.contentMode = UIViewContentModeScaleAspectFill;
	return button;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
	return CGRectMake(0, 0, CGRectGetWidth(contentRect), CGRectGetHeight(contentRect)-45);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
	return CGRectMake(8, CGRectGetHeight(contentRect)-45, CGRectGetWidth(contentRect)-8*2, 40);
}

@end

@interface CKPBRecommendMoreView()

@property (nonatomic, strong) NSMutableArray <CKPBRecommendMoreViewButton *> *buttons;

@end

@implementation CKPBRecommendMoreView

- (instancetype)initWithPhotos:(NSArray <id<CKPhotoBrowserItem>>*)photos
{
	self = [super initWithFrame:CGRectZero];
	if (self) {
		_photos = photos;
		[self initButtons];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	return [self initWithPhotos:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	return [self initWithPhotos:nil];
}

- (void)initButtons
{
	_buttons = @[].mutableCopy;
	
	[_photos enumerateObjectsUsingBlock:^(id<CKPhotoBrowserItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		CKPBRecommendMoreViewButton *button = [CKPBRecommendMoreViewButton buttonWithPhoto:obj];
		[button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
		[_buttons addObject:button];
	}];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (_buttons.count<=0) { return; }
	
	CGFloat const edgeH = 2;
	CGFloat const width = (self.ckpb_width-edgeH)/2.0;
	CGFloat const height = self.ckpb_height/((_buttons.count+1)/2);
	[_buttons enumerateObjectsUsingBlock:^(CKPBRecommendMoreViewButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.frame = CGRectMake((idx)%2 * (width+edgeH), height * (idx/2), width, height);
	}];
}

- (void)itemClick:(CKPBRecommendMoreViewButton *)button
{
	if (button.photo && [_delegate respondsToSelector:@selector(moreItemView:didClickOnPhoto:)]) {
		[_delegate moreItemView:button.imageView didClickOnPhoto:button.photo];
	}
}

@end
