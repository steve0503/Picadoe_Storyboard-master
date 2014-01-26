//
//  UICollectionViewWaterfallCell.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class FlickrPhoto;

@interface CHTCollectionViewWaterfallCell : UICollectionViewCell


@property (nonatomic, copy) NSString *displayString;


@property (nonatomic, strong)  UILabel *displayLabel;


//@property (strong, nonatomic) UIImageView *imageView;

@property (nonatomic, strong) FlickrPhoto *photo;

-(void)setPhoto:(FlickrPhoto *)photo;


@end
