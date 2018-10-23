//
//  JCLContentScrollView.h
//  NBTest
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 panzihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@protocol PLScrollViewDelegate<NSObject>

@required

- (void)contentPagePorgess:(CGFloat)progress sourcLocation:(NSInteger)source targetLocation:(NSInteger)target;

@end

@interface PLContentScrollView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>


- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray <UIViewController *>*)pages;

- (void)PLContentOffsetWithIndex:(NSInteger)index;

@property(nonatomic,weak)id<PLScrollViewDelegate>delegate;

@end

