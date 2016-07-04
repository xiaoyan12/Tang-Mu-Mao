//
//  LeftViewController.m
//  XY抽屉效果
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.alpha = 1;
    
    [self addConstraint];
    // Do any additional setup after loading the view.
}


/**
 *  创建控件, 添加约束
 */
- (void)addConstraint {
    // 头像图片
    UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12345"]];
    
    headImage.layer.masksToBounds = YES;
    
    headImage.layer.cornerRadius = 45;
    
    headImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:headImage];
    
    
    
    UIButton *tanName = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    [tanName.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    
    tanName.tintColor = [UIColor whiteColor];
    
    tanName.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [tanName setTitle:@"Button1" forState:(UIControlStateNormal)];
    
    tanName.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:tanName];
    
    
    UIButton *messageButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    messageButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    messageButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    messageButton.tintColor = [UIColor whiteColor];
    
    [messageButton setTitle:@"Button2" forState:(UIControlStateNormal)];
    
    messageButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:messageButton];
    
    
    
    UIButton *gButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    gButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    gButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    gButton.tintColor = [UIColor whiteColor];
    
    [gButton setTitle:@"Button3" forState:(UIControlStateNormal)];
    
    gButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:gButton];
    
    
    
    UIButton *settingsButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    settingsButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    settingsButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    settingsButton.tintColor = [UIColor whiteColor];
    
    [settingsButton setTitle:@"Button4" forState:(UIControlStateNormal)];
    
    settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:settingsButton];
    
    
    
    
    UIButton *newPeopleButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    newPeopleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    newPeopleButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    newPeopleButton.tintColor = [UIColor whiteColor];
    
    [newPeopleButton setTitle:@"Button5" forState:(UIControlStateNormal)];
    
    newPeopleButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:newPeopleButton];
    
    
    
    UIButton *recommendPeopleButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    recommendPeopleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    recommendPeopleButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    recommendPeopleButton.tintColor = [UIColor whiteColor];
    
    [recommendPeopleButton setTitle:@"Button6" forState:(UIControlStateNormal)];
    
    recommendPeopleButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:recommendPeopleButton];
    
    
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headImage, tanName, gButton, messageButton, settingsButton, newPeopleButton, recommendPeopleButton);
    
    NSArray *imageHC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[headImage(90)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    
    
    NSArray *imageV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[headImage(90)]-110-[tanName]-10-[messageButton]-10-[gButton]-10-[settingsButton]-10-[newPeopleButton]-10-[recommendPeopleButton]-50-|" options:(NSLayoutFormatAlignAllCenterX) metrics:nil views:views];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:headImage attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeCenterX) multiplier:1 constant:0];
    
    
    NSArray *tanArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tanName]-0-|" options:0 metrics:0 views:views];
    
    
    NSArray *messageArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[messageButton]-0-|" options:0 metrics:0 views:views];
    
    NSArray *settingsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[settingsButton]-0-|" options:0 metrics:0 views:views];
    
    NSArray *newPeopleArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[newPeopleButton]-0-|" options:0 metrics:0 views:views];
    
    NSArray *gButtonArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[gButton]-0-|" options:0 metrics:0 views:views];
    
    
    
    NSArray *recommendPeopleButtonArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[recommendPeopleButton]-0-|" options:0 metrics:0 views:views];
    
    
    
    NSLayoutConstraint *tanWigth = [NSLayoutConstraint constraintWithItem:tanName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:gButton attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    
    
    
    NSLayoutConstraint *gButtonWigth = [NSLayoutConstraint constraintWithItem:gButton attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:tanName attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    
    
    NSLayoutConstraint *messageButtonWigth = [NSLayoutConstraint constraintWithItem:gButton attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:messageButton attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    
    
    NSLayoutConstraint *settingsButtonWigth = [NSLayoutConstraint constraintWithItem:gButton attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:settingsButton attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    
    
    
    NSLayoutConstraint *newPeopleButtonWigth = [NSLayoutConstraint constraintWithItem:settingsButton attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:newPeopleButton attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    
    
    NSLayoutConstraint *recommendPeopleButtonWigth = [NSLayoutConstraint constraintWithItem:settingsButton attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:recommendPeopleButton attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    
    
    
    
    [self.view addConstraint:centerX];
    
    [self.view addConstraints:imageHC];
    
    [self.view addConstraints:imageV];
    
    [self.view addConstraints:gButtonArray];
    
    [self.view addConstraints:recommendPeopleButtonArray];
    
    [self.view addConstraints:tanArray];
    
    [self.view addConstraints:messageArray];
    
    [self.view addConstraints:settingsArray];
    
    [self.view addConstraints:newPeopleArray];
    
    [self.view addConstraints:@[tanWigth, gButtonWigth, messageButtonWigth, settingsButtonWigth, newPeopleButtonWigth, recommendPeopleButtonWigth]];
    
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
