//
//  NewViewController.m
//  NBTest
//
//  Created by apple on 2018/10/23.
//  Copyright © 2018年 penglei. All rights reserved.
//

#import "NewViewController.h"

@interface NewViewController ()

@property(nonatomic, assign)NSInteger count;

@end

@implementation NewViewController

- (instancetype )initWithCount:(NSInteger )count backGroundColor:(UIColor *)color {
    if (self = [super init]) {
        self.count = count;
        self.view.backgroundColor = color;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = [NSString stringWithFormat:@"%ld",(long)self.count];
   
    label.textAlignment = 1;
    label.center = self.view.center;
    label.font = [UIFont systemFontOfSize:30];
    
    label.textColor =  [UIColor blackColor];
    [self.view addSubview:label];
    
    // Do any additional setup after loading the view.
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
