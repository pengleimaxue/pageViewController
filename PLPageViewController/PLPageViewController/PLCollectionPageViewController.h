////
//  PLCollectionPageViewController.h
//  PLPageViewController
//
//  Created by ___Fitfun___ on 2018/10/22.
//Copyright © 2018年 penglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLTtitleScrollView.h"

@interface PLCollectionPageViewController : UIViewController

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray<NSString *>*)titleArray
              viewControllers:(NSArray<UIViewController *>*)viewControllers
                    headStyle:(PLSegmentHeadStyle)style;

@end
