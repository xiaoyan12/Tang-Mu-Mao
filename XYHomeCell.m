//
//  XYHomeCell.m
//  XY抽屉效果
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "XYHomeCell.h"
#import "XYItemModel.h"

@interface XYHomeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *live;

@end
//gender 1 女 ；2 男
@implementation XYHomeCell

-(void)setModel:(XYItemModel *)model{
    _model = model;
    NSURL *url = [NSURL URLWithString:model.bpic];
    [_image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    _image.contentMode = UIViewContentModeScaleAspectFill;
    _image.layer.masksToBounds = YES;
    _title.text = model.title;
    NSString *str = [NSString stringWithFormat:@"%@",model.gender];
    if ([str isEqualToString:@"1"]) {
        _sexImage.image = [UIImage imageNamed:@"nv"];
    }else{
        _sexImage.image = [UIImage imageNamed:@"nan"];
    }
    _name.text = model.nickname;
    
    _live.text = (model.online.intValue > 10000) ? [NSString stringWithFormat:@"%.1f万",(float)model.online.intValue/10000] : [NSString stringWithFormat:@"%@",model.online];
}
- (void)awakeFromNib {
    // Initialization code
}

@end
