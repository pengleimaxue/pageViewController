////
//  PLBasePageViewController.h
//  PLPageViewController
//
//  Created by ___Fitfun___ on 2018/10/22.
//Copyright © 2018年 penglei. All rights reserved.
//使用UIPageViewController一个实现滑动标签视图的方法

#import <UIKit/UIKit.h>

@class PLBasePageViewController;

@protocol PLBasePageControllerDelegate <NSObject>

@optional
///返回当前显示的视图控制器
-(void)viewPagerViewController:(PLBasePageViewController *)viewPager didFinishScrollWithCurrentViewController:(UIViewController *)viewController;
///返回当前将要滑动的视图控制器
-(void)viewPagerViewController:(PLBasePageViewController *)viewPager willScrollerWithCurrentViewController:(UIViewController *)ViewController;

@end

#pragma mark View Pager DataSource
@protocol PLBasePageControllerDataSource <NSObject>

@required

-(NSInteger)numberViewControllersInViewPager:(PLBasePageViewController *)viewPager;
-(UIViewController *)viewPager:(PLBasePageViewController *)viewPager indexViewControllers:(NSInteger)index;
-(NSString *)viewPager:(PLBasePageViewController *)viewPager titleWithIndexViewControllers:(NSInteger)index;

@optional
///设置控制器标题按钮的样式,不设置为默认
-(UIButton *)viewPager:(PLBasePageViewController *)viewPager titleButtonStyle:(NSInteger)index;
-(CGFloat)heightForTitleViewPager:(PLBasePageViewController *)viewPager;
///预留数据源
-(UIView *)headerViewForInViewPager:(PLBasePageViewController *)viewPager;
-(CGFloat)heightForHeaderViewPager:(PLBasePageViewController *)viewPager;

@end

@interface PLBasePageViewController : UIViewController

@property (nonatomic, weak) id<PLBasePageControllerDataSource> dataSource;
@property (nonatomic, weak) id<PLBasePageControllerDelegate> delegate;
///刷新
-(void)reloadScrollPage;
///默认选中
@property(nonatomic,assign) NSInteger selectIndex;
///按钮下划线的高度 字体大小 默认颜色 选中颜色
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *chooseColor;

@end

#pragma mark 标题按钮
@interface PLBasePageTitleButton : UIButton

@property (nonatomic, assign) CGFloat buttonlineWidth;

@end
