//
//  SJHCoolViewVC.h
//  huijuwuyeapp
//
//  Created by llb on 15/12/17.
//  Copyright © 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CoolViewVCBlock)(int tag);

typedef void(^CoolViewVCDismissBlock)(void);

@interface SJHCoolViewVC : UIViewController


+(instancetype)CoolViewVC;

-(void)setCoolViewBlock:(CoolViewVCBlock)block;


-(void)CoolViewVCWithModelArray:(NSMutableArray *)modelArray andwithCurrentPageNumber:(int)currentNumber andWithassests:(NSArray *)assests andWithDelePageNumberClickCallBackBlock:(CoolViewVCBlock)block;

- (void)setCoolViewVCDismissBlock:(CoolViewVCDismissBlock)dismissBlock;
@end
