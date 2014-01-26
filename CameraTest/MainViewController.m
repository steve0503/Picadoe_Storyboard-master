//
//  ViewController.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "MainViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

#define CELL_WIDTH 140
#define CELL_COUNT 13
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface MainViewController ()


@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;

@property (nonatomic, strong)Flickr *flickr;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *cellHeights;


@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation MainViewController



#pragma mark - dataSource fetch

- (void)fetchData
{
    [self.dataArr removeAllObjects];
    
    //NSMutableArray *girlList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < CELL_COUNT ; i++) {
        
        
        NSString *fileName = [NSString stringWithFormat:@"pic%d",i+1];
    
        NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"jpg"];
        
        UIImage *girlImg = [UIImage imageWithContentsOfFile:filePath];
 
        [self.dataArr addObject:girlImg];
        
    }
    // [self.dataList addObject:girlList];
    
    [self.collectionView reloadData];
}




#pragma mark - UITextFieldDelegate methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    // 1
    [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
    
        if(results && [results count] > 0) {
            // 2
            if(![self.searches containsObject:searchTerm]) {
              
                NSLog(@"Found %d photos matching %@", [results count],searchTerm);
                
                [self.searches insertObject:searchTerm atIndex:0];
              
                self.searchResults[searchTerm] = results; }
            // 3
                dispatch_async(dispatch_get_main_queue(), ^{
                // Placeholder: reload collectionview data
                
                [self.collectionView reloadData];
                
            });
        } else { // 1
            
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
            
        } }];
    
    [textField resignFirstResponder];
    
    return YES;
}



- (id)initWithCoder:(NSCoder *)aDecoder {
    
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.cellWidth = CELL_WIDTH;        // Default if not setting runtime attribute
        
    }
    
    return self;
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {

    
    if (!_collectionView) {
        
        
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
    
        layout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        
#ifdef HEADER_FOOTER_SUPPORT
        
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter

                withReuseIdentifier:FOOTER_IDENTIFIER];
        
#endif
        
        
    }
    
    return _collectionView;
}

- (NSMutableArray *)cellHeights {
    
    if (!_cellHeights) {
    
        _cellHeights = [NSMutableArray arrayWithCapacity:CELL_COUNT];
        
        for (NSInteger i = 0; i < CELL_COUNT; i++) {
        
            _cellHeights[i] = @(arc4random() % 100 * 2 + 100);
            
        }
        
    }
    
    return _cellHeights;
}




#pragma mark - Life Cycle


- (void)dealloc {
    
    [_collectionView removeFromSuperview];
    
    _collectionView = nil;
    
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    self.dataArr = [[NSMutableArray alloc] init];
    
    [self fetchData];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView addSubview:refreshControl];
    
    
  
    
    
    
 //   self.searches = [@[] mutableCopy];
    
 //   self.searchResults = [@{} mutableCopy];
    
 //   self.flickr = [[Flickr alloc] init];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
   
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
 
    
    [self updateLayout];
    
    
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
  
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
    [self updateLayout];
    
    
}



- (void)updateLayout {
    
    
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    
    layout.columnCount = self.collectionView.bounds.size.width / self.cellWidth;
    
    layout.itemWidth = self.cellWidth;
    
    
}

#pragma mark
#pragma mark - UICollectionViewDelegate


// 셀 아이템을 선택했을 경우 호출
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor yellowColor].CGColor;
    cell.layer.borderWidth = 3.0f;
}

// 선택한 셀 아이템을 다시 선택했을 경우 호출
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = nil;
    cell.layer.borderWidth = 0.0f;
}



#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
//    NSString *searchTerm = self.searches[section];
  
//    return [self.searchResults[searchTerm] count];

    
  //  return CELL_COUNT;
    
    NSLog(@"The number of Array is :%d",self.dataArr.count);
    
    return [self.dataArr count];
    
  //  return 6;

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
   // return [self.searches count];
    
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CHTCollectionViewWaterfallCell *cell = (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
  
    // cell.displayString = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    // NSString *searchTerm = self.searches[indexPath.section];
    
   // cell.photo = self.searchResults[searchTerm]
    
   // [indexPath.row];
    
    
    
    
    NSUInteger row = [indexPath row];
    
    // 표시할 이미지 설정
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 160)];
    
  //  imageView.image = [self makeThumbnailImage:[self.dataArr objectAtIndex:row] onlyCrop:NO Size:75];
    
    imageView.image = [self.dataArr objectAtIndex:row];
    
    [cell addSubview:imageView];


    return cell;
    
    
    
}

#pragma mark
#pragma mark - other source
// 썸네일 만들기


- (UIImage *)makeThumbnailImage:(UIImage *)image onlyCrop:(BOOL)bOnlyCrop Size:(float)size
{
    CGRect rcCrop;
    if (image.size.width == image.size.height){
    
        rcCrop = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        
    } else if (image.size.width > image.size.height) {
        
        int xGap = (image.size.width - image.size.height) / 2;
        
        rcCrop = CGRectMake(xGap, 0.0, image.size.height, image.size.height);
        
    } else {
        
        int yGap = (image.size.height - image.size.width) / 2;
        
        rcCrop = CGRectMake(0.0, yGap, image.size.width, image.size.width);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rcCrop);
    
    UIImage* cropImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    if (bOnlyCrop) return cropImage;
    
    NSData* dataCrop = UIImagePNGRepresentation(cropImage);
    
    UIImage* imgResize = [[UIImage alloc] initWithData:dataCrop];
    
    UIGraphicsBeginImageContext(CGSizeMake(size,size));
    
    [imgResize drawInRect:CGRectMake(0.0f, 0.0f, size, size)];
    
    UIImage* imgThumb = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return imgThumb;
}



#ifdef HEADER_FOOTER_SUPPORT

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

#endif

#pragma mark - UICollectionViewWaterfallLayoutDelegate


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.cellHeights[indexPath.item] floatValue];
    
}



#ifdef HEADER_FOOTER_SUPPORT

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForHeaderInLayout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout {
    
    return 50;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForFooterInLayout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout {
    
    return 30;
}

#endif




@end
