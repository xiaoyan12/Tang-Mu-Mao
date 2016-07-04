//
//  DetailViewController.m
//  XMPP_TEST_LFZ1
//
//  Created by 郎凤招 on 16/5/31.
//  Copyright © 2016年 Lang.FZ. All rights reserved.
//

#import "DetailViewController.h"
#import "XMPPCell.h"

#define kTopBotH 80
#define VideoUrl @"http://dlhls.cdn.zhanqi.tv/zqlive/"
#define VideoUrlNormal @".m3u8"
#define VideoUrlLow @"_400/index.m3u8"
#define VideoUrlMid @"_700/index.m3u8"
#define VideoUrlHigh @"_1024/index.m3u8"
static NSString *roomCell = @"cell";

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _data = [[NSMutableArray alloc] init];
    
    [self creatXLVideoPlayer];
    
    [self creatTableView];
    
    [self creatTextfield];
    
    [self creatXMPPGroupChat];
    
    [self creatBackButton];
    
    [self creatBarrage];
}

- (void)setModel:(XYItemModel *)model {
    
    _model = model;
    
    _myPlayer.videoId = _model.videoId;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma - mark 播放器
- (void)creatXLVideoPlayer {

    _myPlayer = [[XLVideoPlayer alloc] init];
    _myPlayer.videoUrl = [NSString stringWithFormat:@"%@%@%@",VideoUrl,_model.videoId,VideoUrlNormal];
    _myPlayer.frame = CGRectMake(0, 0, XYScreenW, XYScreenW * XYScreenW / XYScreenH);
    
    _myPlayer.videoId = _model.videoId;
    
    [self.view addSubview:_myPlayer];
}

#pragma - mark 发弹幕输入框

- (void)creatTextfield {

    _botTextfieldView = [[BotTextFieldView alloc] initWithFrame:CGRectMake(0, XYScreenH - 49, XYScreenW, 49)];
    
    _botTextfieldView.backgroundColor = [UIColor clearColor];
    
    UITextField *textView = [[UITextField alloc] initWithFrame:CGRectMake(2, 2, XYScreenW - 4, 45)];
    
    _botTextfieldView.textView = textView;
    
    _botTextfieldView.textView.backgroundColor = [UIColor lightGrayColor];
    
    _botTextfieldView.textView.text = @"发个弹幕呗";
    
    _botTextfieldView.textView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHight:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    [_botTextfieldView addSubview:_botTextfieldView.textView];
    
    [self.view addSubview:_botTextfieldView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.text = @"发个弹幕呗";
    _botTextfieldView.frame = CGRectMake(0, XYScreenH - 49, XYScreenW, 49);
    
    _botTextfieldView.textView.frame = CGRectMake(2, 2, XYScreenW - 4, 45);
    
    [UIView animateWithDuration:0.2 animations:^{
        [_botTextfieldView.textView layoutIfNeeded];
    }];
}

//发送群消息
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text != nil) {
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:_botTextfieldView.textView.text];
        
        EMMessage *mess = [[EMMessage alloc] initWithConversationID:GroupId from:UserName to:GroupId body:body ext:nil];
        
        mess.chatType = EMChatTypeGroupChat;
        
        [[EMClient sharedClient].chatManager asyncSendMessage:mess progress:nil completion:^(EMMessage *message, EMError *error) {
            
            if ([message.body valueForKey:@"text"] != nil ) {
                [_data addObject:message];
                [_myTableView reloadData];
                [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                [_barrage receive:[self walkTextSpriteDescriptorWithForm:message.from withText:[message.body valueForKey:@"text"]]];
            }

        }];
    }
    
    [_botTextfieldView.textView endEditing:YES];
    
    return YES;
}

- (void)keyboardHidden:(NSNotification *)notification {

  //  NSDictionary *info = [notification userInfo];
    
    _botTextfieldView.frame = CGRectMake(0, XYScreenH - 49, XYScreenW, 49);
    
    _botTextfieldView.textView.frame = CGRectMake(2, 2, XYScreenW - 4, 45);
    
    [UIView animateWithDuration:0.2 animations:^{
        [_botTextfieldView.textView layoutIfNeeded];
    }];
}

