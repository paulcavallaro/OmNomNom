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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.backgroundColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"Loading...", @"Loading message of ONNMenuView");
    [label sizeToFit];
    _label = label;
    [self addSubview:_label];

    UITextView *textView = [[UITextView alloc] initWithFrame:self.frame];
    [textView setEditable:NO];
    [textView setDirectionalLockEnabled:YES];
    _textView = textView;

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
}

@end
