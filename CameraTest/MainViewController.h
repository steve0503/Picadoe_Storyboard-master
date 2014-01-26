//
//  ViewController.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

#import "Flickr.h"
#import "FlickrPhoto.h"


//#define HEADER_FOOTER_SUPPORT


@interface MainViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout,UITextFieldDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) CGFloat cellWidth;

@end
