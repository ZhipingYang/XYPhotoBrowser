//
//  XYPhotoBrowser.h
//  XYPhotoBrowser
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<XYPhotoBrowser/XYPhotoBrowser.h>)

// Controller
#import <XYPhotoBrowser/XYPhotoBrowserController.h>
#import <XYPhotoBrowser/XYPhotoBrowserChildController.h>
#import <XYPhotoBrowser/XYPhotoBrowserTransitionController.h>
#import <XYPhotoBrowser/XYPhotoBrowserDismissalInteractionController.h>

// Model
#import <XYPhotoBrowser/XYPBTransitionAnimator.h>
#import <XYPhotoBrowser/XYPBArrayDataSource.h>
#import <XYPhotoBrowser/XYPBSinglePhotoDataSource.h>

// View
#import <XYPhotoBrowser/XYPBScalingImageView.h>
#import <XYPhotoBrowser/XYPBControllerOverlayView.h>
#import <XYPhotoBrowser/XYPBDefaultCaptionView.h>
#import <XYPhotoBrowser/XYPBDefaultFunctionView.h>

// Protocols
#import <XYPhotoBrowser/XYPhotoBrowserItem.h>
#import <XYPhotoBrowser/XYPhotoBrowserDataSource.h>
#import <XYPhotoBrowser/XYPhotoBrowserContainer.h>

// Category
#import <XYPhotoBrowser/XYPhotoBrowserCategory.h>

#else

// Controller
#import "XYPhotoBrowserController.h"
#import "XYPhotoBrowserChildController.h"
#import "XYPhotoBrowserTransitionController.h"
#import "XYPhotoBrowserDismissalInteractionController.h"

// Model
#import "XYPBTransitionAnimator.h"
#import "XYPBArrayDataSource.h"
#import "XYPBSinglePhotoDataSource.h"

// View
#import "XYPBScalingImageView.h"
#import "XYPBControllerOverlayView.h"
#import "XYPBDefaultCaptionView.h"
#import "XYPBDefaultFunctionView.h"

// Protocols
#import "XYPhotoBrowserItem.h"
#import "XYPhotoBrowserDataSource.h"
#import "XYPhotoBrowserContainer.h"

// Category
#import "XYPhotoBrowserCategory.h"

#endif
