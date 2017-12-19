//
//  CKPBFunctionView.m
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 13/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "CKPBFunctionView.h"
#import "CKPhotoBrowserCategory.h"
#import "CKPhotoBrowserCategory.h"

@interface CKPBFunctionView()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation CKPBFunctionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        _inputView = [[UITextField alloc] init];
        _inputView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"写评论..." attributes:@{
                                                                                                             NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                                                                             NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.8]
                                                                                                             }];
        _inputView.textColor = [UIColor whiteColor];
        _inputView.background = [UIImage ckpb_imageWithColor:[UIColor colorWithWhite:1 alpha:0.3]];
        _inputView.font = [UIFont systemFontOfSize:13];
        _inputView.clipsToBounds = YES;
        _inputView.delegate = self;
        UIImageView *textLeftView = [[UIImageView alloc] initWithImage:[UIImage ckpb_imageWithName:@"ckpb_input_icon"]];
        textLeftView.frame = CGRectMake(0, 0, 30, 20);
        textLeftView.contentMode = UIViewContentModeCenter;
        _inputView.leftView = textLeftView;
        _inputView.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:_inputView];
        
        UIButton * (^creatButtonBlock)(NSString *imageName, SEL selector) = ^(NSString *imageName, SEL selector) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage ckpb_imageWithName:imageName] forState:UIControlStateNormal];
            [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            return btn;
        };
        _commentView = creatButtonBlock(@"ckpb_comment", @selector(commentAction));
        _starView = creatButtonBlock(@"ckpb_thumbs_up", @selector(starAction));
        [_starView setImage:[UIImage ckpb_imageWithName:@"ckpb_thumbs_up_selected"] forState:UIControlStateSelected];
        _shareView = creatButtonBlock(@"ckpb_share", @selector(shareAction));
        
        _badgeLabel = [UILabel new];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.font = [UIFont systemFontOfSize:8];
        [_commentView addSubview:_badgeLabel];
    }
    return self;
}

- (void)setCommentNumber:(NSInteger)commentNumber
{
    _commentNumber = commentNumber;
    _badgeLabel.hidden = commentNumber<=0;
    _badgeLabel.text = @(_commentNumber).stringValue;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, 44);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat itemWidth = 50;

	_commentView.frame = CGRectMake(self.ckpb_width-itemWidth-12, 0, itemWidth, self.ckpb_height);
	_shareView.frame = CGRectMake(_commentView.ckpb_left-itemWidth, 0, itemWidth, self.ckpb_height);
	_starView.frame = CGRectMake(_shareView.ckpb_left-itemWidth, 0, itemWidth, self.ckpb_height);
	_badgeLabel.frame = CGRectMake(_commentView.ckpb_width-20, 7, 15, 10);
	_badgeLabel.layer.cornerRadius = _badgeLabel.ckpb_height/2.0;

	
    _inputView.frame = CGRectMake(12, 8, _starView.ckpb_left-12*2, self.ckpb_height-8*2);
    _inputView.layer.cornerRadius = _inputView.ckpb_height/2.0;
}

#pragma mark - actions

- (void)inputAction
{
    if ([self.delegate respondsToSelector:@selector(functionView:inputViewDidClick:)]) {
        [self.delegate functionView:self inputViewDidClick:_inputView];
    }
}

- (void)commentAction
{
    if ([self.delegate respondsToSelector:@selector(functionView:commentViewDidClick:)]) {
        [self.delegate functionView:self commentViewDidClick:_commentView];
    }
}

- (void)starAction
{
    if ([self.delegate respondsToSelector:@selector(functionView:starViewDidClick:)]) {
        [self.delegate functionView:self starViewDidClick:_starView];
    }
}

- (void)shareAction
{
    if ([self.delegate respondsToSelector:@selector(functionView:shareViewDidClick:)]) {
        [self.delegate functionView:self shareViewDidClick:_shareView];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self inputAction];
    return NO;
}

@end

