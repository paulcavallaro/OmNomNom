//
//  ONNMenuViewController.m
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/12/14.
//
//

#import "ONNMenuViewController.h"
#import <Parse/Parse.h>

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
    
    
    [FBRequestConnection startWithGraphPath:@"fbnyccafe/posts"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSString *last_post= [(NSArray *)[result data] objectAtIndex:0][@"message"];
                                  UITextView *textView = [[UITextView alloc] init];
                                  [textView setText:last_post];
                                  [self.menuScrolView addSubview:textView];
                                  textView.frame = self.menuScrolView.frame;
                                  //[self.menuScrolView sett
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
