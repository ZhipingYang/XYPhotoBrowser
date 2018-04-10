//
//  XYPBControllerOverlayView.m
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "XYPBControllerOverlayView.h"
#import "XYPhotoBrowserCategory.h"

@interface XYPBControllerOverlayView ()
{
	CALayer *_iPhoneXBottomLayer;
	UILabel *_titleView;
}
@property (nonatomic) UINavigationItem *navigationItem;
@property (nonatomic) UINavigationBar *navigationBar;
@property (nonatomic, strong) CAGradientLayer *naviBarBackLayer;

@end

@implementation XYPBControllerOverlayView

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupNavigationBar];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
	return hitView != self ? hitView : nil;
}

- (void)layoutSubviews {
    // The navigation bar has a different intrinsic content size upon rotation, so we must update to that new size.
    // Do it without animation to more closely match the behavior in `UINavigationController`
    [UIView performWithoutAnimation:^{
        [self.navigationBar invalidateIntrinsicContentSize];
        [self.navigationBar layoutIfNeeded];
    }];
    [super layoutSubviews];
	
	self.navigationBar.frame = CGRectMake(0, [UIDevice xypb_isIPhoneX] ? 40 : 0, self.xypb_width, 44);
	self.naviBarBackLayer.frame = CGRectMake(0, 0, self.xypb_width, self.navigationBar.xypb_bottom);
	
	CGFloat bottomDistance = [UIDevice xypb_isIPhoneX] ? 30 : 0;
	_iPhoneXBottomLayer.frame = CGRectMake(0, self.xypb_height-bottomDistance, self.xypb_width, bottomDistance);
	_iPhoneXBottomLayer.hidden = _funtionView==nil && _captionView==nil;
	
	CGFloat functionViewHeight = [_funtionView sizeThatFits:CGSizeMake(self.xypb_width, CGFLOAT_MAX)].height;
	self.funtionView.frame = CGRectMake(0, self.xypb_height-functionViewHeight - bottomDistance, self.xypb_width, functionViewHeight);
	
	CGFloat captionViewHeight = [_captionView sizeThatFits:CGSizeMake(self.xypb_width, CGFLOAT_MAX)].height;
	captionViewHeight = MIN(captionViewHeight, self.xypb_height*0.25);
	self.captionView.frame = CGRectMake(0, self.xypb_height-captionViewHeight-functionViewHeight-bottomDistance, self.xypb_width, captionViewHeight);
}

#pragma mark - XYPBControllerOverlayView

- (void)setupNavigationBar {
	
    self.navigationBar = [[UINavigationBar alloc] init];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.barTintColor = nil;
    self.navigationBar.translucent = YES;
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    self.navigationBar.items = @[self.navigationItem];
	
    [self addSubview:self.navigationBar];
	
	_titleView = [UILabel new];
	self.navigationItem.titleView = _titleView;
	
	self.naviBarBackLayer = [CAGradientLayer layer];
	self.naviBarBackLayer.colors = @[(id)ckph_alphaBlack.CGColor, (id)[UIColor clearColor].CGColor];
	[self.layer insertSublayer:self.naviBarBackLayer atIndex:0];
	
	_iPhoneXBottomLayer = [CALayer layer];
	_iPhoneXBottomLayer.backgroundColor = ckph_alphaBlack.CGColor;
	[self.layer addSublayer:_iPhoneXBottomLayer];
}

- (void)setCaptionView:(UIView<XYPhotoBrowserViewResize> *)captionView {
    if (self.captionView == captionView) {
        return;
    }
    
    [self.captionView removeFromSuperview];
    _captionView = captionView;
    [self addSubview:self.captionView];
	[self setNeedsLayout];
}

- (void)setFuntionView:(UIView<XYPhotoBrowserViewResize> *)funtionView {
	if (self.funtionView == funtionView) {
		return;
	}
	
	[self.funtionView removeFromSuperview];
	_funtionView = funtionView;
	[self addSubview:self.funtionView];
	[self setNeedsLayout];
}

- (UIBarButtonItem *)leftBarButtonItem {
    return self.navigationItem.leftBarButtonItem;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem animated:NO];
}

- (NSArray *)leftBarButtonItems {
    return self.navigationItem.leftBarButtonItems;
}

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems {
    [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:NO];
}

- (UIBarButtonItem *)rightBarButtonItem {
    return self.navigationItem.rightBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:NO];
}

- (NSArray *)rightBarButtonItems {
    return self.navigationItem.rightBarButtonItems;
}

- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems {
    [self.navigationItem setRightBarButtonItems:rightBarButtonItems animated:NO];
}

- (NSAttributedString *)title {
    return _titleView.attributedText;
}

- (void)setTitle:(NSAttributedString *)title {
    _titleView.attributedText = title;
	[_titleView sizeToFit];
}

- (NSDictionary *)titleTextAttributes {
    return self.navigationBar.titleTextAttributes;
}

- (void)setTitleTextAttributes:(NSDictionary *)titleTextAttributes {
    self.navigationBar.titleTextAttributes = titleTextAttributes;
}

@end
