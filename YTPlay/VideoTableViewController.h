//
//  VideoTableTableViewController.h
//  YTPlay
//
//  Created by Андрей Щербинин on 18.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface VideoTableViewController : UIViewController


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet YTPlayerView *videoView;


@property (strong, nonatomic) IBOutlet UILabel *dislikeCount;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;
@property (strong, nonatomic) IBOutlet UILabel *titleVideo;
@property (strong, nonatomic) IBOutlet UILabel *viewCount;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (nonatomic,strong) NSMutableArray* videoObjects;
@property (strong, nonatomic) UISearchController    *searchController;

@end
