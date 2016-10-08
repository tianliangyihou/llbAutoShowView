//
//  ViewController.m
//  llbAutoShowView
//
//  Created by llb on 16/9/18.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "ViewController.h"
#import "AutoShowView.h"
#import "AutoShowViewCell.h"
#import "UIView+layerAnimation.h"
#import "MLSelectPhoto.h"
#import "SJHCoolViewVC.h"
@interface ViewController ()<AutoShowViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>
@property(nonatomic,weak)AutoShowView *asv;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AutoShowView *showView = [AutoShowView autoShowViewWithFrame:CGRectMake(50, 100, 300, 100) andWithAlwaysShowDeleBtn:YES];
    showView.delegate = self;
    showView.backgroundColor = [UIColor redColor];
    [self.view addSubview:showView];
    _asv = showView;
    
}

#pragma mark - autoShowViewdelegate-

- (void)autoShowViewDidClickItemsWithTag:(int)tag andWithCell:(AutoShowViewCell *)cell {
    if (cell.image.isAddBtn == YES) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相册",@"拍照", nil];
        [alertView show];
    }else{
        SJHCoolViewVC *coolvc=[SJHCoolViewVC CoolViewVC];
        [coolvc CoolViewVCWithModelArray:self.asv.currentModelArray andwithCurrentPageNumber:cell.itemTag+1 andWithassests:nil andWithDelePageNumberClickCallBackBlock:^(int tag) {
            [_asv deleteCellWithItemTag:tag andWithAnimation:YES];
        }];
        [self presentViewController:coolvc animated:YES completion:nil];
    }
}

- (UIShowViewEdgeInsets)autoShowViewEdgeInsets {
    return UIShowViewEdgeInsetsMake(10, 10, 10,10);
}

- (CGSize)autoShowViewCellSize {

    return CGSizeMake(80, 80);

}
- (void)autoShowViewWillDeleCell:(AutoShowViewCell *)cell andWithTag:(int)tag {

    NSLog(@"-----即将删除-%d---",tag);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) return;
    if (buttonIndex == 1) {
        [self loadLibrarySourceWithMemory];
    }else {
        
        [self loadCameraSource];
        
    }
}

#pragma mark -  加载图片资源-

/**
 点击图库后调用   没有记忆功能的 只管添加
 */
//- (void)loadLibrarySource {
//    
//    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
//    pickerVc.maxCount = 9;
//    pickerVc.status = PickerViewShowStatusCameraRoll;
//    [pickerVc showPickerVc:self];
//    pickerVc.callBack = ^(NSArray *assets){
//        NSMutableArray *datas = [[NSMutableArray alloc]init];
//        for (MLSelectPhotoAssets *asset in assets) {
//            UIImage * image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset] ;
//            LLBImage *imagellb = [[LLBImage alloc]init];
//            imagellb.sourceImg = image;
//            [datas addObject:imagellb];
//        }
//        [_asv reloadWithAddArray:datas];
//    };
//
//}
/**
 点击图库后调用      有记忆已选择图片的功能的
 */
- (void)loadLibrarySourceWithMemory {
    
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    pickerVc.maxCount = 9;
    pickerVc.selectPickers = _asv.assests;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:self];
    pickerVc.callBack = ^(NSArray *assets){
        [_asv reloadWithArray:assets];
    };
    
}


/**
 点击相机后调用
 */
- (void)loadCameraSource
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"-------相机不可用-------");
        return;
    }
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    //    2.设置枚举
    pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    3.设置委托
    pickerVC.allowsEditing = YES;
    
    pickerVC.delegate = self;
    //    5.以模态视图弹出控制器
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}
#pragma mark -  UIImagePickerControllerDeleagte-

/**

 相机的代理方法
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    LLBImage *imagellb = [[LLBImage alloc]init];
    imagellb.sourceImg = image;
    [_asv reloadWithAddImage:imagellb];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}





@end
