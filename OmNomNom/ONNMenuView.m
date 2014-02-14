//
//  ONNMenuView.m
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/13/14.
//
//

#import "ONNMenuView.h"

@implementation ONNMenuView

UILabel *_label;
UITextView *_textView;
UIImageView *_backgroundImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void) setCafeName:(NSString *)cafeName andMenu:(NSString *)menu
{
    _label.text = cafeName;
    _textView.text = menu;
    _textView.font = [UIFont systemFontOfSize:16.0];
    [_label sizeToFit];
    [_textView sizeToFit];
    [self setNeedsLayout];
}

- (void) _initialize
{
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cafe_Epic_Panorama"]];
    [self addSubview:_backgroundImageView];

    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.font = [UIFont boldSystemFontOfSize:18.0];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor blueColor];
    _label.shadowColor = [UIColor blackColor];
    _label.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _label.text = NSLocalizedString(@"Loading...", @"Loading message of ONNMenuView");
    [_label sizeToFit];
    [self addSubview:_label];

    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    [_textView setEditable:NO];
    [_textView setDirectionalLockEnabled:YES];

    [self addSubview:_textView];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = 4.0f;
    CGFloat startX = floor((self.frame.size.width - _label.frame.size.width - margin)/2.0f);
    CGFloat labelY = 20.0f;
    CGFloat textViewY = labelY + _label.frame.size.height;
    _label.frame = CGRectMake(startX, labelY, _label.frame.size.width, _label.frame.size.height);
    _textView.frame = CGRectMake(margin, textViewY, self.frame.size.width - margin * 2, self.frame.size.height - textViewY);
    _backgroundImageView.frame = CGRectMake(0, labelY, self.frame.size.width, self.frame.size.height);
}

@end
