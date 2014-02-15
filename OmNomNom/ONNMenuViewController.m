//
//  ONNMenuViewController.m
//  OmNomNom
//
//  Created by Paul Cavallaro on 2/13/14.
//
//

#import "ONNMenuViewController.h"

#import "ONNMenuViewController.h"
#import "UIImageView+LBBlurredImage.h"

@interface ONNMenuViewController ()

<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) NSDictionary *menu;
@property (nonatomic, strong) UILabel *cafeNameLabel;


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

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    self.view = contentView;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view setFrame:self.view.window.frame];
    
    

    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImage *background = [UIImage imageNamed:[ONNMenuUtils imageForCafe:self.cafeName]];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    self.blurredImageView.clipsToBounds = YES;
    [self.view addSubview:self.blurredImageView];
    
    UIView *backgroundMaskView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundMaskView.backgroundColor = [[UIColor alloc] initWithRed:0.1f green:0.1f blue:0.1f alpha:0.2f];
    backgroundMaskView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.screenHeight);
    [self.view addSubview:backgroundMaskView];
    
    self.tableView = [[UITableView alloc] init];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat summaryHeight = 210;
    
    CGRect summaryFrame= CGRectMake(inset,
                                         headerFrame.size.height - (summaryHeight),
                                         headerFrame.size.width - (2 * inset),
                                         summaryHeight);
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    

    self.summaryLabel = [[UILabel alloc] initWithFrame:summaryFrame];
    self.summaryLabel.backgroundColor = [UIColor clearColor];
    self.summaryLabel.textColor = [UIColor whiteColor];
    self.summaryLabel.numberOfLines = 0; //
    self.summaryLabel.shadowColor = [UIColor blackColor];
    self.summaryLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.summaryLabel.shadowColor = [UIColor blackColor];
    self.summaryLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    [self setSummaryText:@"Loading..."];
    [header addSubview:self.summaryLabel];
    
    UILabel *cafeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    cafeNameLabel.backgroundColor = [UIColor clearColor];
    cafeNameLabel.textColor = [UIColor whiteColor];
    cafeNameLabel.text = [ONNMenuUtils stringForCafe:self.cafeName];
    cafeNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cafeNameLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cafeNameLabel];
    
    [ONNMenuUtils getMenuForCafe:self.cafeName completion:^(NSDictionary * last_post) {
        [self setSummaryText:last_post[@"header"]];
        self.menu = last_post;
        
    }];
}

-(void)setSummaryText:(NSString *)text {
    self.summaryLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    self.summaryLabel.text = text;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
// 1
#pragma mark - UITableViewDataSource

// 2
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.menu == nil) {
        return 0;
    }
    
    return [self.menu[@"sections"] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // 3
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    
    cell.textLabel.numberOfLines = 0;

    cell.textLabel.text = [self getTextForCell:indexPath.row];
    [cell sizeToFit];
    
    return cell;
}

-(CGFloat)heightForText:(NSString *)text
{
    NSInteger MAX_HEIGHT = 2000;
    UITextView * textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MAX_HEIGHT)];
    textView.text = text;
    textView.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    [textView sizeToFit];
    return textView.frame.size.height;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: measure text to get this
    if (self.menu == nil) {
        return 50;
    }
    return [self heightForText:[self getTextForCell:indexPath.row]];
}

- (NSString *)getTextForCell:(NSInteger) row {
    if (row == 0) {
        return self.menu[@"header"];
    }
    
    NSDictionary *section = [self.menu[@"sections"] objectAtIndex:row - 1];
    NSString *menu = section[@"name"];
    menu = [menu stringByAppendingString:@"\n"];
    for (NSString * item in section[@"items"]) {
        menu = [menu stringByAppendingString:item];
        menu = [menu stringByAppendingString:@"\n"];
    }
    return menu;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    // 2
    CGFloat percent = MIN(position / height, 1.0);
    // 3
    self.blurredImageView.alpha = percent;
}




@end
