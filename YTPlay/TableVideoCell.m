//
//  TableVideoCell.m
//  YTPlay
//
//  Created by Андрей Щербинин on 18.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import "TableVideoCell.h"

@implementation TableVideoCell

@synthesize ytPlayerView;
@synthesize title;
@synthesize description;
@synthesize date;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
