//
//  ViewController.h
//  XY抽屉效果
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CenterViewController,RightViewController,LeftViewController;

@interface RootViewController : UIViewController

-(instancetype)initWithCentgerVC:(CenterViewController *)centerVC rightVC:(RightViewController *)righeVC leftVC:(LeftViewController *)leftVC;


@end

