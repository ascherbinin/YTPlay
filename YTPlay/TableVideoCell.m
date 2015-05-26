//
//  TableVideoCell.m
//  YTPlay
//
//  Created by Андрей Щербинин on 18.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import "TableVideoCell.h"

@implementation TableVideoCell

@synthesize imageView;
@synthesize title;
@synthesize description;
@synthesize date;

- (void)awakeFromNib {
    
    
        imageView.layer.masksToBounds = NO;
        imageView.layer.shadowColor = [UIColor grayColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0, -5);
        imageView.layer.shadowOpacity = 0.9;
        imageView.layer.shadowRadius = 5;
        imageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:imageView.layer.bounds] CGPath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
