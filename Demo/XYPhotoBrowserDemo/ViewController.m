//
//  ViewController.m
//  XYPhotoBrowserDemo
//
//  Created by XcodeYang on 23/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "ViewController.h"
#import "PhotoManager.h"

#import "PhotoDataSource.h"
#import "XYPhotoBrowserController.h"
#import "XYPBArrayDataSource.h"

@interface ViewController ()<XYPhotoBrowserControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UIImageView *textImage;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage;

@property (nonatomic, strong) XYPBArrayDataSource *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.tableFooterView = [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			[PhotoManager showWithNewsId:@"" onReferenceView:[tableView cellForRowAtIndexPath:indexPath].contentView];
		} else if (indexPath.row == 1) {
			[PhotoManager showWithNewsId:@"" onReferenceView:[tableView cellForRowAtIndexPath:indexPath]];
		} else if (indexPath.row == 2) {
			[PhotoManager showWithNewsId:@"" onReferenceView:_textImage];
		}
		
	} else if (indexPath.section == 1) {
		_dataSource = [[XYPBArrayDataSource alloc] initWithPhotos:@[
																	[[PhotoItem alloc] initWithImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gif0" ofType:@"gif"]]],
																	[[PhotoItem alloc] initWithImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gif1" ofType:@"gif"]]],
																	[[PhotoItem alloc] initWithImage:[UIImage imageNamed:@"gif0.gif"]],
																	[[PhotoItem alloc] initWithImage:[UIImage imageNamed:@"screenshot"]],
																	]];
		XYPhotoBrowserController *photosViewController = [[XYPhotoBrowserController alloc] initWithDataSource:_dataSource initialPhoto:_dataSource.photos.lastObject delegate:self];
		[self presentViewController:photosViewController animated:YES completion:nil];
	}
}

- (UIView *)photosViewController:(XYPhotoBrowserController *)photosViewController referenceViewForPhoto:(id<XYPhotoBrowserItem>)photo
{
	return _smallImage;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
}

@end

