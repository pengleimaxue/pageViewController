//
//  PLTtitleScrollView.m
//  PLPageViewController
//
//  Created by apple on 2018/10/23.
//  Copyright © 2018年 penglei. All rights reserved.
//

#import "PLTtitleScrollView.h"

#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

static CGFloat arrow_H = 16;//箭头高
static CGFloat arrow_W = 28;//箭头宽
static CGFloat textLabel_H = 48;//文字高度

@interface PLTtitleScrollView ()

@property(nonatomic, strong) NSMutableArray <UILabel *>*titleLabes;

@property(nonatomic, assign) NSInteger currentIndex;

//下划线View
@property(nonatomic, strong) UIView *under_line;

//箭头layer
@property(nonatomic, strong) CAShapeLayer *arrow_layer;

//滑块View
@property(nonatomic, strong) UIView *slideView;

@property(nonatomic, assign)PLSegmentHeadStyle headStyle;

@end

@implementation PLTtitleScrollView

- (instancetype)initWithFrame:(CGRect)frame
                       title:(NSArray <NSString *>*)titles
                   headStyle:(PLSegmentHeadStyle)style {
    
    if (self = [super initWithFrame:frame]) {
        
        self.titles = titles;
        self.headStyle = style;
        [self initStytle];
        [self setUI:titles];
    }
    
    return self;
}

- (void)setUI:(NSArray <NSString *>*)titles {
   
    [self addSubview:self.scrollview];
   
    for (int i=0; i<titles.count; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*self.bounds.size.width/5, 0, self.bounds.size.width/5, textLabel_H)];
        label.text = titles[i];
        label.tag = i;
        label.textAlignment = 1;
        if (self.headStyle == SegmentHeadStyleDefault && i ==0) {
             label.font = [UIFont systemFontOfSize:20];
        } else {
            label.font = [UIFont systemFontOfSize:16];
        }
       
        label.userInteractionEnabled = YES;
        label.textColor = i!=0? RGB(85.0, 85.0, 85.0): RGB(255.0, 128.0, 0.0);
        [self.scrollview addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
        [label addGestureRecognizer:tap];
        [self.titleLabes addObject:label];
        self.scrollview.contentSize = CGSizeMake(CGRectGetMaxX(label.frame), 0);
    }
    if (self.headStyle == SegmentHeadStyleDefault) {
        return;
    }
    if (self.headStyle == SegmentHeadStyleSlide) {
        [self.scrollview addSubview:self.slideView];
    } else {
        [self.scrollview addSubview:self.under_line];
    }
}

- (void)initStytle {
    
    if (self.headStyle == SegmentHeadStyleSlide) {
        self.headViewColor= [UIColor lightGrayColor];
    } else {
        self.headViewColor = [UIColor redColor];
    }
    self.defaultTextColor = RGB(85.0, 85.0, 85.0);
    self.selectTextColor = RGB(255.0, 128.0, 0.0);
}



#pragma mark -getter&&setter

- (NSMutableArray *)titleLabes {
    
    if (!_titleLabes) {
        _titleLabes = @[].mutableCopy;
    }
    return _titleLabes;
}

- (UIScrollView *)scrollview {
    
    if (!_scrollview) {
        
        _scrollview = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollview.scrollsToTop = NO;
        _scrollview.bounces = NO;
        _scrollview.showsHorizontalScrollIndicator = false;
    }
    
    return _scrollview;
}

- (UIView *)under_line {
    if (!_under_line) {
        _under_line = [[UIView alloc]initWithFrame:CGRectMake(0, textLabel_H, self.bounds.size.width/5, 2)];
        if (self.headStyle == SegmentHeadStyleLine) {
            _under_line.backgroundColor = self.headViewColor;
        } else if (self.headStyle == SegmentHeadStyleArrow) {
            self.arrow_layer.position = CGPointMake(_under_line.frame.size.width/2, 0);
            [_under_line.layer addSublayer:self.arrow_layer];
        }
    }
    return _under_line;
}

//箭头layer
- (CAShapeLayer *)arrow_layer {
    if (!_arrow_layer) {
        _arrow_layer = [[CAShapeLayer alloc] init];
        _arrow_layer.bounds = CGRectMake(0, 0, arrow_W, arrow_H);
        [_arrow_layer setFillColor:self.headViewColor.CGColor];
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:CGPointMake(arrow_W/2, 0)];
        [arrowPath addLineToPoint:CGPointMake(arrow_W, arrow_H)];
        [arrowPath addLineToPoint:CGPointMake(0, arrow_H)];
        [arrowPath closePath];
        _arrow_layer.path = arrowPath.CGPath;
    }
    return _arrow_layer;
}

