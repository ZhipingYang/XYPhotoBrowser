//
//  PhotoDataSource.m
//  XYImageBrowserDemo
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "PhotoDataSource.h"
#import "XYPhotoBrowserCategory.h"

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
			UIImage *image = [referenceView xypb_getImageFromView];
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

#pragma mark - XYPhotoBrowserDataSource

- (NSInteger)numberOfPhotos
{
	return _items.count;
}

- (NSInteger)indexOfPhoto:(id<XYPhotoBrowserItem>)photo
{
	return [_items indexOfObject:photo];
}

- (id<XYPhotoBrowserItem>)photoAtIndex:(NSInteger)photoIndex
{
	if (photoIndex<0 || photoIndex>=_items.count) {
		return nil;
	}
	return [_items objectAtIndex:photoIndex];
}

- (void)didReceiveMemoryWarning
{
	// 释放内存
	[_items enumerateObjectsUsingBlock:^(PhotoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj unloadUnderlyingImage];
	}];
}

#pragma mark - public

- (void)updateDataWithPhotoItem:(PhotoItem *)photo
{
	if ([_delegate respondsToSelector:@selector(photoDataSourceStartLoading)]) {
		[_delegate photoDataSourceStartLoading];
	}
	__weak typeof(self) weakSelf = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSMutableArray *array = @[].mutableCopy;
		NSArray *imageUrls = @[@"https://user-images.githubusercontent.com/9360037/38593004-d4e351da-3d71-11e8-8926-d7db18b9487c.jpg",
							   @"https://user-images.githubusercontent.com/9360037/38593005-d543c4fc-3d71-11e8-9979-869daa9456d7.jpg",
							   @"https://user-images.githubusercontent.com/9360037/38593006-d5d17f54-3d71-11e8-962a-9d6443871dee.jpg",
							   @"https://user-images.githubusercontent.com/9360037/38593077-2405b334-3d72-11e8-8845-8bc6626ecdc2.gif",
							   @"https://user-images.githubusercontent.com/9360037/38593009-d6c3c700-3d71-11e8-8184-3d3ae17c8375.jpg",
							   @"https://user-images.githubusercontent.com/9360037/38592861-0f0fb584-3d71-11e8-884b-b07510f74ec4.gif",
							   @"https://user-images.githubusercontent.com/9360037/38592860-0eaec3b4-3d71-11e8-9bcf-7496b8ead6e6.gif"];
		for (int i=0; i<imageUrls.count; i++) {
			PhotoItem *item = [[PhotoItem alloc] initWithImageUrl:imageUrls[i]];
			item.type = i==(imageUrls.count-1) ? CKWebPhotoTypeAd : CKWebPhotoTypeDefault;
			[array addObject:item];
		}
		PhotoItem *item = [[PhotoItem alloc] init];
		item.type = CKWebPhotoTypeMore;
		[array addObject:item];
		
		[weakSelf.items removeAllObjects];
		weakSelf.items = array.mutableCopy;
		if ([weakSelf.delegate respondsToSelector:@selector(photoDataSourceLoadingSuccess:)]) {
			[weakSelf.delegate photoDataSourceLoadingSuccess:YES];
		}
	});
}

#pragma mark - private

- (void)startLoadingData
{
	if ([_delegate respondsToSelector:@selector(photoDataSourceStartLoading)]) {
		[_delegate photoDataSourceStartLoading];
	}
	__weak typeof(self) weakSelf = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSMutableArray *array = @[].mutableCopy;
		NSArray *imageUrls = @[@"https://user-images.githubusercontent.com/9360037/38593004-d4e351da-3d71-11e8-8926-d7db18b9487c.jpg",
							   @"https://user-images.githubusercontent.com/9360037/38593005-d543c4fc-3d71-11e8-9979-869daa9456d7.jpg",
							   @"https://user-images.githubusercontent.com/9360037/38593006-d5d17f54-3d71-11e8-962a-9d6443871dee.jpg",
							   @"https://user-images.githubusercontent.com/9360037/38593077-2405b334-3d72-11e8-8845-8bc6626ecdc2.gif",
							   @"https://user-images.githubusercontent.com/9360037/38593009-d6c3c700-3d71-11e8-8184-3d3ae17c8375.jpg",
							   @"https://user-images.githubusercontent.com/9360037/38592861-0f0fb584-3d71-11e8-884b-b07510f74ec4.gif",
							   @"https://user-images.githubusercontent.com/9360037/38592860-0eaec3b4-3d71-11e8-9bcf-7496b8ead6e6.gif"];
		for (int i=0; i<imageUrls.count; i++) {
			PhotoItem *item = [[PhotoItem alloc] initWithImageUrl:imageUrls[i]];
			item.type = i==(imageUrls.count-1) ? CKWebPhotoTypeAd : CKWebPhotoTypeDefault;
			[array addObject:item];
		}
		PhotoItem *item = [[PhotoItem alloc] init];
		item.type = CKWebPhotoTypeMore;
		[array addObject:item];
		
		[weakSelf.items removeAllObjects];
		weakSelf.items = array.mutableCopy;
		if ([weakSelf.delegate respondsToSelector:@selector(photoDataSourceLoadingSuccess:)]) {
			[weakSelf.delegate photoDataSourceLoadingSuccess:YES];
		}
	});
}

@end

