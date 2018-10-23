//
//  JCLContentScrollView.m
//  NBTest
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 panzihao. All rights reserved.
//

#import "PLContentScrollView.h"
#import "NewViewController.h"

@interface PLContentScrollView ()

@property(nonatomic, strong)UICollectionView *collection;

@property(nonatomic, strong)NSArray *pages;

@property(nonatomic, assign)CGFloat startContentset;

@property(nonatomic, assign)BOOL is_tap;

@end

@implementation PLContentScrollView

- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray <UIViewController *>*)pages {
    
    if (self = [super initWithFrame:frame]) {
        
        self.pages = pages;     
        [self addSubview:self.collection];
        
    }
    return self;
}

- (UICollectionView *)collection {
    
    if (!_collection) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing =0;
        layout.minimumInteritemSpacing=0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collection = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        self.collection.showsHorizontalScrollIndicator = false;
        self.collection.bounces  = NO;
        self.collection.delegate = self;
        self.collection.dataSource = self;
        self.collection.pagingEnabled = YES;
        [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collection;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.pages.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
     UIViewController *controller = ( UIViewController  *)self.pages[indexPath.row];
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
     controller.view.frame = cell.contentView.bounds;
     [cell.contentView addSubview:controller.view];
    
    return cell;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.is_tap = NO;
    self.startContentset = scrollView.contentOffset.x;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat currentOffset = scrollView.contentOffset.x;
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    if (self.is_tap) {
        
        return;
    }
    if (currentOffset>self.startContentset) {//左滑
        
        progress = currentOffset/scrollView.bounds.size.width - floor(currentOffset/scrollView.bounds.size.width);
        sourceIndex =(NSInteger)currentOffset/scrollView.bounds.size.width;
        targetIndex = sourceIndex + 1;
        if (targetIndex>= self.pages.count) {
            
            targetIndex = self.pages.count - 1;
        }
        if (currentOffset - self.startContentset==scrollView.bounds.size.width) {
            
            progress = 1;
            targetIndex = sourceIndex;
        }
    } else{//右滑
        progress = 1 - (currentOffset/scrollView.bounds.size.width - floor(currentOffset/scrollView.bounds.size.width));
        targetIndex =(NSInteger)currentOffset/scrollView.bounds.size.width;
        sourceIndex =targetIndex +1;
        if (sourceIndex>= self.pages.count) {
            
            sourceIndex = self.pages.count - 1;
        }
        if (currentOffset - self.startContentset==scrollView.bounds.size.width) {
            
            progress = 1;
            sourceIndex = targetIndex;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(contentPagePorgess: sourcLocation: targetLocation:)]) {
        
        [self.delegate contentPagePorgess:progress sourcLocation:sourceIndex targetLocation:targetIndex];
    }
}

- (void)PLContentOffsetWithIndex:(NSInteger)index {
    
    self.is_tap = YES;
    [self.collection setContentOffset:CGPointMake(index*self.bounds.size.width, 0) animated:NO];
}

-(void)scrollToindex:(NSInteger)index{
    
   [self.collection reloadData];
   
   [self.collection setContentOffset:CGPointMake(index*self.bounds.size.width, 0) animated:NO];
    
    
}



@end
