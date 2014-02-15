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

@implementation ONNMainViewController {
    NSMutableArray *viewArray;
}

const int kNumMenus = LTD + 1;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    viewArray = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < kNumMenus; i++)
    {
        [viewArray addObject:[NSNull null]];
    }
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    // +40 because of paging control at bottom, don't need that
    self.pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+40);

    self.pageController.dataSource = self;
    [self.pageController.view setBackgroundColor:[UIColor blackColor]];

    NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:0 withFrame:self.view.frame]];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];

    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (BOOL)prefersStatusBarHidden
{
    // Make full screen baby!
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UIPageViewControllerDataSource
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return LTD + 1;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (ONNMenuViewController *)viewControllerAtIndex:(NSUInteger)index withFrame:(CGRect)frame {
    if ([viewArray[index] isEqual:[NSNull null]]) {
        ONNMenuViewController *singleMenuVC = [[ONNMenuViewController alloc] init];
        singleMenuVC.idx = index;
        singleMenuVC.cafeName = (CafeName)index;
        //singleMenuVC.view.frame = frame;
        viewArray[index] = singleMenuVC;
    }

    return viewArray[index];
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
