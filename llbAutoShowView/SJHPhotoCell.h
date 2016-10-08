//
//  SJHPhotoCell.h
//  huijuwuyeapp
//
//  Created by llb on 15/12/18.
//  Copyright © 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJHPhotoCell : UICollectionViewCell
@property(nonatomic,strong)UIImage  * image;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

+(instancetype)photoCellCollectionViewCellWithCollectionView:(UICollectionView *)collection andWithIndexpath:(NSIndexPath *)index;
@end
