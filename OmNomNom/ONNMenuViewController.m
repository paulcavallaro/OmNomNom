//
//  ONNMenuViewController.m
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/12/14.
//
//

#import "ONNMenuViewController.h"
#import <Parse/Parse.h>
#import "ONNMenuUtils.h"

@interface ONNMenuViewController ()

@end

@implementation ONNMenuViewController

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
	// Do any additional setup after loading the view.
    
    [ONNMenuUtils getMenu:^(NSString * last_post) {
        if (YES){//!error) {
            // Sucess! Include your code to handle the results here
            self.menuTextView.text = last_post;
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];

}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.menuScrollView.frame.size.width;
    int page = floor((self.menuScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.menuPageControl.currentPage = page;
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.menuScrollView.frame.size.width * self.menuPageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.menuScrollView.frame.size;
    [self.menuScrollView scrollRectToVisible:frame animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
