//
//  PhotoDataSource.h
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "CKPhotoBrowserDataSource.h"
#import "PhotoItem.h"

@class PhotoDataSource;
@protocol PhotoDataSourceDelegate <NSObject>

- (void)photoDataSourceStartLoading;

- (void)photoDataSourceLoadingSuccess:(BOOL)sucess;

@end

@interface PhotoDataSource : NSObject <CKPhotoBrowserDataSource>

@property (nonatomic, weak) id<PhotoDataSourceDelegate> delegate;
@property (nonatomic, readonly) NSMutableArray <PhotoItem *> *items;


- (instancetype)initWithDelegate:(id<PhotoDataSourceDelegate>)delegate
						  newsID:(NSString *)newsID
				   referenceView:(UIView *)referenceView NS_DESIGNATED_INITIALIZER;

- (void)updateDataWithPhotoItem:(PhotoItem *)photo;

- (instancetype)init NS_UNAVAILABLE;

@end
