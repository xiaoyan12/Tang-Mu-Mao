//
//  UIImage+ImageEffects.h
//  XY抽屉效果
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)

-(UIImage *)applyLightEffect;
-(UIImage *)applyExtraLightEffect;
-(UIImage *)applyDarkEffect;
-(UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

-(UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


@end
