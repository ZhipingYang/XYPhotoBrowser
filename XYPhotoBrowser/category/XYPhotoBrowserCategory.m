//
//  XYPhotoBrowserCategory.m
//  CLPhotoBrowser
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserCategory.h"
#import "XYPhotoBrowserController.h"

@implementation UIView(XYPhotoBrowserCategory)

- (UIImage *)xypb_getImageFromView {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (CGFloat)xypb_left {
	return self.frame.origin.x;
}

- (void)setxypb_left:(CGFloat)xypb_left
{
	CGRect frame = self.frame;
	frame.origin.x = xypb_left;
	self.frame = frame;
}

- (CGFloat)xypb_top {
	return self.frame.origin.y;
}

- (void)setxypb_top:(CGFloat)xypb_top
{
	CGRect frame = self.frame;
	frame.origin.y = xypb_top;
	self.frame = frame;
}

- (CGFloat)xypb_right {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setxypb_right:(CGFloat)xypb_right
{
	CGRect frame = self.frame;
	frame.origin.x = xypb_right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)xypb_bottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setxypb_bottom:(CGFloat)xypb_bottom
{
	CGRect frame = self.frame;
	frame.origin.y = xypb_bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)xypb_width {
	return self.frame.size.width;
}

- (void)setxypb_width:(CGFloat)xypb_width
{
	CGRect frame = self.frame;
	frame.size.width = xypb_width;
	self.frame = frame;
}

- (CGFloat)xypb_height {
	return self.frame.size.height;
}

- (void)setxypb_height:(CGFloat)xypb_height
{
	CGRect frame = self.frame;
	frame.size.height = xypb_height;
	self.frame = frame;
}

- (CGFloat)xypb_centerX
{
	return self.center.x;
}

- (void)setxypb_centerX:(CGFloat)xypb_centerX
{
	CGPoint center = self.center;
	center.x = xypb_centerX;
	self.center = center;
}

- (CGFloat)xypb_centerY
{
	return self.center.y;
}

- (void)setxypb_centerY:(CGFloat)xypb_centerY
{
	CGPoint center = self.center;
	center.y = xypb_centerY;
	self.center = center;
}

@end

@implementation UIDevice(XYPhotoBrowserCategory)

+ (BOOL)xypb_isIPhone
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)xypb_isIPhoneX
{
#ifdef __IPHONE_11_0
	return CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size);
#else
	return NO;
#endif
}

@end

@implementation UIViewController(XYPhotoBrowserCategory)

+ (UIViewController *)xypb_topViewController
{
	UIViewController *rootController = [[[UIApplication sharedApplication].delegate window] rootViewController];
	
	while (rootController.presentedViewController!=nil || [rootController isKindOfClass:[UINavigationController class]]) {
		if (rootController.presentedViewController!=nil) {
			rootController = rootController.presentedViewController;
		}
		if ([rootController isKindOfClass:[UINavigationController class]]) {
			rootController = [[(UINavigationController *)rootController viewControllers] lastObject];
		}
	}
	return rootController;
}

+ (nullable UINavigationController *)xypb_topNavigationController
{
	UIViewController *rootNavController = [[[UIApplication sharedApplication].delegate window] rootViewController];
	
	while (rootNavController.presentedViewController!=nil && [rootNavController.presentedViewController isKindOfClass:[UINavigationController class]]) {
		rootNavController = rootNavController.presentedViewController;
	}
	
	if (rootNavController && [rootNavController isKindOfClass:[UINavigationController class]]) {
		return (UINavigationController *)rootNavController;
	}
	return nil;
}

@end

@implementation UIImage(XYPhotoBrowserCategory)

+ (instancetype)xypb_imageWithName:(NSString *)imageName
{
	//NOTE: @"image/%@" 不要写成 @"/image/%@"
	NSString *bundleImageName = [NSString stringWithFormat:@"image/%@",imageName];
	UIImage *image = [UIImage imageNamed:bundleImageName inBundle:[NSBundle xypb_photoViewerResourceBundle] compatibleWithTraitCollection:nil];
	image = image ?: [UIImage imageNamed:[NSString stringWithFormat:@"XYPhotoBrowser.bundle/image/%@",imageName]];
	return image ?: [UIImage imageNamed:imageName];
}

+ (UIImage *)xypb_imageWithColor:(UIColor *)color
{
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end


@implementation NSBundle(XYPhotoBrowserCategory)

+ (instancetype)xypb_photoViewerResourceBundle
{
	NSString *resourceBundlePath = [[NSBundle bundleForClass:[XYPhotoBrowserController class]] pathForResource:@"XYPhotoBrowser" ofType:@"bundle"];
	return [self bundleWithPath:resourceBundlePath];
}

@end

