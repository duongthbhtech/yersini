//
//  AllMangasViewController.m
//  ReadManga
//
//  Created by DuongMac on 1/15/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import "AllMangasViewController.h"
#import "AllMangasCollectionViewCell.h"
#import "ChapterViewController.h"

@interface AllMangasViewController ()

@end

@implementation AllMangasViewController

- (void)viewDidLoad {
    [self wsAllMangas];
    [super viewDidLoad];
}

-(void)wsAllMangas{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setFrame:CGRectMake(self.view.frame.size.width/2-activityView.frame.size.width/2, self.view.frame.size.height/2-activityView.frame.size.height/2, activityView.frame.size.width, activityView.frame.size.height)];
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *_urlString = @"http://www.mangaeden.com/api/list/0/";
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
                                       
                                       allMangasArray = [[NSArray alloc] initWithArray:[_reponseDic valueForKeyPath:@"manga"]];
                                       
                                       NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"t" ascending:YES];
                                       allMangasArray=[allMangasArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
                                       
                                       [_collectionView reloadData];
                                       
                                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                       [activityView stopAnimating];
                                       [activityView removeFromSuperview];
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return allMangasArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    AllMangasCollectionViewCell *cell = (AllMangasCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

        cell.titleLabel.text = [[allMangasArray objectAtIndex:indexPath.row] valueForKeyPath:@"t"];
//    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:
//                                                               
//                                                               [[allMangasArray objectAtIndex:indexPath.row]objectForKey:@"im"]]];
//    
//    UIImage* image = [[UIImage alloc] initWithData:imageData];
//    
//    cell.imageLabel.image =image;

    return cell;
}

#pragma mark - Table view delegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     ChapterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChapterViewController"];
        controller.mangaID = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"i"];
        controller.mangaName = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"t"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - SEARCH DISPLAY delegate

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
//shouldReloadTableForSearchString:(NSString *)searchString
//{
//    
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
//    
//    return YES;
//}
//
//
//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    NSPredicate *resultPredicate = [NSPredicate
//                                    predicateWithFormat:@"t contains[cd] %@",
//                                    searchText];
//    searchResults = [allMangasArray filteredArrayUsingPredicate:resultPredicate];
//    
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"t" ascending:YES];
//    searchResults=[searchResults sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
//}


@end
