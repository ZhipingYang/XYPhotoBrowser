//
//  CKPBCaptionView.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/18/15.
//
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface CKPBCaptionView : UITextView

- (instancetype)initWithAttributedTitle:(nullable NSAttributedString *)attributedTitle attributedSummary:(nullable NSAttributedString *)attributedSummary attributedCredit:(nullable NSAttributedString *)attributedCredit NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
