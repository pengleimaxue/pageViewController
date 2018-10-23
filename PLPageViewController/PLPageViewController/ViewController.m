////
//  ViewController.m
//  PLPageViewController
//
//  Created by ___Fitfun___ on 2018/10/22.
//Copyright © 2018年 penglei. All rights reserved.
//

#import "ViewController.h"
#import "PLPageViewController.h"
#import "PLCollectionPageViewController.h"
#import "NewViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)page1Button:(id)sender {
    [self.navigationController pushViewController:[[PLPageViewController alloc] init] animated:YES];
}

- (IBAction)page2Button:(id)sender {
    [self.navigationController pushViewController:[self PLCollectionPageViewControllerWithType:0] animated:YES];

}

- (IBAction)page3Button:(id)sender {
     [self.navigationController pushViewController:[self PLCollectionPageViewControllerWithType:3] animated:YES];
}

- (IBAction)page4Button:(id)sender {
     [self.navigationController pushViewController:[self PLCollectionPageViewControllerWithType:1] animated:YES];
}


- (IBAction)page5Button:(id)sender {
     [self.navigationController pushViewController:[self PLCollectionPageViewControllerWithType:2] animated:YES];
}

- (PLCollectionPageViewController *)PLCollectionPageViewControllerWithType:(NSUInteger)type {
    NSArray *title = @[
                       @"标题1",
                       @"标题2",
                       @"标题3",
                       @"标题4",
                       @"标题5",
                       @"标题6",
                       @"标题7",
                       @"标题8",
                       @"标题9",
                       @"标题10",
                       @"标题11",
                       @"标题12",
                       @"标题13",
                       @"标题14",
                       @"标题15"];
    NSArray *viewControllers = @[
                                 [[NewViewController alloc]initWithCount:1 backGroundColor:[UIColor redColor]],
                                 [[NewViewController alloc]initWithCount:2 backGroundColor:[UIColor yellowColor]],
                                 [[NewViewController alloc]initWithCount:3 backGroundColor:[UIColor grayColor]],
                                 [[NewViewController alloc]initWithCount:4 backGroundColor:[UIColor blueColor]],
                                 [[NewViewController alloc]initWithCount:5 backGroundColor:[UIColor orangeColor]],
                                 [[NewViewController alloc]initWithCount:6 backGroundColor:[UIColor brownColor]],
                                 [[NewViewController alloc]initWithCount:7 backGroundColor:[UIColor blackColor]],
                                 [[NewViewController alloc]initWithCount:8 backGroundColor:[UIColor lightGrayColor]],
                                 [[NewViewController alloc]initWithCount:9 backGroundColor:[UIColor redColor]],
                                 [[NewViewController alloc]initWithCount:10 backGroundColor:[UIColor blackColor]],
                                 [[NewViewController alloc]initWithCount:11 backGroundColor:[UIColor grayColor]],
                                 [[NewViewController alloc]initWithCount:12 backGroundColor:[UIColor blueColor]],
                                 [[NewViewController alloc]initWithCount:13 backGroundColor:[UIColor grayColor]],
                                 [[NewViewController alloc]initWithCount:14 backGroundColor:[UIColor orangeColor]],
                                 [[NewViewController alloc]initWithCount:15 backGroundColor:[UIColor blueColor]]
                                 ];
      CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
      CGFloat navRectHeight = self.navigationController.navigationBar.frame.size.height;
    CGRect frame = self.view.frame;
    frame.origin.y = statusHeight+navRectHeight;
    //frame.size.height -= statusHeight+navRectHeight;
    PLCollectionPageViewController *viewController = [[PLCollectionPageViewController alloc] initWithFrame:frame titleArray:title viewControllers:viewControllers headStyle:type];
    return viewController;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
