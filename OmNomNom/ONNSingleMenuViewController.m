//
//  ONNSingleMenuViewController.m
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/12/14.
//
//

#import "ONNSingleMenuViewController.h"
#import "ONNMenuUtils.h"

@interface ONNSingleMenuViewController ()

@end

@implementation ONNSingleMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ONNMenuUtils getMenuForCafe:self.cafeName completion:^(NSString * last_post) {
        self.textView.text = last_post;
        
        // Bug? http://stackoverflow.com/questions/19049917/uitextview-font-is-being-reset-after-settext
        [self.textView setFont:[UIFont systemFontOfSize:16.0]];
    }];
    switch (self.cafeName) {
        case SEA:
            self.label.text = @"Bits & Bytes (Seattle)";
            break;
        case EPIC:
            self.label.text = @"Epic (MPK)";
            break;
        case LTD:
            self.label.text = @"Livin' The Dream (MPK)";
            break;
        case NYC:
            self.label.text = @"Yolo Café (NYC)";
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
