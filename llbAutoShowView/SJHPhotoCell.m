//
//  SJHPhotoCell.m
//  huijuwuyeapp
//
//  Created by llb on 15/12/18.
//  Copyright © 2015年 lin. All rights reserved.
//

#import "SJHPhotoCell.h"
#import "LLBImage.h"
@interface SJHPhotoCell ()

@end


@implementation SJHPhotoCell

+(instancetype)photoCellCollectionViewCellWithCollectionView:(UICollectionView *)collection andWithIndexpath:(NSIndexPath *)index
{
    NSString *ID=NSStringFromClass([self class]);
    UINib *nib=[UINib nibWithNibName:ID bundle:nil];
    [collection registerNib:nib forCellWithReuseIdentifier:ID];
    return [collection dequeueReusableCellWithReuseIdentifier:ID forIndexPath:index];
    
}
-(void)setImage:(UIImage *)image
{
    _image=image;
    LLBImage *imagellb = (LLBImage *)image;
     CGSize size=[self imageSizeFromImage:imagellb.sourceImg];
    _photoImageView.frame=CGRectMake(0, 0, size.width, size.height);
    _photoImageView.center=CGPointMake(SCREEN_WIDTH/2,( SCREEN_HEIGHT-64)/2);
    _photoImageView.image=imagellb.sourceImg;
}
#pragma mark -对图片的大小进行判断-
-(CGSize)imageSizeFromImage:(UIImage *)image
{
    float  with;
    float heigt;
    float bili=(float)image.size.width/image.size.height;
    float screenBIli=(float)SCREEN_WIDTH/(SCREEN_HEIGHT-64);
    if (bili>=screenBIli) {
        with=(float)image.size.width /SCREEN_WIDTH;
        heigt=(float)image.size.height/with;
        with=SCREEN_WIDTH;
    }else
    {
        heigt=(float)image.size.height/(SCREEN_HEIGHT-64);
        
        with=(float)image.size.width/heigt;
        heigt=SCREEN_HEIGHT-64;
        
    }

    return CGSizeMake(with, heigt);
    
}

@end
