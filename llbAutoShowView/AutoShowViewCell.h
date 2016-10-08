//
//  AutoShowViewCell.h
//  llbAutoShowView
//
//  Created by llb on 16/9/18.
//  Copyright © 2016年 lw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLBImage.h"
@class AutoShowViewCell;
typedef void(^AutoShowViewCellCallBackBlock)(AutoShowViewCell * cell);
typedef void(^AutoShowViewCellDeleteClickBlock)(AutoShowViewCell * cell);

@protocol AutoShowViewCellDelegate <NSObject>

- (void)cellWillBeginToMove:(AutoShowViewCell *)cell andWithGes:(UILongPressGestureRecognizer *)ges;

- (void)cellDidMove:(AutoShowViewCell *)cell andWithGes:(UILongPressGestureRecognizer *)ges;

- (void)cellWillEndToMove:(AutoShowViewCell *)cell andWithGes:(UILongPressGestureRecognizer *)ges;
@end

@interface AutoShowViewCell : UIButton
@property(nonatomic,assign)int itemTag;
@property(nonatomic,assign)BOOL animation;
@property(nonatomic,weak)UIButton *deleBtn;
@property(nonatomic,strong)LLBImage *image;
@property(nonatomic,assign)id <AutoShowViewCellDelegate>delegate;
@property(nonatomic,weak)UIImageView *showImageV;
@property(nonatomic,assign)BOOL shouldShowDeleBtn;


- (void)setCallBackBlock:(AutoShowViewCellCallBackBlock)block;
- (void)setDeleteClickBlock:(AutoShowViewCellDeleteClickBlock)deleteblock;

@end
