//
//  CKPBCaptionView.m
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/18/15.
//
//

#import "CKPBCaptionView.h"

static const CGFloat CKPBCaptionViewHorizontalMargin = 8.0;
static const CGFloat CKPBCaptionViewVerticalMargin = 7.0;

@interface CKPBCaptionView ()

@property (nonatomic, readonly) NSAttributedString *attributedTitle;
@property (nonatomic, readonly) NSAttributedString *attributedSummary;
@property (nonatomic, readonly) NSAttributedString *attributedCredit;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end

@implementation CKPBCaptionView

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    return [self initWithAttributedTitle:nil attributedSummary:nil attributedCredit:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
	self.editable = NO;
	self.dataDetectorTypes = UIDataDetectorTypeNone;
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
	self.textContainerInset = UIEdgeInsetsMake(CKPBCaptionViewVerticalMargin*2, CKPBCaptionViewHorizontalMargin, CKPBCaptionViewVerticalMargin, CKPBCaptionViewHorizontalMargin);
}

#pragma mark - CKPBCaptionView

- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedSummary:(NSAttributedString *)attributedSummary attributedCredit:(NSAttributedString *)attributedCredit {
    self = [super initWithFrame:CGRectZero textContainer:nil];
    if (self) {
		
        _attributedTitle = [attributedTitle copy];
        _attributedSummary = [attributedSummary copy];
        _attributedCredit = [attributedCredit copy];
		
		[self commonInit];
        [self updateTextViewAttributedText];
    }
    return self;
}

- (void)updateTextViewAttributedText {
    NSMutableAttributedString *attributedLabelText = [[NSMutableAttributedString alloc] init];
    
    if (self.attributedTitle) {
        [attributedLabelText appendAttributedString:self.attributedTitle];
    }
    
    if (self.attributedSummary) {
        if (self.attributedTitle) {
            [attributedLabelText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        }
        [attributedLabelText appendAttributedString:self.attributedSummary];
    }
    
    if (self.attributedCredit) {
        if (self.attributedTitle || self.attributedSummary) {
            [attributedLabelText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        }
        [attributedLabelText appendAttributedString:self.attributedCredit];
    }
    
    self.attributedText = attributedLabelText;
}

@end
