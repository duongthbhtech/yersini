//
//  MangasViewController.h
//  ReadManga
//
//  Created by DuongMac on 1/12/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChapViewController.h"

@interface MangasViewController : UITableViewController<UISearchDisplayDelegate>{
    NSArray *allMangasArray;
    NSArray *searchResults;
}
-(void)wsAllMangas;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;

@end
