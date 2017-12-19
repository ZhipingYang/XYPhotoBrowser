//
//  XYViewController.m
//  XYPhotoBrowser
//
//  Created by zhipingyang on 12/19/2017.
//  Copyright (c) 2017 zhipingyang. All rights reserved.
//

#import "XYViewController.h"
#import "PhotoManager.h"

#import "PhotoDataSource.h"
#import "CKPhotoBrowserController.h"
#import "CKPBArrayDataSource.h"

@interface XYViewController ()<CKPhotoBrowserControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UIImageView *textImage;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage;

@property (nonatomic, strong) CKPBArrayDataSource *dataSource;
@end

@implementation XYViewController

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
			[PhotoManager showWithNewsId:@"" onReferenceView:_bigImage];
		} else if (indexPath.row == 2) {
			[PhotoManager showWithNewsId:@"" onReferenceView:_textImage];
		}
		
	} else if (indexPath.section == 1) {
		_dataSource = [[CKPBArrayDataSource alloc] initWithPhotos:@[
																	[[PhotoItem alloc] initWithImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gif0" ofType:@"gif"]]],
																	[[PhotoItem alloc] initWithImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gif1" ofType:@"gif"]]],
																	[[PhotoItem alloc] initWithImage:[UIImage imageNamed:@"gif0.gif"]],
																	[[PhotoItem alloc] initWithImage:[UIImage imageNamed:@"gif1.gif"]],
																	]];
		CKPhotoBrowserController *photosViewController = [[CKPhotoBrowserController alloc] initWithDataSource:_dataSource initialPhoto:_dataSource.photos.lastObject delegate:self];
		[self presentViewController:photosViewController animated:YES completion:nil];
	}
}

- (UIView *)photosViewController:(CKPhotoBrowserController *)photosViewController referenceViewForPhoto:(id<CKPhotoBrowserItem>)photo
{
	return _smallImage;
}

@end
