//
//  SJHCoolViewVC.m
//  huijuwuyeapp
//
//  Created by llb on 15/12/17.
//  Copyright © 2015年 lin. All rights reserved.
//

#import "SJHCoolViewVC.h"
#import "SJHPhotoCell.h"
@interface SJHCoolViewVC ()<UIScrollViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{

    CoolViewVCBlock _block;
    CoolViewVCDismissBlock _dismissBlock;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *deleBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,assign)BOOL shoudRow;

@end

@implementation SJHCoolViewVC

+(instancetype)CoolViewVC
{
    return [[self alloc]init];

}
-(void)CoolViewVCWithModelArray:(NSMutableArray *)modelArray andwithCurrentPageNumber:(int)currentNumber andWithassests:(NSArray *)assests andWithDelePageNumberClickCallBackBlock:(CoolViewVCBlock)block
{
    _modelArray=modelArray;
    _page=currentNumber;
    _block=block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _shoudRow = NO;
    _numberLabel.text=[NSString stringWithFormat:@"%d/%lu",_page,(unsigned long)_modelArray.count];
   }


- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;

}


- (void)viewWillAppear:(BOOL)animated
{
 
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    
     _shoudRow = YES;
   

    [super viewDidAppear:animated];

}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

    if ( _shoudRow == NO) {
        _collectionView.contentOffset = CGPointMake((_page-1) * SCREEN_WIDTH, 0);
    }
   
    

}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return _modelArray.count;

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SJHPhotoCell *cell=[SJHPhotoCell  photoCellCollectionViewCellWithCollectionView:collectionView andWithIndexpath:indexPath];
    cell.image=_modelArray[indexPath.row];
   
    return cell;

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);

}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    return 0;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
   _page  =  scrollView.contentOffset.x/SCREEN_WIDTH+1;
    _numberLabel.text=[NSString stringWithFormat:@"%d/%lu",_page,(unsigned long)_modelArray.count];
    _deleBtn.tag=_page-1;

}
- (IBAction)deleClick:(UIButton *)sender {
    
   
    
    [_modelArray removeObjectAtIndex:_page-1];
    
    if (_block) {
        _block(_page - 1);
    }
    if (_page==1) {
        
    }else
    {
    _page--;
    }
    if (self.modelArray.count==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [_collectionView reloadData];
    
    _numberLabel.text=[NSString stringWithFormat:@"%d/%lu",_page,(unsigned long)_modelArray.count];
  
    NSIndexPath * index=[NSIndexPath indexPathForItem:_page-1 inSection:0];
    [ _collectionView scrollToItemAtIndexPath:index atScrollPosition:0 animated:YES];

}

- (IBAction)dismissClick:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -set方法-
-(void)setCoolViewBlock:(CoolViewVCBlock)block
{
    _block=block;
   
}
- (void)setCoolViewVCDismissBlock:(CoolViewVCDismissBlock)dismissBlock {

    _dismissBlock = dismissBlock;
}


@end
