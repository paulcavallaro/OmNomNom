//
//  ONNSingleMenuViewController.h
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/12/14.
//
//

#import <UIKit/UIKit.h>

@interface ONNSingleMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) int idx;

@end
