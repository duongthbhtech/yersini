//
//  TableViewController.m
//  ReadManga
//
//  Created by DuongMac on 1/15/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import "ChapterViewController.h"
#import "ChapterTableViewCell.h"
#define wsGetAllChapter @"http://www.mangaeden.com/api/manga/"
@interface ChapterViewController ()

@end

@implementation ChapterViewController

- (void)viewDidLoad {
    self.title=_mangaName;
    [self wsAllChapter];
    [super viewDidLoad];
  
}

-(void)wsAllChapter{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setFrame:CGRectMake(self.view.frame.size.width/2-activityView.frame.size.width/2, self.view.frame.size.height/2-activityView.frame.size.height/2, activityView.frame.size.width, activityView.frame.size.height)];
    [activityView startAnimating];
    [self.tableView addSubview:activityView];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *_urlString = [NSString stringWithFormat:@"%@%@",wsGetAllChapter,_mangaID];
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
                                       
                                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                       [activityView stopAnimating];
                                       [activityView removeFromSuperview];
                                       
                                       chapterArray = [[NSArray alloc] initWithArray:[_reponseDic valueForKeyPath:@"chapters"]];
                                       
                                       [self.tableView reloadData];
                                   });
                               }
                               
                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return chapterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    ChapterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.chapterLabel.text = [NSString stringWithFormat:@"%@",[[chapterArray objectAtIndex:indexPath.row] objectAtIndex:2]];
    
    return cell;

}

@end
