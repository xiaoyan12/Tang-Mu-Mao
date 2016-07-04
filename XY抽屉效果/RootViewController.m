//
//  ViewController.m
//  XY抽屉效果
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RootViewController.h"
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "UIImage+ImageEffects.h"

@interface RootViewController ()

@property (nonatomic ,strong)UIImageView *backimage;

@property (nonatomic ,strong)UIView *playView;

@property (nonatomic )        BOOL isChange;

@property (nonatomic )        BOOL isH;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(instancetype)initWithCentgerVC:(CenterViewController *)centerVC rightVC:(RightViewController *)righeVC leftVC:(LeftViewController *)leftVC{
    if (self = [super init]) {
        [self addChildViewController:leftVC];
        [self addChildViewController:righeVC];
        
        UINavigationController *centerNC = [[UINavigationController alloc]initWithRootViewController:centerVC];
        [self addChildViewController:centerNC];
        
        leftVC.view.frame = CGRectMake(0, 0, 250, self.view.bounds.size.height);
        righeVC.view.frame = CGRectMake(self.view.bounds.size.width - 250, 0, 250, self.view.bounds.size.height);
        centerNC.view.frame = [UIScreen mainScreen].bounds;
        
        [self.view addSubview:self.backimage];
        
        [self.view addSubview:leftVC.view];
        [self.view addSubview:righeVC.view];
        [self.view addSubview:centerNC.view];
        
        centerVC.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *leftB = [[UIBarButtonItem alloc]initWithTitle:@"左边" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
            leftB;
        });
        
        centerVC.navigationItem.rightBarButtonItem = ({
            UIBarButtonItem *rightB = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
            rightB;
        });
    }
    
    return self;
}

/**
 *   设置背景图片
 */
-(UIImageView *)backimage{
    if (!_backimage) {
        self.backimage = [[UIImageView alloc]initWithFrame:self.view.bounds];
        
        UIImage *sourceImage = [UIImage imageNamed:@"123"];
        UIImage *lastImage = [sourceImage applyDarkEffect];
        self.backimage.image = lastImage;
    }
    return _backimage;
}

/**
 * 左边按钮事件： rightVC 和 centerNC 向右偏移
 */

-(void)leftAction:(UIBarButtonItem *)sender{
    UINavigationController *centerNC = self.childViewControllers.lastObject;
    RightViewController *rightVC = self.childViewControllers[1];
    LeftViewController *leftVC = self.childViewControllers.firstObject;
    [UIView animateWithDuration:0.5 animations:^{
        
    if ( centerNC.view.center.x != self.view.center.x ) {
            
    
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            _isChange = !_isChange;
            return;
        }{
            
            
            centerNC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
        }
    }];

}

/**
 * 右边按钮事件: leftVC 和 centerNC 向左偏移
 */
- (void)rightAction:(UIBarButtonItem *)sender {
    UINavigationController *centerNC = self.childViewControllers.lastObject;
    LeftViewController *leftVC = self.childViewControllers.firstObject;
    RightViewController *rightVC = self.childViewControllers[1];
    [UIView animateWithDuration:0.5 animations:^{
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            
        }else{
            centerNC.view.frame = CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            leftVC.view.frame =CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
