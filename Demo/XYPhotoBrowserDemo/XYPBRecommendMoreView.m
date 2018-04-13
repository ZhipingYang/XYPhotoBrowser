//
//  XYPBRecommendMoreView.m
//  XYImageBrowserDemo
//
//  Created by XcodeYang on 10/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPBRecommendMoreView.h"
#import "XYPhotoBrowserCategory.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface XYPBRecommendMoreViewButton: UIButton

@property (nonatomic, strong) id<XYPhotoBrowserItem> photo;

+ (instancetype)buttonWithPhoto:(id<XYPhotoBrowserItem>)photo;

@end

@implementation XYPBRecommendMoreViewButton

+ (instancetype)buttonWithPhoto:(PhotoItem *)photo
{
	XYPBRecommendMoreViewButton *button = [super buttonWithType:UIButtonTypeCustom];
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
	button.titleLabel.numberOfLines = 1;
	button.imageView.contentMode = UIViewContentModeScaleAspectFill;
	return button;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
	return CGRectMake(0, 0, CGRectGetWidth(contentRect), CGRectGetHeight(contentRect)-25);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
	return CGRectMake(8, CGRectGetHeight(contentRect)-25, CGRectGetWidth(contentRect)-8*2, 20);
}

@end


@interface XYPBRecommendMoreView()
{
	UIView *_contentView;
}
@property (nonatomic, strong) PhotoItem *photo;
@property (nonatomic, strong) NSMutableArray <XYPBRecommendMoreViewButton *> *buttons;

@end

@implementation XYPBRecommendMoreView

- (id)initWithPhoto:(id<XYPhotoBrowserItem>)photo
{
	self = [super initWithFrame:CGRectZero];
	if (self) {
		_photo = photo;
		
		_contentView = [UIView new];
		[self addSubview:_contentView];
		
		[self initButtons];
	}
	return self;
}

- (void)updatePhoto:(id<XYPhotoBrowserItem>)photo
{
	_photo = photo;
	[_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self initButtons];
	[self setNeedsLayout];
}

- (void)initButtons
{
	_buttons = @[].mutableCopy;
	NSArray <id<XYPhotoBrowserItem>>* array = _photo.morePhotos;
	if (array.count>6) {
		array = [array subarrayWithRange:NSMakeRange(0, 6)];
	}
	[array enumerateObjectsUsingBlock:^(id<XYPhotoBrowserItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		XYPBRecommendMoreViewButton *button = [XYPBRecommendMoreViewButton buttonWithPhoto:obj];
		[button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
		[self->_contentView addSubview:button];
		[self->_buttons addObject:button];
	}];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (_buttons.count<=0) { return; }
	
	_contentView.frame = CGRectMake(8, (self.xypb_height-400)/2.0, self.xypb_width-8*2, 400);
	
	CGFloat const edgeH = 2;
	CGFloat const btnWidth = (_contentView.xypb_width-edgeH)/2.0;
	CGFloat const btnHeight = _contentView.xypb_height/((_buttons.count+1)/2);
	[_buttons enumerateObjectsUsingBlock:^(XYPBRecommendMoreViewButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.frame = CGRectMake((idx)%2 * (btnWidth+edgeH), btnHeight * (idx/2), btnWidth, btnHeight);
	}];
}

- (void)itemClick:(XYPBRecommendMoreViewButton *)button
{
	if (button.photo && [_delegate respondsToSelector:@selector(moreItemView:didClickOnPhoto:)]) {
		[_delegate moreItemView:button.imageView didClickOnPhoto:button.photo];
	}
}

@end
