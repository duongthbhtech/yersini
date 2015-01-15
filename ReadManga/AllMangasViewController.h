//
//  AllMangasViewController.h
//  ReadManga
//
//  Created by DuongMac on 1/15/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllMangasViewController : UIViewController{
    NSArray *allMangasArray;
    NSArray *searchResults;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
-(void)wsAllMangas;
@end
