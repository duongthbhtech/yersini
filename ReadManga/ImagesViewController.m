//
//  ImagesViewController.m
//  ReadManga
//
//  Created by DuongMac on 1/12/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import "ImagesViewController.h"
#define wsGetAllImages @"http://www.mangaeden.com/api/chapter/"
#define imgURL @"http://cdn.mangaeden.com/mangasimg/"
@interface ImagesViewController ()

@end

@implementation ImagesViewController
@synthesize chapitreID;
@synthesize numChap;

- (void)viewDidLoad {
    self.title = [NSString stringWithFormat:@"Chap %@",numChap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView:)];
    [_scrollView addGestureRecognizer:tap];
    
    _scrollView.maximumZoomScale = 4.0;
    _scrollView.minimumZoomScale = 1.0;
    
    imagesDictionary = [[NSMutableDictionary alloc] init];
    
    [self wsAllImages];
    
    [super viewDidLoad];
}
-(void)wsAllImages{
    
    [_activityView startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *_urlString = [NSString stringWithFormat:@"%@%@",wsGetAllImages,chapitreID];
    NSURL *_url = [NSURL URLWithString:_urlString];
    
    NSMutableURLRequest *_request = [NSMutableURLRequest requestWithURL:_url];
    
    NSDictionary *_headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"accept", nil];
    
    [_request setAllHTTPHeaderFields:_headers];
    
    [NSURLConnection sendAsynchronousRequest:_request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
                               
                               NSError *_errorJson = nil;
                               NSDictionary *_reponseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
                               
                               if (_errorJson != nil) {
                                   NSLog(@"Error %@", [_errorJson localizedDescription]);
                               } else {
                                   //Do something with returned array
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       [_activityView stopAnimating];
                                       
                                       NSArray *interArray = [[NSArray alloc] initWithArray:[_reponseDic valueForKeyPath:@"images"]];
                                       
                                       NSMutableArray *interImgArray = [[NSMutableArray alloc] init];
                                       for (NSArray *array in interArray) {
                                           NSDictionary *entry = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [array objectAtIndex:0],@"page",
                                                                  [array objectAtIndex:1],
                                                                  @"url",
                                                                  nil];
                                           
                                           [interImgArray addObject:entry];
                                       }
                                       
                                       imgArray = [interImgArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"page" ascending:YES]]];
                                       
                                       NSString *url = [NSString stringWithFormat:@"%@%@",imgURL,[[imgArray objectAtIndex:0] valueForKeyPath:@"url"]];
                                       currentPage=0;
                                       [self afficheAsyncImageFromURL:url];
                                       
                                   });
                               }
                               
                           }];
}
-(void)afficheAsyncImageFromURL:(NSString *)url{
    if ([imagesDictionary objectForKey:url])
        
    {
        
        // 3
        _imgView.image = [imagesDictionary objectForKey:url];
        _scrollView.contentSize = CGSizeMake(_imgView.frame.size.width, _imgView.frame.size.height);
        
    }
    else
    {
        // 4
        
        [_activityView startAnimating];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           NSURL *imageURL = [NSURL URLWithString:url];
                           
                           // 5
                           __block NSData *imageData;
                           
                           // 6
                           
                           dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                                         ^{
                                             imageData = [NSData dataWithContentsOfURL:imageURL];
                                             
                                             // 7
                                             [imagesDictionary setObject:[UIImage imageWithData:imageData] forKey:url];
                                             
                                             // 8
                                             dispatch_sync(dispatch_get_main_queue(), ^{
                                                 _imgView.image = [imagesDictionary objectForKey:url];
                                                 _scrollView.contentSize = CGSizeMake(_imgView.frame.size.width, _imgView.frame.size.height);
                                                 
                                                 [_activityView stopAnimating];
                                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                             });
                                         });
                       });
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIScrollView Delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imgView;
}

-(void)tapScrollView:(UITapGestureRecognizer *)gesture{
    if (_toolbar.alpha==0.0) {
        [UIView animateWithDuration:0.5 animations:^{
            [_toolbar setAlpha:1.0];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [_toolbar setAlpha:0.0];
        }];
    }
}

-(void)checkFirstAndLastPage{
    if (currentPage!=0) {
        _barButtonPrec.enabled=YES;
    }else{
        _barButtonPrec.enabled=NO;
    }
    if (currentPage!=imgArray.count-1) {
        _barButtonSuiv.enabled=YES;
    }else{
        _barButtonSuiv.enabled=NO;
    }
}

- (IBAction)clickPrec:(id)sender {
    
    [UIView transitionWithView:self.scrollView duration:1.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        currentPage--;
        self.imgView.image=nil;
        NSString *url = [NSString stringWithFormat:@"%@%@",imgURL,[[imgArray objectAtIndex:currentPage] valueForKeyPath:@"url"]];
        [self afficheAsyncImageFromURL:url];
        
        [self checkFirstAndLastPage];
        
    }completion:nil];
}
- (IBAction)clickSuiv:(id)sender {
    
    [UIView transitionWithView:self.scrollView duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        currentPage++;
        self.imgView.image=nil;
        
        NSString *url = [NSString stringWithFormat:@"%@%@",imgURL,[[imgArray objectAtIndex:currentPage] valueForKeyPath:@"url"]];
        
        [self afficheAsyncImageFromURL:url];
        
        [self checkFirstAndLastPage];
        
    }completion:nil];
}


@end
