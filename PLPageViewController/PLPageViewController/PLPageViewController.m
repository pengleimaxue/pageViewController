////
//  PLPageViewController.m
//  PLPageViewController
//
//  Created by ___Fitfun___ on 2018/10/22.
//Copyright © 2018年 penglei. All rights reserved.
//

#import "PLPageViewController.h"

@interface PLPageViewController ()<PLBasePageControllerDelegate,PLBasePageControllerDataSource>

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) UIView *headerView;


@end

@implementation PLPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArray = @[@"全部",@"推荐",@"全部",@"推荐",@"全部",@"推荐",@"全部",@"推荐",@"全部",@"推荐"];
    self.delegate = self;
    self.dataSource = self;
    self.lineWidth = 2.0;//选中下划线宽度
    self.titleFont = [UIFont systemFontOfSize:16.0];
    self.defaultColor = [UIColor blackColor];//默认字体颜色
    self.chooseColor = [UIColor blueColor];//选中字体颜色
    self.selectIndex = 1;//默认选中第几页
    [self reloadScrollPage];
    // Do any additional setup after loading the view.
}

-(NSInteger)numberViewControllersInViewPager:(PLBasePageViewController *)viewPager
{
    return _titleArray.count;
}


-(UIViewController *)viewPager:(PLBasePageViewController *)viewPager indexViewControllers:(NSInteger)index
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    if (index%2) {
        vc.view.backgroundColor = [UIColor yellowColor];
    }
    return vc;
}

-(CGFloat)heightForTitleViewPager:(PLBasePageViewController *)viewPager
{
    return 50;
}

-(NSString *)viewPager:(PLBasePageViewController *)viewPager titleWithIndexViewControllers:(NSInteger)index
{
    return self.titleArray[index];
}
-(void)viewPagerViewController:(PLBasePageViewController *)viewPager didFinishScrollWithCurrentViewController:(UIViewController *)viewController {
    self.title = viewController.title;
}
#pragma mark 预留--可不实现

//- (UIView *)headerViewForInViewPager:(PLBasePageViewController *)viewPager {
//    return self.headerView;
//}

- (CGFloat)heightForHeaderViewPager:(PLBasePageViewController *)viewPager {
    return 100;
}


-(UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithRed:120/255.0f green:210/255.0f blue:249/255.0f alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 40)];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.text = @"固定的头View,不可跟随滑动,可不显示";
        label.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:label];
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
