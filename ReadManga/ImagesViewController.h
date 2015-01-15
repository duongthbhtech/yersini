//
//  ImagesViewController.h
//  ReadManga
//
//  Created by DuongMac on 1/12/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController :UIViewController<UIScrollViewDelegate>{
    NSArray *imgArray;
    NSMutableDictionary *imagesDictionary;
    int currentPage;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property(strong,nonatomic)NSString* chapterID;
@property(strong,nonatomic)NSString* numChap;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonPrec;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonSuiv;

-(void)wsAllImages;
-(void)afficheAsyncImageFromURL:(NSString*)url;
-(void)tapScrollView:(UITapGestureRecognizer*)gesture;
-(void)checkFirstAndLastPage;
@end
