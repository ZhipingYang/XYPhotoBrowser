//
//  XYPBSinglePhotoDataSource.m
//  CKWebPhotoViewer
//
//  Created by Chris Dzombak on 1/27/17.
//  Copyright © 2017 The New York Times Company. All rights reserved.
//

#import "XYPBSinglePhotoDataSource.h"

@implementation XYPBSinglePhotoDataSource

- (instancetype)initWithPhoto:(id<XYPhotoBrowserItem>)photo {
    if ((self = [super init])) {
        _photo = photo;
    }
    return self;
}

+ (instancetype)dataSourceWithPhoto:(id<XYPhotoBrowserItem>)photo {
    return [[self alloc] initWithPhoto:photo];
}

#pragma mark XYPhotoBrowserDataSource

- (NSInteger)numberOfPhotos {
    return 1;
}

- (id<XYPhotoBrowserItem>)photoAtIndex:(NSInteger)photoIndex {
    return self.photo;
}

- (NSInteger)indexOfPhoto:(id<XYPhotoBrowserItem>)photo {
    return 0;
}

- (void)didReceiveMemoryWarning
{
	//do nothing
}

@end
