//
//  VideoDetailViewController.h
//  YTPlay
//
//  Created by Андрей Щербинин on 20.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface VideoDetailViewController : UIViewController
@property (nonatomic,strong) NSString* videoID;

@property (strong, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationTextLable;
@property (strong, nonatomic) IBOutlet UILabel *viewCountTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *dislikeTextLabel;
@property (strong, nonatomic) IBOutlet UIView *shadowTextView;
@property (weak, nonatomic) IBOutlet UIView *videoContainer;
@property (strong, nonatomic) IBOutlet UIView *textContainerView;

@property (strong, nonatomic) IBOutlet YTPlayerView *videoPlayerView;

-(void)getVideoID:(NSString*)videoIDStr;
@end
