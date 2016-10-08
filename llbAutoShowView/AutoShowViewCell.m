//
//  AutoShowViewCell.m
//  llbAutoShowView
//
//  Created by llb on 16/9/18.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "AutoShowViewCell.h"
#import "UIView+Frame.h"
#define AutoShowViewCell_btnWith 25

@interface AutoShowViewCell ()
{
    AutoShowViewCellCallBackBlock _block;
    AutoShowViewCellDeleteClickBlock _deleteblock;
}
@property(nonatomic,strong)UILongPressGestureRecognizer *longPressGes;

@property(nonatomic,assign)BOOL isFirstLongpress;

@end

@implementation AutoShowViewCell

- (UIImageView *)showImageV {
    if (!_showImageV) {
        UIImageView *showImageV = [[UIImageView alloc] init];
        showImageV.frame = self.bounds;
        [self addSubview:showImageV];
        _showImageV = showImageV;
    }
    return _showImageV;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.animation = NO;
        [self addLittleClearBtn];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addLittleClearBtn {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AutoShowViewCell_btnWith, AutoShowViewCell_btnWith)];
    [btn addTarget:self action:@selector(deleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"img_delete_icon@2x"] forState:UIControlStateNormal];
    [self addLongPressGestureToCellContentView];
    _deleBtn = btn;
    _deleBtn.hidden = YES;

}

/**
 
 *  添加拖动手势
 */
- (void)addLongPressGestureToCellContentView
{
    //长按手势
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewLongPressGesture:)];
    [self addGestureRecognizer:longGesture];
    _longPressGes = longGesture;
}

#pragma mark - 手势处理方法
/**
 *  手势处理方法
 *
 */
#pragma 长按手势
- (void)viewLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
            //移动前
        case UIGestureRecognizerStateBegan:
            if ([self.delegate respondsToSelector:@selector(cellWillBeginToMove: andWithGes:)]){
                [self.delegate cellWillBeginToMove:self andWithGes:gesture];
                self.superview.tag = 100;
                }
            break;
            //移动中
        case UIGestureRecognizerStateChanged:
            
            if ([self.delegate respondsToSelector:@selector(cellDidMove: andWithGes:)]) {
                [self.delegate cellDidMove:self andWithGes:gesture];
            }
            break;
            //移动后
        case UIGestureRecognizerStateEnded:
            
            if ([self.delegate respondsToSelector:@selector(cellWillEndToMove: andWithGes:)]) {
                [self.delegate cellWillEndToMove:self andWithGes:gesture];
            }
            break;
            
        default:
            break;
    }

}



- (void)setImage:(LLBImage *)image {
    _image = image;
    self.showImageV.image = image.sourceImg;
    self.showImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.showImageV.clipsToBounds = YES;
    [self bringSubviewToFront:_deleBtn];
    if (image.isAddBtn == YES) {
        self.longPressGes.minimumPressDuration = DISPATCH_TIME_FOREVER;
    }else {
        self.longPressGes.minimumPressDuration = 0.5;
    }
    if(self.superview.tag != 100) return;
    if (_shouldShowDeleBtn == YES) {
        
        if (image.isAddBtn == YES) {
            self.deleBtn.hidden = YES;
        }else {
            self.deleBtn.hidden = NO;
        }
        
    }else {
    
        self.deleBtn.hidden = YES;
    }
}

- (void)changeOrderClick:(UIButton *)btn {


}


- (void)setCallBackBlock:(AutoShowViewCellCallBackBlock)block {

    _block = block;
}

- (void)setDeleteClickBlock:(AutoShowViewCellDeleteClickBlock)deleteblock {
    _deleteblock = deleteblock;
}

- (void)btnClick:(UIButton *)btn {

    if (_block) {
        _block(self);
    }

}

- (void)deleBtnClick:(UIButton *)btn {
    
    if (_deleteblock) {
        _deleteblock(self);
    }

}
- (void)willMoveToSuperview:(UIView *)newSuperview {

    [super willMoveToSuperview:newSuperview];
    _deleBtn.left = self.width - AutoShowViewCell_btnWith;
}


@end
