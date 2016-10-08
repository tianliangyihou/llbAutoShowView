//
//  UIView+layerAnimation.m
//  llbAutoShowView
//
//  Created by llb on 16/9/19.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "UIView+layerAnimation.h"
#define kToRadian(A) (A/360.0 * (M_PI * 2))

@implementation UIView (layerAnimation)
- (void)startAnimation {

    
    CAKeyframeAnimation *keyframeAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    keyframeAni.duration = 0.2;
    
    //关键部分角度 这里是抖动动画的几个关键点
    
    keyframeAni.values = @[@(kToRadian(5)),@(kToRadian(0)),@(kToRadian(-5)),@(kToRadian(0)),@(kToRadian(5))];
    
    keyframeAni.repeatCount = MAXFLOAT;
    
    [self.layer addAnimation:keyframeAni forKey:@"key"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_FOREVER, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //停止动画
        [self.layer removeAnimationForKey:@"key"];
        
    });

}

- (void)stopAnimation {
    
    [self.layer removeAnimationForKey:@"key"];

}
- (BOOL)islayerAnimation {
    return self.layer.animationKeys.count > 0;
}
@end
