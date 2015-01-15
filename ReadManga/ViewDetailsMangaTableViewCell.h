//
//  ViewDetailsMangaTableViewCell.h
//  ReadManga
//
//  Created by DuongMac on 1/15/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewDetailsMangaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *chaptersLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;

@end
