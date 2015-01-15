//
//  ViewDetailsMangaTableViewCell.h
//  ReadManga
//
//  Created by DuongMac on 1/15/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewDetailsMangaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)btnFavorite:(id)sender;
- (IBAction)btnRead:(id)sender;


@end
