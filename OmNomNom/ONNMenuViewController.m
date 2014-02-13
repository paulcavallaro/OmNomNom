//
//  ONNMenuViewController.m
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/13/14.
//
//

#import "ONNMenuViewController.h"
#import "ONNMenuView.h"

@interface ONNMenuViewController ()

@end

@implementation ONNMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    // Custom initialization
}

- (void)loadView
{
    ONNMenuView *menuView = [[ONNMenuView alloc] init];
    self.view = menuView;
    [ONNMenuUtils getMenuForCafe:self.cafeName completion:^(NSString * last_post) {
        NSString *more_post = [last_post stringByAppendingString:last_post];
        [self.view setCafeName:[ONNMenuUtils stringForCafe:self.cafeName] andMenu:more_post];
        [self.view setNeedsLayout];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:self.view.window.frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
