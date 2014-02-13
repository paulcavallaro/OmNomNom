//
//  ONNMainViewController.m
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/12/14.
//
//

#import "ONNMainViewController.h"
#import "ONNMenuViewController.h"
#import "ONNMenuUtils.h"

@interface ONNMainViewController ()

@end

@implementation ONNMainViewController

const int kNumMenus = SEA + 1;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.pageController.dataSource = self;
    [self.pageController.view setFrame:self.view.frame];
    [self.pageController.view setBackgroundColor:[UIColor whiteColor]];

    NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:0 withFrame:self.view.frame]];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];

    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UIPageViewControllerDataSource
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return SEA + 1;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (ONNMenuViewController *)viewControllerAtIndex:(NSUInteger)index withFrame:(CGRect)frame {
    ONNMenuViewController *singleMenuVC = [[ONNMenuViewController alloc] init];
    singleMenuVC.idx = index;
    singleMenuVC.cafeName = (CafeName)index;
    singleMenuVC.view.frame = frame;

    return singleMenuVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    const int index = ((ONNMenuViewController *)viewController).idx;
    if (index == kNumMenus - 1) {
        return nil;
    } else {
        return [self viewControllerAtIndex:(index+1) withFrame:self.view.frame];
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    const int index = ((ONNMenuViewController *)viewController).idx;
    if (index == 0) {
        return nil;
    } else {
        return [self viewControllerAtIndex:(index-1) withFrame:pageViewController.view.frame];
    }
}

@end
