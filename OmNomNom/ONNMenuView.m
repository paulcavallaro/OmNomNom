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
UILabel *_summary;
BOOL _menuOpen = NO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void) setCafeName:(NSString *)cafeName andMenu:(NSDictionary *)menu
{
    _label.text = cafeName;
    _textView.text = [self getMenuAsString:menu];
    _textView.font = [UIFont systemFontOfSize:16.0];
    [_label sizeToFit];
    [_textView sizeToFit];
    [self setNeedsLayout];
    _summary.text = menu[@"header"];
}

- (void) _initialize
{
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cafe_Epic_Panorama"]];
    [self addSubview:_backgroundImageView];

    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.font = [UIFont boldSystemFontOfSize:18.0];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor whiteColor];
    _label.shadowColor = [UIColor blackColor];
    _label.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _label.shadowColor = [UIColor blackColor];
    _label.shadowOffset = CGSizeMake(0.0, 1.0);
    _label.text = NSLocalizedString(@"Loading...", @"Loading message of ONNMenuView");
    [_label sizeToFit];
    [self addSubview:_label];
    
    _summary = [[UILabel alloc] initWithFrame:CGRectZero];
    _summary.text = @"Loading...";
    _summary.font = [UIFont boldSystemFontOfSize:18.0];
    _summary.textColor = [UIColor whiteColor];
    _summary.shadowColor = [UIColor blackColor];
    _summary.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _summary.shadowColor = [UIColor blackColor];
    _summary.shadowOffset = CGSizeMake(0.0, 1.0);
    _summary.numberOfLines = 0; // wrap
    [self addSubview:_summary];
    
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    [_textView setEditable:NO];
    [_textView setDirectionalLockEnabled:YES];

}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = 4.0f;
    CGFloat startX = floor((self.frame.size.width - _label.frame.size.width - margin)/2.0f);
    CGFloat labelY = 25.0f;
    CGFloat textViewY = labelY + _label.frame.size.height;
    _label.frame = CGRectMake(startX, labelY, _label.frame.size.width, _label.frame.size.height);
    _textView.frame = CGRectMake(margin, textViewY, self.frame.size.width - margin * 2, self.frame.size.height - textViewY);
    _backgroundImageView.frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height);
    _summary.frame = CGRectMake(20, 360, 200, 80);

}

-(NSString *)getMenuAsString:(NSDictionary *)menu_json {
    NSString *menu = @"";
    menu = [menu stringByAppendingString:menu_json[@"header"]];
    menu = [menu stringByAppendingString:@"\n"];
    menu = [menu stringByAppendingString:@"\n"];
    
    for (NSDictionary * section in menu_json[@"sections"]) {
        menu = [menu stringByAppendingString:section[@"name"]];
        menu = [menu stringByAppendingString:@"\n"];
        for (NSString * item in section[@"items"]) {
            menu = [menu stringByAppendingString:item];
            menu = [menu stringByAppendingString:@"\n"];
        }
        menu = [menu stringByAppendingString:@"\n"];
        
    }
    
    return menu;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (CGRectContainsPoint(_summary.frame, [touch locationInView:self]))
    {
        [_summary removeFromSuperview];
        

         
         [self addSubview:_textView];
    }
}

@end
