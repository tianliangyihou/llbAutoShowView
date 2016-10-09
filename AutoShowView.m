//
//  AutoShowView.m
//  llbAutoShowView
//
//  Created by llb on 16/9/18.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "AutoShowView.h"
#import "AutoShowViewCell.h"
#import "UIView+Frame.h"
#import "UIView+layerAnimation.h"
#import "LLBImage.h"
#import "MLSelectPhoto.h"
@interface AutoShowView ()<AutoShowViewCellDelegate>

{
    CGPoint _centerPoint;
}
@property(nonatomic,assign)int lineNumber;

@property(nonatomic,assign)int cluNumber;

@property(nonatomic,strong)NSMutableArray *viewArray;

@property(nonatomic,strong)NSMutableArray *datas;

@end

@implementation AutoShowView

- (NSMutableArray *)currentModelArray {
    NSMutableArray *muarr = [[NSMutableArray alloc]init];
    [muarr addObjectsFromArray:self.datas];
    [muarr removeLastObject];
    return muarr;
}
- (NSMutableArray *)assests {
    if (!_assests) {
        _assests = [[NSMutableArray alloc]init];
    }
    return _assests;
}


- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc]init];
        LLBImage *image = [[LLBImage alloc]init];
        image.isAddBtn = YES;
        image.sourceImg = [UIImage imageNamed:@"declaration_addimage@2x"];
        [_datas addObject:image];
    }
    return _datas;
}

- (void)datasAddObjectWithModelArray:(NSArray *)modelArray {
    id object = self.datas.lastObject;
    [self.datas removeLastObject];
    [self.datas addObjectsFromArray:modelArray];
    [self.datas addObject:object];
}

- (void)dataAddObjectWithLLBImage:(LLBImage *)image {
    int index = (int)self.datas.count - 1;
    [self.datas insertObject:image atIndex:index];
}


- (NSMutableArray *)viewArray {
    
    if (!_viewArray) {
        _viewArray = [[NSMutableArray alloc]init];
    }
    return _viewArray;

}
static BOOL shouldShowdeleBtn;

+ (instancetype)autoShowViewWithFrame:(CGRect)frame andWithAlwaysShowDeleBtn:(BOOL)show {
    shouldShowdeleBtn = show;
    return [[self alloc]initWithFrame:frame];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithDefaultData];
    }
    return self;
}

- (void)initWithDefaultData {
    _leftEdgeInset = 0;
    _rightEdgeInset = 0;
    _spaceWithCells = 0;
    _cellSize = CGSizeMake(50, 50);
    _spaceWithLines = 0;
}
#pragma  mark - deleagte-

- (void)setDelegate:(id<AutoShowViewDelegate>)delegate {
    _delegate = delegate;
    [self initWithDelegateReturnData];
}

- (void)initWithDelegateReturnData {

    if (_delegate && [_delegate respondsToSelector:@selector(autoShowViewCellSize)]) {
        _cellSize = [_delegate autoShowViewCellSize];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(autoShowViewEdgeInsets)]) {
       UIShowViewEdgeInsets edgeInset = [_delegate autoShowViewEdgeInsets];
        _leftEdgeInset = edgeInset.left;
        _rightEdgeInset = edgeInset.right;
        _spaceWithCells = edgeInset.cellSpace;
        _spaceWithLines = edgeInset.lineSpace;
    }
    [self setModelArray:nil andWithFrame:self.frame];
}

- (void)setModelArray:(NSArray *)modelArray andWithFrame:(CGRect)frame
{
    _modelArray = modelArray;
    [self datasAddObjectWithModelArray:modelArray];
    [self layoutUIWithArray:self.datas andWithFrame:frame];
}

- (void)layoutUIWithArray:(NSArray *)modelArray andWithFrame:(CGRect)frame
 {
    self.frame = frame;
    self.backgroundColor = [UIColor redColor];
     CGFloat leftAndRightSpace = 0;
         CGFloat width = frame.size.width - _leftEdgeInset - _rightEdgeInset;
         CGFloat cellWidth = _cellSize.width;
         int lineNumber = width / cellWidth;
         _lineNumber = lineNumber;
         _cluNumber = 0;
         CGFloat lineSpace ;
         if (_lineNumber < 2) {
             lineSpace = 0;
         }else {
             lineSpace = (width - lineNumber * cellWidth) / ((float)lineNumber - 1.0);
         }
         _spaceWithCells = lineSpace;
     [self layoutCellWithFrame:frame andWithSpace:leftAndRightSpace];

}


