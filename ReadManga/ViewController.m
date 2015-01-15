//
//  ViewController.m
//  ReadManga
//
//  Created by DuongMac on 1/8/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image=[UIImage imageNamed:@""];
            cell.textLabel.text=@"FAVORITE";
            cell.detailTextLabel.text=@"Manga Favorite";
            break;
        case 1:
            cell.imageView.image=[UIImage imageNamed:@""];
            cell.textLabel.text=@"List Mangas";
            cell.detailTextLabel.text=@"List All Mangas";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UITableViewController *controller;
    switch (indexPath.row) {
        case 0:
            controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"MangasFavorisViewController"];
            break;
        case 1:
            controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"MangasViewController"];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
