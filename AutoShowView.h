//
//  AutoShowView.h
//  llbAutoShowView
//
//  Created by llb on 16/9/18.
//  Copyright © 2016年 lw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLBImage.h"
@class AutoShowViewCell;

/**
  控制cell到self的左右边距 以及cell之间的间隔 还有行与行之间的距离
 */
typedef struct UIShowViewEdgeInsets {
    CGFloat left, right, cellSpace ,lineSpace; // 距离父控件左 右 和 cell的间距
    
} UIShowViewEdgeInsets;

UIKIT_STATIC_INLINE UIShowViewEdgeInsets UIShowViewEdgeInsetsMake(CGFloat left, CGFloat right, CGFloat cellSpace, CGFloat lineSpace) {
    UIShowViewEdgeInsets insets = { left, right , cellSpace ,lineSpace};
    return insets;
}

@protocol AutoShowViewDelegate <NSObject>
@optional

- (void)autoShowViewDidClickItemsWithTag:(int)tag andWithCell:(AutoShowViewCell *)cell;

- (UIShowViewEdgeInsets)autoShowViewEdgeInsets ;

- (CGSize)autoShowViewCellSize;

/**
   记忆功能需要时候使用这个
 */
- (void)autoShowViewWillDeleCell:(AutoShowViewCell *)cell andWithTag:(int)tag;

@end


@interface AutoShowView :  UIView


@property(nonatomic,strong)NSArray *modelArray;

/**
  cell的大小
 */
@property(nonatomic,assign)CGSize   cellSize;

/**
 左边距
 */
@property(nonatomic,assign)CGFloat leftEdgeInset;

/**
 右边距
 */
@property(nonatomic,assign)CGFloat rightEdgeInset;

/**
 cell之间的间距 默认0 自适应 
 */
@property(nonatomic,assign)CGFloat spaceWithCells;


/**
 每行之间的距离
 */
@property(nonatomic,assign)CGFloat spaceWithLines;


@property(nonatomic,assign)id<AutoShowViewDelegate> delegate;


@property(nonatomic,strong,readonly)NSMutableArray *currentModelArray;

@property(nonatomic,strong)NSMutableArray *assests;


/**
 这里自动布局
 @param modelArray 数组元素
 @param frame 这个view的大小frame.size.width或者frame.size.height传0，默认为自动
 */
- (void)setModelArray:(NSArray *)modelArray andWithFrame:(CGRect)frame;

/**


 @param tag         传入删除的数组元素的tag
 @param isAnimation isAnimation
 */
- (void)deleteCellWithItemTag:(int)tag andWithAnimation:(BOOL)isAnimation;


/**
 添加一个元素
 */
- (void)reloadWithAddImage:(LLBImage *)llbImage;


- (void)reloadWithAddArray:(NSArray *)llbImages;

- (void)reloadWithArray:(NSArray *)assests;

+ (instancetype)autoShowViewWithFrame:(CGRect)frame andWithAlwaysShowDeleBtn:(BOOL)show;

@end
