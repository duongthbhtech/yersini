//
//  TableViewController.h
//  ReadManga
//
//  Created by DuongMac on 1/15/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterViewController : UITableViewController
{
    NSArray *chapterArray;
}
@property(strong,nonatomic)NSString *mangaID;
@property(strong,nonatomic)NSString *mangaName;

-(void)wsAllChapter;
@end
