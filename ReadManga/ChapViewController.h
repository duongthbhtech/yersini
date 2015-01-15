//
//  ChapitreTableViewController.h
//  ReadManga
//
//  Created by DuongMac on 1/12/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionViewCell.h"
#import "ImagesViewController.h"
#import "AppDelegate.h"
#import "Manga.h"


@interface ChapViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>{
    NSArray *chapitreArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;

@property(strong,nonatomic)NSString *mangaID;
@property(strong,nonatomic)NSString *mangaName;

-(void)wsAllChapitres;
-(void)addToFavorite;
@end