#pragma  下一版将继续对这个算法优化  应该搞个数组记录
- (void)layoutCellWithFrame:(CGRect)frame andWithSpace:(CGFloat)leftAndRightSpace{
        [self.viewArray removeAllObjects];
    if (self.subviews.count > self.datas.count) {
        for (int i = 0; i<self.datas.count - self.subviews.count; i++) {
            UIView *view = self.subviews.firstObject;
            [view removeFromSuperview];
        }
    }// 这里是因为当进入相册，点击取消选取图片后，会导致之前的多余的cell并没有被移除，而出现bug
        for (int i = 0 ; i < _datas.count; i++) {
            AutoShowViewCell *cell = nil;
            if (_datas.count != self.subviews.count){
                cell = [[AutoShowViewCell alloc]init];
            }else{
                cell = self.subviews[_datas.count - i - 1];
            }
            NSLog(@"%@",NSStringFromCGRect(cell.frame));
            if (cell.animation == YES && leftAndRightSpace == 0) {
                CGRect newRect = [self layoutCellWithFrame:frame andWithSpace:leftAndRightSpace andWithNumber:i andWithAnimation:YES];
                [UIView animateWithDuration:0.25 animations:^{
                    cell.frame = newRect;
                }];
            }else {
                cell.frame = [self layoutCellWithFrame:frame andWithSpace:0 andWithNumber:i andWithAnimation:NO];
            }
            cell.itemTag = i;
            cell.shouldShowDeleBtn = shouldShowdeleBtn;
            cell.image = self.datas[i];
            [cell setCallBackBlock:^(AutoShowViewCell *cell) {
                if (_delegate && [_delegate respondsToSelector:@selector(autoShowViewDidClickItemsWithTag:andWithCell:)]) {
                    [_delegate autoShowViewDidClickItemsWithTag:cell.itemTag andWithCell:cell];
                };
            }];
            [cell setDeleteClickBlock:^(AutoShowViewCell *cell) {
                [cell.deleBtn removeFromSuperview];
                [self deleteCellWithItemTag:cell.itemTag andWithAnimation:YES];
            }];
            cell.delegate = self;
            if (_datas.count != self.subviews.count){
                [self addSubview:cell];
            }
            [self.viewArray addObject:cell];
        }

}

- (CGRect)layoutCellWithFrame:(CGRect)frame andWithSpace:(CGFloat)leftAndRightSpace andWithNumber:(int)tag andWithAnimation:(BOOL)animation{
        int lineNum = tag/_lineNumber;
        int cluNum = tag% _lineNumber;
        CGFloat cellX = _leftEdgeInset + leftAndRightSpace + cluNum * _cellSize.width + cluNum * _spaceWithCells;
        CGFloat cellY = lineNum * _cellSize.height + lineNum * _spaceWithLines;
        if (tag == _datas.count -1) {
                self.height = cellY + _cellSize.width;
        };
        return CGRectMake(cellX, cellY, _cellSize.width, _cellSize.height);
}

//
//- (void)getAsynCalculateFrameWithCell:(AutoShowViewCell * )cell andWithTag:(int )tag andWithFrame:(CGRect)frame andWithAnimation:(BOOL)animation{
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        CGRect targetFrame = [self layoutCellWithFrame:frame andWithSpace:0 andWithNumber:tag andWithAnimation:animation];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (animation == YES) {
//                [UIView animateWithDuration:0.25 animations:^{
//                    cell.frame = targetFrame;
//                }];
//            }else {
//                cell.frame = targetFrame;
//                
//            }
//        });
//        
//    });
//}


- (void)deleteCellWithItemTag:(int)tag andWithAnimation:(BOOL)isAnimation {
   
    AutoShowViewCell *deleCell = nil;
    for (AutoShowViewCell*cell in self.subviews) {
        if (cell.itemTag == tag) {
            deleCell = cell;
        }
        cell.animation = isAnimation;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(autoShowViewWillDeleCell:andWithTag:)]) {
        [_delegate autoShowViewWillDeleCell:deleCell andWithTag:tag];
    }
    if (self.assests.count > tag) {
        [self.assests removeObjectAtIndex:tag];
    }
    if (isAnimation) {
        CGPoint center = deleCell.showImageV.center;
        [UIView animateWithDuration:0.25 animations:^{
            deleCell.showImageV.width = 0;
            deleCell.showImageV.height = 0;
            deleCell.showImageV.center = center;
        }completion:^(BOOL finished) {
            [deleCell removeFromSuperview];
            [self.datas removeObjectAtIndex:tag];
            [self setModelArray:@[] andWithFrame:self.frame];
        }];
    
    }else{
        [deleCell removeFromSuperview];
        [self.datas removeObjectAtIndex:tag];
        [self setModelArray:@[] andWithFrame:self.frame];
    }

}

- (void)reloadCellFrameAndArrayCount {
    
    [self layoutCellWithFrame:self.frame andWithSpace:10];
}

#pragma mark - 增删方法  -
- (void)reloadWithAddArray:(NSArray *)llbImages {
    [self setModelArray:llbImages andWithFrame:self.frame];
}

