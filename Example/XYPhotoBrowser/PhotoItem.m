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

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, copy) NSAttributedString *attributedCaptionTitle;
@property (nonatomic, copy) NSAttributedString *attributedCaptionSummary;
@property (nonatomic, copy) NSAttributedString *attributedCaptionCredit;

@end

@implementation PhotoItem

- (instancetype)initWithImage:(UIImage *)image
{
	self = [super init];
	if (self) {
		self.image = image;
		
		self.attributedCaptionTitle = [self getRandomFontSize:17 white:1 length:10 lineSpace:8];
		self.attributedCaptionSummary = [self getRandomFontSize:15 white:0.7 length:50 lineSpace:8];
		self.attributedCaptionCredit = [self getRandomFontSize:10 white:0.4 length:10 lineSpace:3];
	}
	return self;
}

- (instancetype)initWithImageData:(NSData *)imageData
{
	self = [super init];
	if (self) {
		self.imageData = imageData;
		
		self.attributedCaptionTitle = [self getRandomFontSize:17 white:1 length:10 lineSpace:8];
		self.attributedCaptionSummary = [self getRandomFontSize:15 white:0.7 length:50 lineSpace:8];
		self.attributedCaptionCredit = [self getRandomFontSize:10 white:0.4 length:10 lineSpace:3];
	}
	return self;
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl
{
	self = [super init];
	if (self) {
		self.imageUrl = imageUrl;
		
		self.attributedCaptionTitle = [self getRandomFontSize:17 white:1 length:10 lineSpace:8];
		self.attributedCaptionSummary = [self getRandomFontSize:15 white:0.7 length:50 lineSpace:8];
		self.attributedCaptionCredit = [self getRandomFontSize:10 white:0.4 length:10 lineSpace:3];
	}
	return self;
}

- (NSAttributedString *)getRandomFontSize:(float)fontSize white:(float)white length:(int)length lineSpace:(CGFloat)space
{
	NSString *str = [@"最近一位女司机因为人生路不熟走错路。随后掏出手机导航，因为低头看手机没有看前路导致车子冲下河。在车子慢慢下沉的过程当中，女司机及时拨打电话给交警和保险公司。最后就开始自救。救援时，救援人员对于她的自救行为表示佩服，同时也问她当时是怎么做的？因为救援人员遇到很多司机开车落水后，首先是慌张一段时间正是这段时间里，车子已经渐渐下沉了不少，此时车门受阻，难以开启。除非力量很大的男司机，否则后果堪忧。而这位女司机的做法很简单首先，里面爬过去后排座椅，因此车厢内是密封的，进水比较慢。情节模拟而且车头比较重，先是车头沉下河，而车尾则比较轻，同时车尾也翘起来，提供了逃生的机会。情节模拟来到后排座椅后，把座椅拉扣掰起，然后放到后排座椅。接着快速爬到后备箱内部，然后拉开后备箱拉环打开后备箱。不同车型放倒座椅的暗扣都不一样，但位置基本一致。情节模拟这里就有一个细节，一点是面朝上，而不是趴着，因为有可能打开后备箱的时候水一下子就涌了进来。情节模拟失去呼吸的空间和视野是非常危险的事情。头部向上的话，则可以有效避免这样的问题。情节模拟后尾箱打开之后，快速爬到车顶等待救援，如果探明河道情况，或者水性良好的话，也可以自行游到岸边。情节模拟救援人员一边抱着女司机走向岸边，一边听着她的自救故事心生佩服。站在岸边的女司机看着爱车下沉到河底，虽然可惜，但抱住了命，随后保险公司到现场后就可以索赔新车了。所以，各位，只要买了保险，就别担心车辆损失，保住了生命，一切财产都可以赔偿。" substringToIndex:arc4random()%length+length];
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:space];

	NSAttributedString *attriStr =  [[NSAttributedString alloc] initWithString:space==3 ? @"备注：图片版权归车轮所有":str
																	attributes:@{
																				 NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
																				 NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:white],
																				 NSParagraphStyleAttributeName : paragraphStyle
																				 }];
	return attriStr;
}

#pragma mark - set/get

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

- (void)setType:(CKWebPhotoType)type
{
	_type = type;
	if (_type != CKWebPhotoTypeDefault) {
		self.attributedCaptionTitle = nil;
		self.attributedCaptionSummary = nil;
		self.attributedCaptionCredit = nil;
	}
}

- (NSData *)imageData
{
	return _imageData;
}

- (NSArray<id<CKPhotoBrowserItem>> *)morePhotos
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

- (NSAttributedString *)attributedCaptionTitle
{
	return _attributedCaptionTitle;
}

- (NSAttributedString *)attributedCaptionCredit
{
	return _attributedCaptionCredit;
}

- (NSAttributedString *)attributedCaptionSummary
{
	return _attributedCaptionSummary;
}

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

- (void)loadImageIfNeed
{
	if (_imageUrl.length<=0 || _image || _imageData || _type==CKWebPhotoTypeMore) {
		return;
	}
	typeof(self) weakSelf = self;
	[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:_imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
		if ([image isGIF]) {
			weakSelf.imageData = data;
		} else if (image) {
			weakSelf.image = image;
		}
	}];
}

@end





