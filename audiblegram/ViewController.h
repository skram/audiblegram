//
//  ViewController.h
//  audiblegram
//
//  Created by Mark Peterson on 10/5/14.
//  Copyright (c) 2014 mark peterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosaicLayoutDelegate.h"

#define kColumnsiPadLandscape 5
#define kColumnsiPadPortrait 4
#define kColumnsiPhoneLandscape 3
#define kColumnsiPhonePortrait 2

@interface ViewController : UIViewController <MosaicLayoutDelegate>{
    __weak IBOutlet UICollectionView *_collectionView;
}
@end