- (void)reloadWithAddImage:(LLBImage *)llbImage {
    [self dataAddObjectWithLLBImage:llbImage];
    [self setModelArray:nil andWithFrame:self.frame];
}

-(void)reloadWithArray:(NSArray *)assests {
    if ([assests.firstObject isKindOfClass:[LLBImage class]]) {
        NSLog(@"---应该调用reloadWithAddArray--");
    }
    [self.assests removeAllObjects];
    id obj = self.datas.lastObject;
    [self.datas removeAllObjects];
    [self.datas addObject:obj];
    NSMutableArray *imgs = [[NSMutableArray alloc]init];
    for (int i = 0; i < assests.count; i++) {
        UIImage * image = [MLSelectPhotoPickerViewController getImageWithImageObj:assests[i]] ;
        LLBImage *imagellb = [[LLBImage alloc]init];
        imagellb.sourceImg = image;
        [imgs addObject:imagellb];
        [self.assests addObject:assests[i]];
    }
    [self setModelArray:imgs andWithFrame:self.frame];
    [self reloadCellFrameAndArrayCount];
}

#pragma mark - CellDelegate-

- (void)cellWillBeginToMove:(AutoShowViewCell *)cell  andWithGes:(UILongPressGestureRecognizer *)ges{
    cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
    _centerPoint = cell.center ;
    [self bringSubviewToFront:cell];
    [self showAllCellDeleBtn];
}


- (void)showAllCellDeleBtn {

    if (shouldShowdeleBtn == NO) return;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (AutoShowViewCell *cell in self.subviews) {
            if (cell.image.isAddBtn == YES) {
                cell.deleBtn.hidden = YES;
 
            }else {
                cell.deleBtn.hidden = NO;
            }
        }
    });

}

- (void)cellDidMove:(AutoShowViewCell *)cell andWithGes:(UILongPressGestureRecognizer *)ges{
    
    CGPoint newPoint = [ges locationInView:self];
    cell.center = newPoint;
    int tag = [self cellWillMoveToTagWithCell:cell];//tag 是最终的tag
    if (tag == _datas.count - 1) return ;
    if (tag == -1) return;
        
        if (cell.itemTag > tag) {
            UIView *view = self.viewArray[tag];
            _centerPoint = view.center;
            for(int i = tag; i<cell.itemTag ; i++) {
                AutoShowViewCell *changeCell = self.viewArray[i];
                changeCell.itemTag = changeCell.itemTag + 1;
             CGRect newFrame  = [self layoutCellWithFrame:self.frame  andWithSpace:0 andWithNumber:changeCell.itemTag andWithAnimation:YES];
                [UIView animateWithDuration:0.25 animations:^{
                    changeCell.frame = newFrame;
                }];
            }
            [self changeArrayWithTag:cell.itemTag andWithEndTag:tag];
            cell.itemTag = tag;
            
        }else{
        
            UIView *view = self.viewArray[tag];
            _centerPoint = view.center;
            for(int i = cell.itemTag + 1; i <=tag ; i++) {
                AutoShowViewCell *changeCell = self.viewArray[i];
                changeCell.itemTag = changeCell.itemTag - 1;
                CGRect newFrame  = [self layoutCellWithFrame:self.frame  andWithSpace:0 andWithNumber:changeCell.itemTag andWithAnimation:YES];
                [UIView animateWithDuration:0.25 animations:^{
                    changeCell.frame = newFrame;
                }];
            }
            [self changeArrayWithTag:cell.itemTag andWithEndTag:tag];
            cell.itemTag = tag;
            
        }
    
 
}

- (void)changeArrayWithTag:(int)beginTag andWithEndTag:(int)endTag {
    id obj = _datas[beginTag];
    [self.datas removeObjectAtIndex:beginTag];
    [self.datas insertObject:obj atIndex:endTag];
    AutoShowViewCell *cell = _viewArray[beginTag];
    [_viewArray removeObjectAtIndex:beginTag];
    [_viewArray insertObject:cell atIndex:endTag];
    if (_assests.count > 1) {
        id assObj = _assests[beginTag];
        [self.assests removeObjectAtIndex:beginTag];
        [self.assests insertObject:assObj atIndex:endTag];
    }

}


- (void)cellWillEndToMove:(AutoShowViewCell *)cell andWithGes:(UILongPressGestureRecognizer *)ges{
    cell.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.25 animations:^{
            cell.center = _centerPoint;
        }];
}

/**
    计算当前cell的tag
 */
- (int)cellWillMoveToTagWithCell:(AutoShowViewCell *)cellBegin {

    for (AutoShowViewCell *cell in self.subviews) {
        if (cell != cellBegin) {
         if (CGRectContainsPoint(cell.frame, cellBegin.center)) {
             return cell.itemTag;
         }
        }
    }
    return -1;


}

@end
