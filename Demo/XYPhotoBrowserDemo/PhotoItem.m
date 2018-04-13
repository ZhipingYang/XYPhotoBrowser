//
//  PhotoItem.m
//  XYImageBrowserDemo
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "PhotoItem.h"
#import <SDWebImageManager.h>
#import <SDWebImage/UIImage+GIF.h>

@interface PhotoItem()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, copy) NSAttributedString *attributedCaptionTitle;
@property (nonatomic, copy) NSAttributedString *attributedCaptionSummary;
@property (nonatomic, copy) NSAttributedString *attributedCaptionCredit;

@end

@implementation PhotoItem

#pragma mark - 构造器

- (instancetype)initWithImage:(UIImage *)image
{
	self = [super init];
	if (self) {
		self.image = image;
		
		self.attributedCaptionTitle = [self getAttributedStringWithString:[self randomStringLength:30] fontSize:16 white:1 lineSpace:6];;
		self.attributedCaptionSummary = [self getAttributedStringWithString:[self randomStringLength:300] fontSize:14 white:0.7 lineSpace:2];
		self.attributedCaptionCredit = [self getAttributedStringWithString:@"Copyright © 2017 Shanghai Eclicks Network CO" fontSize:10 white:0.4 lineSpace:3];;
	}
	return self;
}

- (instancetype)initWithImageData:(NSData *)imageData
{
	self = [super init];
	if (self) {
		self.imageData = imageData;
		
		self.attributedCaptionTitle = [self getAttributedStringWithString:[self randomStringLength:30] fontSize:16 white:1 lineSpace:6];;
		self.attributedCaptionSummary = [self getAttributedStringWithString:[self randomStringLength:300] fontSize:14 white:0.7 lineSpace:2];
		self.attributedCaptionCredit = [self getAttributedStringWithString:@"Copyright © 2017 Shanghai Eclicks Network CO" fontSize:10 white:0.4 lineSpace:3];;
	}
	return self;
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl
{
	self = [super init];
	if (self) {
		self.imageUrl = imageUrl;
		self.attributedCaptionTitle = [self getAttributedStringWithString:[self randomStringLength:30] fontSize:16 white:1 lineSpace:6];;
		self.attributedCaptionSummary = [self getAttributedStringWithString:[self randomStringLength:300] fontSize:14 white:0.7 lineSpace:2];
		self.attributedCaptionCredit = [self getAttributedStringWithString:@"Copyright © 2017 Shanghai Eclicks Network CO" fontSize:10 white:0.4 lineSpace:3];;
	}
	return self;
}

- (instancetype)initWithPhotos:(NSArray <id<XYPhotoBrowserItem>> *)photos
{
	self = [super init];
	if (self) {
		self.type = CKWebPhotoTypeMore;
		self.morePhotos = photos.copy;
	}
	return self;
}

#pragma mark - protocol

- (BOOL)hasData
{
	if (_type != CKWebPhotoTypeDefault) {
		return YES;
	}
	return _image || _imageData;
}

- (UIImage *)image
{
//	if (_image) {
//		return _image;
//	} else if (self.imageUrl.length>0) {
//		[[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:self.imageUrl] completion:^(BOOL isInCache) {
//			if (isInCache) {
//				[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//					self->_image = image;
//					self->_imageData = data;
//				}];
//			}
//		}];
//	}
	return _image;
}

- (NSData *)imageData
{
//	if (_imageData) {
//		return _imageData;
//	} else if ([self.imageUrl.lowercaseString hasSuffix:@".gif"]) {
//		[[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:self.imageUrl] completion:^(BOOL isInCache) {
//			if (isInCache) {
//				[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//					self->_image = image;
//					self->_imageData = data;
//				}];
//			}
//		}];
//	}
	return _imageData;
}

- (NSArray<id<XYPhotoBrowserItem>> *)morePhotos
{
	NSMutableArray *arr = @[].mutableCopy;
	NSArray *imageUrls = @[@"https://user-images.githubusercontent.com/9360037/38593077-2405b334-3d72-11e8-8845-8bc6626ecdc2.gif",
						   @"https://user-images.githubusercontent.com/9360037/38592861-0f0fb584-3d71-11e8-884b-b07510f74ec4.gif",
						   @"https://user-images.githubusercontent.com/9360037/38592860-0eaec3b4-3d71-11e8-9bcf-7496b8ead6e6.gif"];
	
	[imageUrls enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[arr addObject:[[PhotoItem alloc] initWithImageUrl:obj]];
	}];
	return arr;
}

- (UIImage *)placeholderImage
{
	return [UIImage imageNamed:@"image_placeholder"];
}

#pragma mark - public

- (void)unloadUnderlyingImage
{
	if (self.imageUrl) {
		self.imageData = nil;
		self.image = nil;
	}
}

- (void)updateImage:(UIImage *)image
{
	_image = image;
}

- (void)updateImageData:(NSData *)imageData
{
	_imageData = imageData;
}

- (void)updateTitle:(NSString *)title summary:(NSString *)summary credit:(NSString *)credit
{
	_attributedCaptionTitle = [self getAttributedStringWithString:title fontSize:16 white:1 lineSpace:6];
	_attributedCaptionSummary = [self getAttributedStringWithString:summary fontSize:14 white:0.7 lineSpace:2];
	_attributedCaptionCredit = [self getAttributedStringWithString:credit fontSize:10 white:0.4 lineSpace:3];
}

- (void)loadImageIfNeed
{
	if (_imageUrl.length<=0 || _image || _imageData || _type==CKWebPhotoTypeMore) {
		return;
	}
	__weak __typeof(&*self)weakSelf = self;
	[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:_imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
		if ([image isGIF]) {
			weakSelf.imageData = data;
		} else if (image) {
			weakSelf.image = image;
		}
	}];
}

#pragma mark - private

- (NSString *)randomStringLength:(NSInteger)length
{
	return [@"President Donald Trump’s comments last week that the United States should try to attract immigrants from places like Norway instead of “shithole countries” like Haiti or El Salvador weren’t just racist. They also expose his immigration policies to challenge in federal court, and may even allow some of the people he’s trying to deport to stay in the U.S. Here’s why: Trump made the “shithole countries” remark while defending his decision to cancel Temporary Protected Status ― a designation that offers deportation relief and work authorization to people from countries afflicted by natural disasters or war ― for hundreds of thousands of undocumented immigrants from El Salvador, Haiti, Nicaragua and Sudan." substringToIndex:arc4random()%length];
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string fontSize:(float)fontSize white:(float)white lineSpace:(CGFloat)space
{
	if (string.length <= 0) {
		return nil;
	}
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:space];
	
	NSAttributedString *attriStr =  [[NSAttributedString alloc] initWithString:string
																	attributes:@{
																				 NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
																				 NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:white],
																				 NSParagraphStyleAttributeName : paragraphStyle
																				 }];
	return attriStr;
}

@end





