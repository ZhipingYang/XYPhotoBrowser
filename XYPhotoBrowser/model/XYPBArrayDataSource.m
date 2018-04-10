//
//  XYPBArrayDataSource.m
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//  Copyright (c) 2017 The New York Times Company. All rights reserved.
//

#import "XYPBArrayDataSource.h"
#import "XYPhotoBrowserItem.h"

@implementation XYPBArrayDataSource

#pragma mark - NSObject

- (instancetype)init {
    return [self initWithPhotos:nil];
}

#pragma mark - CKWebPhotosDataSource

- (instancetype)initWithPhotos:(nullable NSArray<id<XYPhotoBrowserItem>> *)photos {
    self = [super init];
    
    if (self) {
        if (photos == nil) {
            _photos = @[];
        } else {
            _photos = [photos copy];
        }
    }
    return self;
}

+ (instancetype)dataSourceWithPhotos:(nullable NSArray<id<XYPhotoBrowserItem>> *)photos {
    return [[self alloc] initWithPhotos:photos];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)length {
    return [self.photos countByEnumeratingWithState:state objects:buffer count:length];
}

#pragma mark - XYPhotoBrowserControllerDataSource

- (NSInteger)numberOfPhotos {
    return self.photos.count;
}

- (nullable id <XYPhotoBrowserItem>)photoAtIndex:(NSInteger)photoIndex {
    if (photoIndex < self.photos.count && photoIndex>=0) {
        return self.photos[photoIndex];
    }
    return nil;
}

- (NSInteger)indexOfPhoto:(id <XYPhotoBrowserItem>)photo {
    return [self.photos indexOfObject:photo];
}

- (void)didReceiveMemoryWarning
{
	[_photos enumerateObjectsUsingBlock:^(id<XYPhotoBrowserItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj respondsToSelector:@selector(unloadUnderlyingImage)]) {
			[obj unloadUnderlyingImage];
		}
	}];
}

#pragma mark - Subscripting

- (id<XYPhotoBrowserItem>)objectAtIndexedSubscript:(NSUInteger)idx {
	if (idx < self.photos.count) {
		return self.photos[idx];
	}
	return nil;
}

@end
