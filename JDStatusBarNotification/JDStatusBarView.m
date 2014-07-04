//
//  JDStatusBarView.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarView.h"

@interface JDStatusBarView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation JDStatusBarView

#pragma mark dynamic getter

- (UILabel *)textLabel;
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.clipsToBounds = YES;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height - 1, self.bounds.size.height - 1)];
        
        [self insertSubview:_imageView belowSubview:_textLabel];
    }
    
    return _imageView;
}

- (UIActivityIndicatorView *)activityIndicatorView;
{
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

#pragma mark setter

- (void)setTextVerticalPositionAdjustment:(CGFloat)textVerticalPositionAdjustment;
{
    _textVerticalPositionAdjustment = textVerticalPositionAdjustment;
    [self setNeedsLayout];
}

#pragma mark layout

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // label
    CGSize textSize = [self currentTextSize];
    self.textLabel.frame = CGRectMake((self.bounds.size.width - textSize.width) / 2, 1 + self.textVerticalPositionAdjustment,
                                      textSize.width + 2, self.bounds.size.height - 1);
    
    if (_imageView)
    {
        // size to fit
        CGRect imageViewFrame = _imageView.frame;
        imageViewFrame.size.width = _imageView.image.size.width;
        imageViewFrame.size.height = _imageView.image.size.height;
        
        imageViewFrame.origin.x = round((self.bounds.size.width - self.textLabel.frame.size.width - imageViewFrame.size.width * 2 - 6.0f) / 2.0);
        imageViewFrame.origin.y = ceil((self.bounds.size.height - imageViewFrame.size.height) / 2.0);
        
        _imageView.frame = imageViewFrame;
    }
    
    
    // activity indicator
    if (_activityIndicatorView ) {
        CGRect indicatorFrame = _activityIndicatorView.frame;
        indicatorFrame.origin.x = round((self.bounds.size.width - self.textLabel.frame.size.width - (_imageView != nil ? _imageView.frame.size.width * 2 : 0) - indicatorFrame.size.width * 2 - 12.0f) / 2.0);
        indicatorFrame.origin.y = ceil(1+(self.bounds.size.height - indicatorFrame.size.height)/2.0);
        _activityIndicatorView.frame = indicatorFrame;
    }
}

- (CGSize)currentTextSize;
{
    CGSize textSize = CGSizeZero;
    
    // use new sizeWithAttributes: if possible
    SEL selector = NSSelectorFromString(@"sizeWithAttributes:");
    if ([self.textLabel.text respondsToSelector:selector]) {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
        textSize = [self.textLabel.text sizeWithAttributes:attributes];
        #endif
    }
    
    // otherwise use old sizeWithFont:
    else {
        #if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // only when deployment target is < ios7
        textSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
        #endif
    }
    
    return textSize;
}

@end
