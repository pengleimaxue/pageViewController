//
//  PLTtitleScrollView.h
//  PLPageViewController
//
//  Created by apple on 2018/10/23.
//  Copyright © 2018年 penglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLTitleDelegate <NSObject>

@required

-(void)PLTapOffset:(NSInteger)currentIndex textLabel:(UILabel *)currentLab;

@end

typedef enum:NSUInteger {
    /**
     *  默认
     */
    SegmentHeadStyleDefault,
    /**
     *  line(下划线)
     */
    SegmentHeadStyleLine,
    /**
     *  arrow(箭头)
     */
    SegmentHeadStyleArrow,
    /**
     *  Slide(滑块)
     */
    SegmentHeadStyleSlide
} PLSegmentHeadStyle;


@interface PLTtitleScrollView : UIView

@property(nonatomic, strong) UIScrollView *scrollview;

@property(nonatomic, strong) NSArray <NSString *>*titles;
/**
 设置 箭头 ，滑块,下划线的颜色
 **/
@property(nonatomic, strong) UIColor *headViewColor;

/**
 设置默认字体颜色
 */
@property(nonatomic, strong) UIColor *defaultTextColor;

/**
设置选择状态下字体颜色
 */
@property(nonatomic, strong)UIColor *selectTextColor;

@property(nonatomic, weak) id<PLTitleDelegate>delegate;

/**
   初始化数组

 @param frame frame
 @param titles 标题数组
 @return  object
 */
-  (instancetype)initWithFrame:(CGRect)frame
                         title:(NSArray *)titles
                     headStyle:(PLSegmentHeadStyle)style;

/**
 改变下标

 @param progrss 进度
 @param source  源label角标位置
 @param target  将要一定的角标位置
 */
- (void)changeUnderLineFrameWithProgress:(CGFloat)progrss sourceViewTag:(NSInteger)source targetViewTag:(NSInteger)target;


/**
 滚动到指定位置

 @param index 索引
 */
- (void)scrollToindex:(NSInteger)index;

@end
