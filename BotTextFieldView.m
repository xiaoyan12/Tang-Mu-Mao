//
//  BotTextFieldView.m
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/6/2.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//

#import "BotTextFieldView.h"

@implementation BotTextFieldView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.textView endEditing:YES];
}


@end
