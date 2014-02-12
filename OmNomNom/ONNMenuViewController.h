//
//  ONNMenuViewController.h
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/12/14.
//
//

#import <UIKit/UIKit.h>

@interface ONNMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *cafeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *menuPageControl;
@property (weak, nonatomic) IBOutlet UITextView *menuTextView;

- (IBAction)changePage;

@end
