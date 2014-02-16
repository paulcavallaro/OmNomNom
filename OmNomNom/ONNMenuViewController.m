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

    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImage *background = [UIImage imageNamed:[ONNMenuUtils imageForCafe:self.cafeName]];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    UIView *backgroundMaskView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundMaskView.backgroundColor = [[UIColor alloc] initWithRed:0.1f green:0.1f blue:0.1f alpha:0.4f];

    backgroundMaskView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.screenHeight);
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:backgroundMaskView];

    self.tableView = [[UITableView alloc] init];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [ONNMenuUtils getMenuForCafe:self.cafeName completion:^(NSDictionary * last_post) {
        if (last_post != nil) {
            [self setSummaryText:last_post[@"header"]];
            self.menu = last_post;
        } else {
            // last_post == nil means we failed to download or read from disk
            // tel the user there was an error and ask to pull to refresh
            self.menu = @{@"header": @"Error Loading"};
        }
        
    }];
}

-(void)setSummaryText:(NSString *)text {
    self.summaryLabel.font = [self getHeaderFont];
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
    
    return [self.menu[@"sections"] count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.textLabel.font = [self getHeaderFont];
    } else {
        cell.textLabel.font = [self getItemFont];
    }
    cell.textLabel.text = [self getTextForCell:indexPath.row];
    
    cell.textLabel.numberOfLines = 0;

    [cell sizeToFit];
    
    return cell;
}

-(CGFloat)heightForText:(NSString *)text font:(UIFont *)font
{
    NSInteger MAX_HEIGHT = 20000;
    UITextView * textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MAX_HEIGHT)];
    textView.text = text;
    textView.font = font;
    [textView sizeToFit];
    NSLog(@"%f", textView.frame.size.height);
    return textView.frame.size.height;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: measure text to get this
    if (self.menu == nil) {
        return 50;
    }
    UIFont *font;
    if (indexPath.row == 0) {
        font = [self getHeaderFont];
    } else {
        font = [self getItemFont];
    }
    return [self heightForText:[self getTextForCell:indexPath.row] font:font];
}

- (NSString *)getTextForCell:(NSInteger) row {
    if (row == 0) {
        return [ONNMenuUtils stringForCafe:self.cafeName];
        return self.menu[@"header"];
    }
    
    if (row == 1) {
        return self.menu[@"header"];
    }
    
    NSDictionary *section = [self.menu[@"sections"] objectAtIndex:row - 2];
    NSString *menu = section[@"name"];
    menu = [menu stringByAppendingString:@"\n"];
    menu = [menu stringByAppendingString:[section[@"items"] componentsJoinedByString:@"\n"]];
    return menu;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

-(UIFont *)getHeaderFont {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
}

-(UIFont *)getItemFont {
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
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
