//
//  ChapitreTableViewController.m
//  ReadManga
//
//  Created by DuongMac on 1/12/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import "ChapViewController.h"
#import "CustomCollectionViewCell.h"
#import "ImagesViewController.h"
#define wsGetAllChapitres @"http://www.mangaeden.com/api/manga/"
@interface ChapViewController ()

@end

@implementation ChapViewController

- (void)viewDidLoad {
    self.title=_mangaName;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite)];
    
    [self wsAllChapitres];

    
    [super viewDidLoad];
}

-(void)wsAllChapitres{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setFrame:CGRectMake(self.view.frame.size.width/2-activityView.frame.size.width/2, self.view.frame.size.height/2-activityView.frame.size.height/2, activityView.frame.size.width, activityView.frame.size.height)];
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *_urlString = [NSString stringWithFormat:@"%@%@",wsGetAllChapitres,_mangaID];
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
                                       
                                       _descTextView.text = [_reponseDic valueForKeyPath:@"description"];
                                       
                                       chapitreArray = [[NSArray alloc] initWithArray:[_reponseDic valueForKeyPath:@"chapters"]];
                                       
                                       [_collectionView reloadData];
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
    
    return chapitreArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[chapitreArray objectAtIndex:indexPath.row] objectAtIndex:2]];
    
    return cell;
}
#pragma mark UICollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImagesViewController *controller= [self.storyboard instantiateViewControllerWithIdentifier:@"ImagesViewController"];
    controller.chapitreID = [[chapitreArray objectAtIndex:indexPath.row] objectAtIndex:3];
    controller.numChap = [[chapitreArray objectAtIndex:indexPath.row] objectAtIndex:2];
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)addToFavorite{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"manga farvouris?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert show];
    
}

#pragma mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSManagedObjectContext* context= ((AppDelegate*) [[UIApplication sharedApplication]delegate]).managedObjectContext;
        NSEntityDescription * entity= [NSEntityDescription
                                       entityForName:@"Manga" inManagedObjectContext:context];
        Manga *manga = [[Manga alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
        manga.mangaID = _mangaID;
        manga.mangeName = _mangaName;
        
        [context insertObject:manga];
        [context save:nil];
    }
}

@end
