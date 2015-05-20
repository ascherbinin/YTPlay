//
//  VideoTableTableViewController.h
//  YTPlay
//
//  Created by Андрей Щербинин on 18.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestYTViewController.h"

@interface VideoTableViewController : UITableViewController

@property (nonatomic, strong) TestYTViewController *ytViewController;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end
