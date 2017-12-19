//
//  PhotoDataSource.m
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "PhotoDataSource.h"
#import "CKPhotoBrowserCategory.h"

@interface PhotoDataSource()

@property (nonatomic, copy) NSString *newsID;

@property (nonatomic, strong) NSMutableArray <PhotoItem *> *items;

@end

@implementation PhotoDataSource

- (instancetype)initWithDelegate:(id<PhotoDataSourceDelegate>)delegate newsID:(NSString *)newsID referenceView:(UIView *)referenceView
{
	self = [super init];
	if (self) {
		_delegate = delegate;
		_newsID = newsID;
		
		_items = @[].mutableCopy;
		if ([referenceView isKindOfClass:[UIImageView class]]) {
			if ([(UIImageView *)referenceView image]) {
				PhotoItem *item = [[PhotoItem alloc] initWithImage:[(UIImageView *)referenceView image]];
				[_items addObject:item];
			}
		}
		if (_items.count<=0) {
			UIImage *image = [referenceView ckpb_getImageFromView];
			PhotoItem *item = [[PhotoItem alloc] initWithImage:image];
			[_items addObject:item];
		}
		[self startLoadingData];
	}
	return self;
}

- (instancetype)init
{
	@throw nil;
}

- (NSNumber *)numberOfPhotos
{
	return @(_items.count);
}

- (NSInteger)indexOfPhoto:(id<CKPhotoBrowserItem>)photo
{
	return [_items indexOfObject:photo];
}

- (id<CKPhotoBrowserItem>)photoAtIndex:(NSInteger)photoIndex
{
	return [_items objectAtIndex:photoIndex];
}

- (void)startLoadingData
{
	if ([_delegate respondsToSelector:@selector(photoDataSourceStartLoading)]) {
		[_delegate photoDataSourceStartLoading];
	}
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		sleep(2);
		NSMutableArray *array = @[].mutableCopy;
		NSArray *imageUrls = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511351146777&di=12e59a2a96a61038aa464a9e510faf88&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F265%2FP0F100HDE0X4.jpg",
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511351187986&di=150e71c728433cde42a50b7acf069a5a&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D170386196%2C2507667277%26fm%3D214%26gp%3D0.jpg",
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511351146777&di=fe861208aa1dd0bd484b1ccd4daa6a0c&imgtype=0&src=http%3A%2F%2Fattachments.gfan.com%2Fforum%2Fattachments2%2Fday_120101%2F1201012028ecbe98d8e891c59b.jpg",
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511412345966&di=b3410eac11fd4b5065761c791fa56258&imgtype=0&src=http%3A%2F%2Fp0.ifengimg.com%2Fpmop%2F2017%2F0829%2F7AB46C8FC26A3D763BE3755A45D76E83FED98296_size720_w500_h280.gif",
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511351146777&di=b058f68f2bc0d5c6cd7487f831b18ae9&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F6%2F53e19df48f87e.jpg",
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511343873817&di=4cf241191e662dcad0dc23654d52cc15&imgtype=0&src=http%3A%2F%2Fimg.ycwb.com%2Fnews%2Fattachement%2Fgif%2Fsite2%2F20160921%2F507b9d762551194c19be5f.gif",
							   @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2114763443,721394211&fm=27&gp=0.jpg"];
		for (int i=1; i<=imageUrls.count; i++) {
			//			PhotoItem *item = [[PhotoItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"引导%zd",i]]];
			PhotoItem *item = [[PhotoItem alloc] initWithImageUrl:imageUrls[i-1]];
			item.type = i==4 ? CKWebPhotoTypeAd : CKWebPhotoTypeDefault;
			item.type = i==imageUrls.count ? CKWebPhotoTypeMore : item.type;
			[array addObject:item];
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			[_items removeAllObjects];
			_items = array.mutableCopy;
			if ([_delegate respondsToSelector:@selector(photoDataSourceLoadingSuccess:)]) {
				[_delegate photoDataSourceLoadingSuccess:YES];
			}
		});
	});
}

- (void)updateDataWithPhotoItem:(PhotoItem *)photo
{
	if ([_delegate respondsToSelector:@selector(photoDataSourceStartLoading)]) {
		[_delegate photoDataSourceStartLoading];
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		sleep(2);
		NSMutableArray *array = @[].mutableCopy;
		NSArray *imageUrls = @[
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511412345966&di=b3410eac11fd4b5065761c791fa56258&imgtype=0&src=http%3A%2F%2Fp0.ifengimg.com%2Fpmop%2F2017%2F0829%2F7AB46C8FC26A3D763BE3755A45D76E83FED98296_size720_w500_h280.gif",
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511433581355&di=dcbe6be4ede5596cdd86c9daf35e0c89&imgtype=0&src=http%3A%2F%2Fimage1.pengfu.com%2Forigin%2F161121%2F583251a50189f.gif",
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511433581355&di=cd212e2ffc2b2c9497d0cfedb0358ea4&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01114b5986ee3900000021292df326.gif",
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511433581352&di=aed338310b28909b059055e0c7944a76&imgtype=0&src=http%3A%2F%2Fww1.sinaimg.cn%2Fmw690%2F6adc108fgw1f0hotm7cakg20fk08rnph.gif",
							   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511343873817&di=4cf241191e662dcad0dc23654d52cc15&imgtype=0&src=http%3A%2F%2Fimg.ycwb.com%2Fnews%2Fattachement%2Fgif%2Fsite2%2F20160921%2F507b9d762551194c19be5f.gif"];
		for (int i=1; i<=imageUrls.count; i++) {
			PhotoItem *item = [[PhotoItem alloc] initWithImageUrl:imageUrls[i-1]];
			item.type = i==4 ? CKWebPhotoTypeAd : CKWebPhotoTypeDefault;
			item.type = i==imageUrls.count ? CKWebPhotoTypeMore : item.type;
			[array addObject:item];
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			[_items removeAllObjects];
			_items = array.mutableCopy;
			if ([_delegate respondsToSelector:@selector(photoDataSourceLoadingSuccess:)]) {
				[_delegate photoDataSourceLoadingSuccess:YES];
			}
		});
	});
}

@end