- (UIView *)slideView {
    if (!_slideView) {
        _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/5, textLabel_H)];
        _slideView.clipsToBounds = YES;
        _slideView.layer.cornerRadius = 24;
        _slideView.alpha = 0.5;
        self.headViewColor =[UIColor lightGrayColor];
        _slideView.backgroundColor = self.headViewColor;
        
    }
    return _slideView;
}

- (void)setHeadViewColor:(UIColor *)headViewColor {
    _headViewColor = headViewColor;
    if (self.headStyle == SegmentHeadStyleSlide) {
        self.slideView.backgroundColor = headViewColor;
    } else if(self.headStyle == SegmentHeadStyleLine) {
        self.under_line.backgroundColor = headViewColor;
    }
    
}
#pragma mark - private method

- (void)itemClick:(UITapGestureRecognizer *)tap {
    
    if (tap.view.tag == self.currentIndex) {
        return;
    }
    
    UILabel *tap_label = (UILabel *)tap.view;
    UILabel *old_label = self.titleLabes[self.currentIndex];
   
    old_label.textColor =  self.defaultTextColor;
    tap_label.textColor = self.selectTextColor;
   
    if ([self.delegate respondsToSelector:@selector(PLTapOffset: textLabel:)]) {
        
        [self.delegate PLTapOffset:tap_label.tag textLabel:tap_label];
    }
    
    self.currentIndex = tap.view.tag;
    [self titleContentOffset];
    [UIView animateWithDuration:.2 animations:^{
        if (self.headStyle == SegmentHeadStyleSlide) {
            self.slideView.frame = CGRectMake(self.currentIndex*self.bounds.size.width/5, 0, self.bounds.size.width/5, textLabel_H);
        } else {
           self.under_line.frame=CGRectMake(self.currentIndex*self.bounds.size.width/5, textLabel_H, self.bounds.size.width/5, 2);
        }
    }];
}

- (void)titleContentOffset {
    
    UILabel *tap_label = self.titleLabes[self.currentIndex];
    CGFloat maxOffset =  self.scrollview.contentSize.width - self.bounds.size.width;
    CGFloat offset = tap_label.center.x - self.frame.size.width/2;
    if (offset<0) {
        
        offset = 0;
    }
    if (offset>maxOffset) {
        
        offset = maxOffset;
    }
    [self.scrollview setContentOffset:CGPointMake(offset, 0) animated:YES];
    
}

#pragma mark -public method

- (void)changeUnderLineFrameWithProgress:(CGFloat)progrss sourceViewTag:(NSInteger)source targetViewTag:(NSInteger)target{
    
    UILabel *source_lab = self.titleLabes[source];
    UILabel *target_lab = self.titleLabes[target];
    
    source_lab.textColor = RGB(85.0*progrss, 85.0*progrss, 85.0*progrss);
    if (progrss>0.5) {
        source_lab.textColor = self.defaultTextColor;
        target_lab.textColor = self.selectTextColor;
        if (self.headStyle == SegmentHeadStyleDefault) {
             source_lab.font = [UIFont systemFontOfSize:16.f];
             target_lab.font = [UIFont systemFontOfSize:20.f];
        }
        
    } else {
        source_lab.textColor = self.selectTextColor;
        target_lab.textColor = self.defaultTextColor;
        
        if (self.headStyle == SegmentHeadStyleDefault) {
            source_lab.font = [UIFont systemFontOfSize:20.f];
            target_lab.font = [UIFont systemFontOfSize:16.f];
        }
    }
    
    CGFloat move_distance = target_lab.frame.origin.x - source_lab.frame.origin.x;
    
    if (self.headStyle == SegmentHeadStyleSlide) {
       self.slideView.frame = CGRectMake(source_lab.frame.origin.x+move_distance*progrss, 0, self.bounds.size.width/5, textLabel_H);
    } else {
        self.under_line.frame=CGRectMake(source_lab.frame.origin.x+move_distance*progrss, textLabel_H, self.bounds.size.width/5, 2);
    }
    self.currentIndex = target;
    [self titleContentOffset];
}

- (void)scrollToindex:(NSInteger)index{
    
    UILabel *target_lab = self.titleLabes[index];
    
    target_lab.textColor = RGB(255.0, 128.0, 0.0);
    self.currentIndex = index;
    [self titleContentOffset];
    
}

@end
