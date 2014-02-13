//
//  ONNMenuViewController.h
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/13/14.
//
//

#import <UIKit/UIKit.h>
#import "ONNMenuView.h"
#import "ONNMenuUtils.h"

@interface ONNMenuViewController : UIViewController

@property (nonatomic) int idx;
@property (nonatomic) CafeName cafeName;
@property (nonatomic) ONNMenuView *view;

@end
