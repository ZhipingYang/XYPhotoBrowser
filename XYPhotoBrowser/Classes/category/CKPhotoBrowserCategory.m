//
//  CKPhotoBrowserCategory.m
//  CLPhotoBrowser
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "CKPhotoBrowserCategory.h"
#import "CKPhotoBrowserController.h"

@implementation UIView(CKPhotoBrowserCategory)

- (UIImage *)ckpb_getImageFromView {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (CGFloat)ckpb_left {
	return self.frame.origin.x;
}

- (void)setCkpb_left:(CGFloat)ckpb_left
{
	CGRect frame = self.frame;
	frame.origin.x = ckpb_left;
	self.frame = frame;
}

- (CGFloat)ckpb_top {
	return self.frame.origin.y;
}

- (void)setCkpb_top:(CGFloat)ckpb_top
{
	CGRect frame = self.frame;
	frame.origin.y = ckpb_top;
	self.frame = frame;
}

- (CGFloat)ckpb_right {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setCkpb_right:(CGFloat)ckpb_right
{
	CGRect frame = self.frame;
	frame.origin.x = ckpb_right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)ckpb_bottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setCkpb_bottom:(CGFloat)ckpb_bottom
{
	CGRect frame = self.frame;
	frame.origin.y = ckpb_bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)ckpb_width {
	return self.frame.size.width;
}

- (void)setCkpb_width:(CGFloat)ckpb_width
{
	CGRect frame = self.frame;
	frame.size.width = ckpb_width;
	self.frame = frame;
}

- (CGFloat)ckpb_height {
	return self.frame.size.height;
}

- (void)setCkpb_height:(CGFloat)ckpb_height
{
	CGRect frame = self.frame;
	frame.size.height = ckpb_height;
	self.frame = frame;
}

- (CGFloat)ckpb_centerX
{
	return self.center.x;
}

- (void)setCkpb_centerX:(CGFloat)ckpb_centerX
{
	CGPoint center = self.center;
	center.x = ckpb_centerX;
	self.center = center;
}

- (CGFloat)ckpb_centerY
{
	return self.center.y;
}

- (void)setCkpb_centerY:(CGFloat)ckpb_centerY
{
	CGPoint center = self.center;
	center.y = ckpb_centerY;
	self.center = center;
}

@end

@implementation UIDevice(CKPhotoBrowserCategory)

+ (BOOL)ckpb_isIPhone
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)ckpb_isIPhoneX
{
#ifdef __IPHONE_11_0
	return CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size);
#else
	return NO;
#endif
}

@end

@implementation UIImage(CKPhotoBrowserCategory)

+ (instancetype)ckpb_imageWithName:(NSString *)imageName
{
	//NOTE: @"image/%@" 不要写成 @"/image/%@"
	NSString *bundleImageName = [NSString stringWithFormat:@"image/%@",imageName];
	UIImage *image = [UIImage imageNamed:bundleImageName inBundle:[NSBundle ckpb_photoViewerResourceBundle] compatibleWithTraitCollection:nil];
	image = image ?: [UIImage imageNamed:[NSString stringWithFormat:@"CKPhotoBrowser.bundle/image/%@",imageName]];
	return image ?: [UIImage imageNamed:imageName];
}

+ (UIImage *)ckpb_imageWithColor:(UIColor *)color
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


@implementation NSBundle(CKPhotoBrowserCategory)

+ (instancetype)ckpb_photoViewerResourceBundle
{
	NSString *resourceBundlePath = [[NSBundle bundleForClass:[CKPhotoBrowserController class]] pathForResource:@"CKPhotoBrowser" ofType:@"bundle"];
	return [self bundleWithPath:resourceBundlePath];
}

@end

@implementation UIApplication (BPAdditions)

- (UIViewController *)ckpb_topViewController
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

@end