- (void)keyboardHight:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];
    
    int offset = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    float duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    _botTextfieldView.frame = CGRectMake(0, 0, XYScreenW, XYScreenH);
    _botTextfieldView.textView.frame = CGRectMake(0, XYScreenH - offset - 49, XYScreenW, 49);
    
    [UIView animateWithDuration:duration animations:^{
        [_botTextfieldView.textView layoutIfNeeded];
    }];
    
}

#pragma - mark 聊天界面

//读取XMPP群消息
- (void)creatXMPPGroupChat {
    
    
    //读取群组消息
    
    EMConversation *con = [[EMClient sharedClient].chatManager getConversation:@"testConversation" type:EMConversationTypeGroupChat createIfNotExist:YES];
    
    NSArray *allConMes = [con loadMoreMessagesFromId:nil limit:20 direction:EMMessageSearchDirectionUp];
    
    for (EMMessage *obj in allConMes) {
        
        [_data addObject:obj];
        
        [_barrage receive:[self walkTextSpriteDescriptorWithForm:obj.from withText:[obj.body valueForKey:@"text"]]];
        
     }
    
    if (_data.count != 0) {
        
        [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

//实时接收群消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        
        [_data addObject:message];    //新消息加到tableView上
        [_myTableView reloadData];
        [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [_barrage receive:[self walkTextSpriteDescriptorWithForm:message.from withText:[message.body valueForKey:@"text"]]];
        
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"\n%@\n%@ : %@",[NSDate dateWithTimeIntervalSince1970:(long)(message.timestamp/1000 + 28800)],message.from,txt);
            }
                break;
            case EMMessageBodyTypeImage:
            {
                // 得到一个图片消息body
                EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
                NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"大图的secret -- %@"    ,body.secretKey);
                NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
                NSLog(@"大图的下载状态 -- %u",body.downloadStatus);
                
                
                // 缩略图sdk会自动下载
                NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
                NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
                NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
                NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
                NSLog(@"小图的下载状态 -- %u",body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                NSLog(@"纬度-- %f",body.latitude);
                NSLog(@"经度-- %f",body.longitude);
                NSLog(@"地址-- %@",body.address);
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
                EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
                NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
                NSLog(@"音频的secret -- %@"        ,body.secretKey);
                NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"音频文件的下载状态 -- %u"   ,body.downloadStatus);
                NSLog(@"音频的时间长度 -- %u"      ,body.duration);
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
                
                NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"视频的secret -- %@"        ,body.secretKey);
                NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"视频文件的下载状态 -- %u"   ,body.downloadStatus);
                NSLog(@"视频的时间长度 -- %u"      ,body.duration);
                NSLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
                
                // 缩略图sdk会自动下载
                NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
                NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
                NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
                NSLog(@"缩略图的下载状态 -- %u"      ,body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
                NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
                NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"文件的secret -- %@"        ,body.secretKey);
                NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"文件文件的下载状态 -- %u"   ,body.downloadStatus);
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)creatTableView {
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XYScreenW * XYScreenW / XYScreenH, XYScreenW, XYScreenH - XYScreenW * XYScreenW / XYScreenH - 49) style:UITableViewStylePlain];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_myTableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 25;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XMPPCell *cell = [tableView dequeueReusableCellWithIdentifier:roomCell];
    
    if (!cell) {
        cell = [[XMPPCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:roomCell];
    }
    
    EMMessage *message = _data[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",message.from,[message.body valueForKey:@"text"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma - mark 退出按钮

- (void)creatBackButton {
    
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    
    [_myPlayer addSubview:_backBtn];
    
}

- (void)backAction {
    
    [_myPlayer destroyPlayer];
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 弹幕

// 创建弹幕
- (void)creatBarrage {
    
    _barrage = [[BarrageRenderer alloc] init];
    
    [_barrage start];
    
    _barrage.speed = 5;
    
    _barrage.canvasMargin = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [_myPlayer addSubview:_barrage.view];
}

/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithForm:(NSString *)from withText:(NSString *)text
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"%@ : %@",from,text];
    descriptor.params[@"textColor"] = [UIColor greenColor];
    descriptor.params[@"speed"] = @20;
    
    return descriptor;
}

@end
