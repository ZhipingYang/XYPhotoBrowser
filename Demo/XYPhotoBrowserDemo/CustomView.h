//
//  CustomView.h
//  XYPhotoBrowserDemo
//
//  Created by XcodeYang on 20/01/2018.
//  Copyright © 2018 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserContentView.h"
#import "PhotoItem.h"

@interface CustomView : UIView <XYPhotoBrowserContentView>

@property (weak, nonatomic) IBOutlet UIView *redView;

@property (nonatomic, copy) void (^moreViewClickBlock)(void);

@end
