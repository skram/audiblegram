//
//  ViewController.m
//  audiblegram
//
//  Created by Mark Peterson on 10/5/14.
//  Copyright (c) 2014 mark peterson. All rights reserved.
//

#import "ViewController.h"
#import "InstagramKit.h"
#import "UIImageView+AFNetworking.h"
#import "MosaicLayout.h"
#import "MosaicData.h"
#import "CustomDataSource.h"
#import "URBMediaFocusViewController.h"

@interface ViewController () <UICollectionViewDelegate,URBMediaFocusViewControllerDelegate>{
    
}
@property(nonatomic,strong) InstagramPaginationInfo *currentPaginationInfo;
@property(nonatomic,strong) NSMutableArray *mediaArray;
@property(nonatomic,strong) MosaicData *data;
@property (nonatomic, strong) URBMediaFocusViewController *mediaFocusController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.mediaFocusController = [[URBMediaFocusViewController alloc] init];
    self.mediaFocusController.delegate = self;
    
    [(MosaicLayout *)_collectionView.collectionViewLayout setDelegate:self];
    
    [self populate];
}

-(void)populate {

    NSMutableArray *elements = [(CustomDataSource *)_collectionView.dataSource elements];
    
    //Gather images from IG tagged w/ "selfie".
    
    [[InstagramEngine sharedEngine] getMediaWithTagName:@"selfie" count:50 maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        self.currentPaginationInfo = paginationInfo;
        NSLog(@"%@",media);
        
        MosaicData *aMosaicModule = [[MosaicData alloc] init];
        aMosaicModule.imageFilename = @"http://www.92y.org/92StreetY/media/MICROSITES/OnAirOnDemand/MS_OAOD_AudibleLogo.jpg";
        aMosaicModule.title = @"audible:selfie";
        [elements addObject:aMosaicModule];
        
        // Loop Gathered images and create MosaicData objects for display
        for (InstagramMedia *obj in media) {
            MosaicData *aMosaicModule = [[MosaicData alloc] initWithDictionary:@{@"imageFilename":obj.standardResolutionImageURL.absoluteString,@"title":[obj.tags componentsJoinedByString:@","]}];
            [elements addObject:aMosaicModule];
        }
        
        [_collectionView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"Search Media Failed");
    }];

    
    NSLog(@"#DEBUG %@", NSStringFromSelector(_cmd));
    

}

#pragma mark - MosaicLayoutDelegate

-(float)collectionView:(UICollectionView *)collectionView relativeHeightForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //  Base relative height for simple layout type. This is 1.0 (height equals to width)
    float retVal = 1.0;
    
    NSMutableArray *elements = [(CustomDataSource *)_collectionView.dataSource elements];
    MosaicData *aMosaicModule = [elements objectAtIndex:indexPath.row];
    
    if(aMosaicModule.relativeHeight == 0) {
        BOOL isDoubleColumn = [self collectionView:collectionView isDoubleColumnAtIndexPath:indexPath];
        if (isDoubleColumn){
            //  Base relative height for double layout type. This is 0.50 (height equals to 50% width)
            retVal = 0.50;
        }
    }
    return retVal;
}

-(BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *elements = [(CustomDataSource *)_collectionView.dataSource elements];
    MosaicData *aMosaicModule = [elements objectAtIndex:indexPath.row];
    
    if (aMosaicModule.layoutType == kMosaicLayoutTypeUndefined){
        
        /*  First layout. We have to decide if the MosaicData should be
         *  double column (if possible) or not. */
        
        if(indexPath.row % 3) {
            aMosaicModule.layoutType = kMosaicLayoutTypeSingle;
        } else {
            aMosaicModule.layoutType = kMosaicLayoutTypeDouble;
        }
    }
    
    BOOL retVal = aMosaicModule.layoutType == kMosaicLayoutTypeDouble;
    
    return retVal;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSMutableArray *elements = [(CustomDataSource *)_collectionView.dataSource elements];
    MosaicData *aMosaicModule = [elements objectAtIndex:indexPath.row];
    
    [self.mediaFocusController
     showImageFromURL:[NSURL URLWithString:aMosaicModule.imageFilename] fromView:self.view];
    
}

-(NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView{
    
    return kColumnsiPhonePortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
