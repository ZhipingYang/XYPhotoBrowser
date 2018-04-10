//
//  PhotoItem.m
//  CLWebImageBrowserDemo
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
	if (_type == CKWebPhotoTypeAd) {
		return YES;
	}
	return _image || _imageData;
}

- (UIImage *)image
{
	if (_image) {
		return _image;
	} else if (self.imageUrl.length>0) {
		[[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:self.imageUrl] completion:^(BOOL isInCache) {
			if (isInCache) {
				[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
					_image = image;
					_imageData = data;
				}];
			}
		}];
	}
	return _image;
}

- (NSData *)imageData
{
	if (_imageData) {
		return _imageData;
	} else if ([self.imageUrl.lowercaseString hasSuffix:@".gif"]) {
		[[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:self.imageUrl] completion:^(BOOL isInCache) {
			if (isInCache) {
				[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
					_image = image;
					_imageData = data;
				}];
			}
		}];
	}
	return _imageData;
}

- (NSArray<id<XYPhotoBrowserItem>> *)morePhotos
{
	NSMutableArray *arr = @[].mutableCopy;
	NSArray *imageUrls = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511351146777&di=12e59a2a96a61038aa464a9e510faf88&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F265%2FP0F100HDE0X4.jpg",
						   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511351187986&di=150e71c728433cde42a50b7acf069a5a&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D170386196%2C2507667277%26fm%3D214%26gp%3D0.jpg",
						   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511351146777&di=fe861208aa1dd0bd484b1ccd4daa6a0c&imgtype=0&src=http%3A%2F%2Fattachments.gfan.com%2Fforum%2Fattachments2%2Fday_120101%2F1201012028ecbe98d8e891c59b.jpg",
						   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511412345966&di=b3410eac11fd4b5065761c791fa56258&imgtype=0&src=http%3A%2F%2Fp0.ifengimg.com%2Fpmop%2F2017%2F0829%2F7AB46C8FC26A3D763BE3755A45D76E83FED98296_size720_w500_h280.gif",
						   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511351146777&di=b058f68f2bc0d5c6cd7487f831b18ae9&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F6%2F53e19df48f87e.jpg",
						   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511343873817&di=4cf241191e662dcad0dc23654d52cc15&imgtype=0&src=http%3A%2F%2Fimg.ycwb.com%2Fnews%2Fattachement%2Fgif%2Fsite2%2F20160921%2F507b9d762551194c19be5f.gif",
						   @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2114763443,721394211&fm=27&gp=0.jpg"];
	
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





