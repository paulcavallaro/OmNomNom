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

- (id)init
{
    self = [super init];
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
    [ONNMenuUtils getMenuForCafe:self.cafeName completion:^(NSDictionary * last_post) {
        [self.view setCafeName:[ONNMenuUtils stringForCafe:self.cafeName] andMenu:last_post andImage:[ONNMenuUtils imageForCafe:self.cafeName]];
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
