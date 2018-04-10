//
//  XYPBDefaultCaptionView.m
//  CKWebPhotoViewer
//
//  Created by XcodeYang on 10/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPBDefaultCaptionView.h"
#import "XYPhotoBrowserCategory.h"

static const CGFloat XYPBDefaultCaptionViewHorizontalMargin = 8.0;
static const CGFloat XYPBDefaultCaptionViewVerticalMargin = 7.0;

@interface XYPBDefaultCaptionView ()
{
	CALayer *_bottomLayer;
}

@end

@implementation XYPBDefaultCaptionView

- (instancetype)initWithPhoto:(id<XYPhotoBrowserItem>)photo
{
	if (photo.attributedCaptionTitle.length<=0 && photo.attributedCaptionSummary.length<=0 && photo.attributedCaptionCredit.length<=0) {
		return nil;
	}
	self = [super initWithFrame:CGRectZero textContainer:nil];
	if (self) {
		_attributedTitle = [photo.attributedCaptionTitle copy];
		_attributedSummary = [photo.attributedCaptionSummary copy];
		_attributedCredit = [photo.attributedCaptionCredit copy];
		
		[self commonInit];
		[self updateTextViewAttributedText];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj isKindOfClass:NSClassFromString(@"_UITextContainerView")]) {
			obj.backgroundColor = ckph_alphaBlack;
			[obj.layer addSublayer:_bottomLayer];
			_bottomLayer.frame = CGRectMake(0, obj.xypb_bottom, obj.xypb_width, 200);
		}
	}];
	
	if (!_bottomLayer.superlayer) {
		self.backgroundColor = ckph_alphaBlack;
	}
}

- (void)commonInit
{
	self.editable = NO;
	self.clipsToBounds = YES;
	self.showsVerticalScrollIndicator = NO;
	self.dataDetectorTypes = UIDataDetectorTypeNone;
	self.backgroundColor = [UIColor clearColor];
	self.textContainerInset = UIEdgeInsetsMake(XYPBDefaultCaptionViewVerticalMargin*2, XYPBDefaultCaptionViewHorizontalMargin, XYPBDefaultCaptionViewVerticalMargin, XYPBDefaultCaptionViewHorizontalMargin);
	_bottomLayer = [CALayer layer];
	_bottomLayer.backgroundColor = ckph_alphaBlack.CGColor;
}

- (void)updateTextViewAttributedText
{
    NSMutableAttributedString *attributedLabelText = [[NSMutableAttributedString alloc] init];
    
    if (self.attributedTitle.length > 0) {
        [attributedLabelText appendAttributedString:self.attributedTitle];
    }
    
    if (self.attributedSummary.length > 0) {
        if (self.attributedTitle.length > 0) {
            [attributedLabelText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        }
        [attributedLabelText appendAttributedString:self.attributedSummary];
    }
    
    if (self.attributedCredit.length > 0) {
        if (self.attributedTitle.length > 0 || self.attributedSummary.length > 0) {
            [attributedLabelText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        }
        [attributedLabelText appendAttributedString:self.attributedCredit];
    }
    
    self.attributedText = attributedLabelText;
}

@end
