//
//  TableVideoCell.h
//  YTPlay
//
//  Created by Андрей Щербинин on 18.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface TableVideoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet YTPlayerView *ytPlayerView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *description;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end
