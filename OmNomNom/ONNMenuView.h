//
//  ONNMenuView.h
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/12/14.
//
//

#import <UIKit/UIKit.h>

@interface ONNMenuView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *menu;
@property (weak, nonatomic) IBOutlet UILabel *cafeLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
