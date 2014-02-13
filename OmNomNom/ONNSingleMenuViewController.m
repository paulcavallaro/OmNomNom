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
    [ONNMenuUtils getMenu:^(NSString * last_post) {
        self.textView.text = last_post;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
