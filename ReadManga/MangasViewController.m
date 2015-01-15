//
//  MangasViewController.m
//  ReadManga
//
//  Created by DuongMac on 1/12/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import "MangasViewController.h"

@interface MangasViewController ()

@end

@implementation MangasViewController

- (void)viewDidLoad {
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self wsAllMangas];
    
    [super viewDidLoad];
}
-(void)wsAllMangas{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setFrame:CGRectMake(self.view.frame.size.width/2-activityView.frame.size.width/2, self.view.frame.size.height/2-activityView.frame.size.height/2, activityView.frame.size.width, activityView.frame.size.height)];
    [activityView startAnimating];
    [self.tableView addSubview:activityView];
    
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
                                       
                                       [self.tableView reloadData];
                                       
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }else{
        return allMangasArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] valueForKeyPath:@"t"];
    } else {
        cell.textLabel.text = [[allMangasArray objectAtIndex:indexPath.row] valueForKeyPath:@"t"];
    }
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChapViewController"];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        controller.mangaID = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"i"];
        controller.mangaName = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"t"];
    } else {
        controller.mangaID = [[allMangasArray objectAtIndex:indexPath.row] valueForKey:@"i"];
        controller.mangaName = [[allMangasArray objectAtIndex:indexPath.row] valueForKey:@"t"];
    }
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - SEARCH DISPLAY delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"t contains[cd] %@",
                                    searchText];
    searchResults = [allMangasArray filteredArrayUsingPredicate:resultPredicate];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"t" ascending:YES];
    searchResults=[searchResults sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}
@end
