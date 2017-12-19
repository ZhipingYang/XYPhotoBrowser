//
//  CKPBSinglePhotoDataSource.m
//  CKWebPhotoViewer
//
//  Created by Chris Dzombak on 1/27/17.
//  Copyright © 2017 The New York Times Company. All rights reserved.
//

#import "CKPBSinglePhotoDataSource.h"

@implementation CKPBSinglePhotoDataSource

- (instancetype)initWithPhoto:(id<CKPhotoBrowserItem>)photo {
    if ((self = [super init])) {
        _photo = photo;
    }
    return self;
}

+ (instancetype)dataSourceWithPhoto:(id<CKPhotoBrowserItem>)photo {
    return [[self alloc] initWithPhoto:photo];
}

#pragma mark CKPhotoBrowserDataSource

- (NSNumber *)numberOfPhotos {
    return @(1);
}

- (id<CKPhotoBrowserItem>)photoAtIndex:(NSInteger)photoIndex {
    return self.photo;
}

- (NSInteger)indexOfPhoto:(id<CKPhotoBrowserItem>)photo {
    return 0;
}

@end
