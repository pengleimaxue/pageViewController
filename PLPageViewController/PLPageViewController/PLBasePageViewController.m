////
//  PLBasePageViewController.m
//  PLPageViewController
//
//  Created by ___Fitfun___ on 2018/10/22.
//Copyright © 2018年 penglei. All rights reserved.
//

#import "PLBasePageViewController.h"

@interface PLBasePageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, assign) NSInteger totalVCNumber;
@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) NSArray *buttonArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGRect oldRect;
@property (nonatomic, strong) PLBasePageTitleButton *oldButton;
@property (nonatomic, assign) NSInteger currentVCIndex;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIScrollView *titleBGScroll;

@end

@implementation PLBasePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lineWidth = self.lineWidth>0?self.lineWidth:1.5;
    self.titleFont = self.titleFont?self.titleFont:[UIFont systemFontOfSize:14.0];
    self.defaultColor = self.defaultColor?self.defaultColor:[UIColor blackColor];
    self.chooseColor = self.chooseColor?self.chooseColor:[UIColor redColor];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view addSubview:self.titleBGScroll];
    // Do any additional setup after loading the view.
}

-(UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

-(UIScrollView *)titleBGScroll {
    if (!_titleBGScroll) {
        _titleBGScroll = [[UIScrollView alloc] init];
        _titleBGScroll.backgroundColor = [UIColor whiteColor];
        _titleBGScroll.showsHorizontalScrollIndicator = NO;
        _titleBGScroll.showsVerticalScrollIndicator = NO;
    }
    return _titleBGScroll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDataSource:(id<PLBasePageControllerDataSource>)dataSource {
    _dataSource = dataSource;
    //[self reloadScrollPage];
}
-(void)reloadScrollPage
{
    if ([self.dataSource respondsToSelector:@selector(numberViewControllersInViewPager:)]) {
        _oldRect = CGRectZero;
        _totalVCNumber = [self.dataSource numberViewControllersInViewPager:self];
        NSMutableArray *VCList = [NSMutableArray array];
        NSMutableArray *buttonList = [NSMutableArray array];
        for (int i = 0; i<_totalVCNumber; i++) {
            if ([self.dataSource respondsToSelector:@selector(viewPager:indexViewControllers:)]) {
                id viewcontroller = [self.dataSource viewPager:self indexViewControllers:i];
                if ([viewcontroller isKindOfClass:[UIViewController class]]) {
                    [VCList addObject:viewcontroller];
                }
            }
            if ([self.dataSource respondsToSelector:@selector(viewPager:titleWithIndexViewControllers:)]) {
                NSString *buttonTitle = [self.dataSource viewPager:self titleWithIndexViewControllers:i];
                if (self.buttonArray.count > i) {
                    [[self.buttonArray objectAtIndex:i] removeFromSuperview];
                }
                UIButton *button;
                if ([self.dataSource respondsToSelector:@selector(viewPager:titleButtonStyle:)]) {
                    if ([[self.dataSource viewPager:self titleButtonStyle:i] isKindOfClass:[UIButton class]]) {
                        button = [self.dataSource viewPager:self titleButtonStyle:i];
                    }
                }else{
                    PLBasePageTitleButton *autoButton = [[PLBasePageTitleButton alloc] init];
                    autoButton.buttonlineWidth = self.lineWidth;
                    [autoButton.titleLabel setFont:self.titleFont];
                    [autoButton setTitleColor:self.defaultColor forState:UIControlStateNormal];
                    [autoButton setTitleColor:self.chooseColor forState:UIControlStateSelected];
                    button = autoButton;
                }
                [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                button.frame = CGRectMake(_oldRect.origin.x+_oldRect.size.width, 0, [self textString:buttonTitle withFontHeight:20], [self.dataSource respondsToSelector:@selector(heightForTitleViewPager:)]?[self.dataSource heightForTitleViewPager:self]:0);
                _oldRect = button.frame;
                [button setTitle:buttonTitle forState:UIControlStateNormal];
                [buttonList addObject:button];
                [_titleBGScroll addSubview:button];
                if (i == self.selectIndex) {
                    _oldButton = [buttonList objectAtIndex:self.selectIndex];
                    _oldButton.selected = YES;
                }
            }
        }
        //当所有按钮尺寸小于屏幕宽度的时候要重新布局
        if (buttonList.count && ((UIButton *)buttonList.lastObject).frame.origin.x + ((UIButton *)buttonList.lastObject).frame.size.width<self.view.frame.size.width) {
            _oldRect = CGRectZero;
            CGFloat padding = self.view.frame.size.width-(((UIButton *)buttonList.lastObject).frame.origin.x + ((UIButton *)buttonList.lastObject).frame.size.width);
            for (PLBasePageTitleButton *button in buttonList) {
                button.frame = CGRectMake(_oldRect.origin.x+_oldRect.size.width, 0,button.frame.size.width+padding/buttonList.count, [self.dataSource respondsToSelector:@selector(heightForTitleViewPager:)]?[self.dataSource heightForTitleViewPager:self]:0);
                _oldRect = button.frame;
            }
        }
        self.buttonArray = [buttonList copy];
        self.vcArray= [VCList copy];
    }
    if ([self.dataSource respondsToSelector:@selector(headerViewForInViewPager:)]) {
        [_headerView removeFromSuperview];
        _headerView = [self.dataSource headerViewForInViewPager:self];
        [self.view addSubview:_headerView];
    }
    if (self.vcArray.count) {
        [_pageViewController setViewControllers:@[self.vcArray[self.selectIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

-(void)titleButtonClick:(PLBasePageTitleButton *)sender {
    self.oldButton.selected = NO;
    sender.selected = YES;
    self.oldButton = sender;
    NSInteger index = [self.buttonArray indexOfObject:sender];
    [_pageViewController setViewControllers:@[self.vcArray[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self scrollViewOffset:sender];
}

-(void)titleButtonConvert:(PLBasePageTitleButton *)sender {
    self.oldButton.selected = NO;
    sender.selected = YES;
    self.oldButton = sender;
    [self scrollViewOffset:sender];
}
-(void)scrollViewOffset:(UIButton *)button {
    if (!(_titleBGScroll.contentSize.width>CGRectGetWidth(self.view.frame))) {
        return;
    }
    if (CGRectGetMidX(button.frame)>CGRectGetMidX(self.view.frame)) {
        if (_titleBGScroll.contentSize.width<CGRectGetMaxX(self.view.frame)/2+CGRectGetMidX(button.frame)) {
            [_titleBGScroll setContentOffset:CGPointMake(_titleBGScroll.contentSize.width-CGRectGetWidth(self.view.frame), 0) animated:YES];
        }
        else{
            [_titleBGScroll setContentOffset:CGPointMake(CGRectGetMidX(button.frame)-CGRectGetWidth(self.view.frame)/2, 0) animated:YES];
        }
    }
    else{
        [_titleBGScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
#pragma mark -UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        if (self.currentVCIndex != [self.vcArray indexOfObject:previousViewControllers[0]]) {
            [self chooseTitleIndex:self.currentVCIndex];
            if ([self.delegate respondsToSelector:@selector(viewPagerViewController:didFinishScrollWithCurrentViewController:)]) {
                [self.delegate viewPagerViewController:self didFinishScrollWithCurrentViewController:[self.vcArray objectAtIndex:self.currentVCIndex]];
            }
        }
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    _currentVCIndex = [self.vcArray indexOfObject:pendingViewControllers[0]];
    if ([self.delegate respondsToSelector:@selector(viewPagerViewController:willScrollerWithCurrentViewController:)]) {
        [self.delegate viewPagerViewController:self willScrollerWithCurrentViewController:pageViewController.viewControllers[0]];
    }
}
#pragma mark -UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.vcArray indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }else{
        return self.vcArray[--index];
    }
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.vcArray indexOfObject:viewController];
    if (index == _vcArray.count-1 || index == NSNotFound) {
        return nil;
    }else{
        return self.vcArray[++index];
    }
}
-(void)chooseTitleIndex:(NSInteger)index
{
    [self titleButtonConvert:self.buttonArray[index]];
}
-(void)viewDidLayoutSubviews {
    self.headerView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.frame.size.width,[self.dataSource respondsToSelector:@selector(heightForHeaderViewPager:)]?[self.dataSource heightForHeaderViewPager:self]:0);
    _titleBGScroll.frame = CGRectMake(0, (_headerView.frame.size.height)?_headerView.frame.origin.y+_headerView.frame.size.height:self.topLayoutGuide.length, self.view.frame.size.width,[self.dataSource respondsToSelector:@selector(heightForTitleViewPager:)]?[self.dataSource heightForTitleViewPager:self]:0);
    if (_buttonArray.count) {
        _titleBGScroll.contentSize = CGSizeMake(((UIButton *)self.buttonArray.lastObject).frame.size.width+((UIButton *)self.buttonArray.lastObject).frame.origin.x, _titleBGScroll.frame.size.height);
    }
    _pageViewController.view.frame = CGRectMake(0, _titleBGScroll.frame.origin.y+_titleBGScroll.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(_titleBGScroll.frame.origin.y+_titleBGScroll.frame.size.height));
}

#pragma mark 计算字体宽度
-(CGFloat)textString:(NSString *)text withFontHeight:(CGFloat)height
{
    CGFloat padding = 20;
    NSDictionary *fontAttribute = @{NSFontAttributeName : self.titleFont};
    CGSize fontSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:fontAttribute context:nil].size;
    return fontSize.width+padding;
}

@end

#pragma mark 标题按钮的属性设置
@implementation PLBasePageTitleButton

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)drawRect:(CGRect)rect {
    if (self.selected) {
        CGFloat lineWidth = 1.0;
        CGColorRef color = self.titleLabel.textColor.CGColor;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, color);
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextMoveToPoint(ctx, 0, self.frame.size.height-lineWidth);
        CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height-lineWidth);
        CGContextStrokePath(ctx);
    }
}
@end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

