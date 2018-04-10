//
//  CustomView.m
//  XYPhotoBrowserDemo
//
//  Created by XcodeYang on 20/01/2018.
//  Copyright © 2018 XcodeYang. All rights reserved.
//

#import "CustomView.h"
#import "XYPhotoBrowserCategory.h"

@interface CustomView()
{
	PhotoItem *_photo;
}
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation CustomView

- (id)initWithPhoto:(PhotoItem *)photo
{
	self = [[[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:nil options:nil] firstObject];
	if (self) {
		_photo = photo;
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	_redView.frame = CGRectMake((self.xypb_width-100)/2.0, (self.xypb_height-100)/2.0, 100, 100);
}

- (void)didMoveToWindow
{
	[super didMoveToWindow];
	
	[_redView.layer removeAllAnimations];
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.duration = 2;
	animation.fromValue = @(M_PI);
	animation.toValue = @(-M_PI);
	animation.repeatCount = CGFLOAT_MAX;
	[_redView.layer addAnimation:animation forKey:@"rotate"];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView *view = [super hitTest:point withEvent:event];
	return view == _button ? _button : nil;
}

- (void)updatePhoto:(id<XYPhotoBrowserItem>)photo
{
	// do nothing
}

- (id<XYPhotoBrowserItem>)photo
{
	return _photo;
}

- (IBAction)buttonClickAction:(id)sender {
	!_moreViewClickBlock ?: _moreViewClickBlock();
}

@end
