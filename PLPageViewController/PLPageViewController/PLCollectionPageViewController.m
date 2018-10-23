////
//  PLCollectionPageViewController.m
//  PLPageViewController
//
//  Created by ___Fitfun___ on 2018/10/22.
//Copyright © 2018年 penglei. All rights reserved.
//

#import "PLCollectionPageViewController.h"
#import "PLTtitleScrollView.h"
#import "PLContentScrollView.h"
#import "NewViewController.h"

@interface PLCollectionPageViewController ()<PLScrollViewDelegate,PLTitleDelegate>

@property(nonatomic, strong)PLTtitleScrollView *title_view;

@property(nonatomic, strong)PLContentScrollView *content_view;
@property(nonatomic, strong)NSArray *titleArray;
@property(nonatomic, strong)NSArray *viewControllers;
@property(nonatomic, assign)PLSegmentHeadStyle headStyle;

@end

@implementation PLCollectionPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"滑动标签";
   
    
    // Do any additional setup after loading the view.
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray<NSString *>*)titleArray
              viewControllers:(NSArray<UIViewController *>*)viewControllers
                    headStyle:(PLSegmentHeadStyle)style {
    if (self = [super init]) {
        self.view.frame = frame;
        self.titleArray = [titleArray copy];
        self.viewControllers = [viewControllers copy];
        self.headStyle = style;
        [self.view addSubview:self.title_view];
        [self.view addSubview:self.content_view];
    }
    
    return self;
    
}

- (PLTtitleScrollView *)title_view{
  
    if (!_title_view) {
        
        _title_view = [[PLTtitleScrollView alloc]initWithFrame:CGRectMake(0,self.view.frame.origin.y, self.view.frame.size.width, 50) title:self.titleArray headStyle:self.headStyle];
        _title_view.backgroundColor = [UIColor whiteColor];
        _title_view.delegate =self;
    }
    return _title_view;
}

- (PLContentScrollView *)content_view{
    
    if (!_content_view) {
        CGFloat height = self.title_view.frame.size.height+self.title_view.frame.origin.y;
        _content_view = [[PLContentScrollView alloc]initWithFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height-height) viewControllers:self.viewControllers];
        _content_view.delegate = self;
        _content_view.backgroundColor = [UIColor whiteColor];
    }
    return _content_view;
}
-(void)PLTapOffset:(NSInteger)currentIndex textLabel:(UILabel *)currentLab{
    
    
    [self.content_view PLContentOffsetWithIndex:currentIndex];
}
-(void)contentPagePorgess:(CGFloat)progress sourcLocation:(NSInteger)source targetLocation:(NSInteger)target{
    
    [self.title_view changeUnderLineFrameWithProgress:progress sourceViewTag:source targetViewTag:target];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
