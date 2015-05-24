//
//  VideoDetailViewController.m
//  YTPlay
//
//  Created by Андрей Щербинин on 20.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import <QuartzCore/QuartzCore.h>

@interface VideoDetailViewController ()
{
    CGPoint touchStart;
    bool isResizingUD;
    bool isResizingLR;
    bool isMoving;
}
@end

@implementation VideoDetailViewController

@synthesize videoID;
@synthesize videoPlayerView;
@synthesize shadowTextView;
@synthesize videoContainer;
@synthesize titleTextLabel = title;
@synthesize durationTextLable = duration;
@synthesize viewCountTextLabel = viewCount;
@synthesize dateTextLabel = date;
@synthesize likeTextLabel = likes;
@synthesize dislikeTextLabel = dislikes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Getted Video ID - %@",videoID);
    
    
//    videoPlayerView.layer.masksToBounds = NO;
//    videoPlayerView.layer.shadowColor = [UIColor grayColor].CGColor;
//    videoPlayerView.layer.shadowOffset = CGSizeMake(0, 0);
//    videoPlayerView.layer.shadowOpacity = 0.8;
//    videoPlayerView.layer.shadowRadius = 5;
//    videoPlayerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:videoPlayerView.layer.bounds] CGPath];
    
    shadowTextView.layer.masksToBounds = NO;
    shadowTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    shadowTextView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowTextView.layer.shadowOpacity = 0.3;
    shadowTextView.layer.shadowRadius = 5;
    shadowTextView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowTextView.layer.bounds] CGPath];
  
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"showinfo" :@0,
                                 @"controls" :@2,
                                 @"autohide" :@0,
                                 @"autoplay" :@1,
                                 @"fs" :@1,
                                 @"modestbranding" :@0
                                 };
//    CGRect videoFrame = CGRectMake(0, 0, 200, 140);
//   // [videoPlayerView.webView setFrame:videoFrame];
//    [videoPlayerView setFrame:videoFrame];
    
    [videoPlayerView loadWithVideoId:videoID playerVars:playerVars];
    
    [self loadVideoInfo:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet%%2C+statistics%%2C+contentDetails&id=%@&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo",videoID]];
    
//    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
//                                                    initWithTarget:self
//                                                    action:@selector(oneFingerSwipeLeft:)] ;
//    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGFloat kResizeThumbSize = 25.0f;
    touchStart = [[touches anyObject] locationInView:self.view];
    
    CGFloat xO = videoContainer.frame.origin.x;
    CGFloat yO = videoContainer.frame.origin.y;
    CGFloat width = videoContainer.frame.size.width;
    CGFloat height = videoContainer.frame.size.height;
    NSLog(@"x0 - %f, y0-%f, width-%f, height-%f",xO,yO,width,height);
//    isResizingUD = (xO - kResizeThumbSize < touchStart.x &&
//                    touchStart.x < xO + width + kResizeThumbSize &&
//                    yO + height - kResizeThumbSize < touchStart.y);
//    isResizingLR = (yO + kResizeThumbSize < touchStart.y &&
//                    touchStart.y< yO + height - kResizeThumbSize &&
//                    xO + width - kResizeThumbSize < touchStart.x);
    isMoving = (xO+kResizeThumbSize< touchStart.x &&
                touchStart.x < xO + width - kResizeThumbSize  &&
                yO + kResizeThumbSize < touchStart.y &&
                touchStart.y< yO + height - kResizeThumbSize);
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGPoint previous = [[touches anyObject] previousLocationInView:self.view];
    
    CGFloat deltaWidth = touchPoint.x - previous.x;
    CGFloat deltaHeight = touchPoint.y - previous.y;
     NSLog(@"deltaWidth - %f, deltaHeight-%f",deltaWidth,deltaHeight);
    // get the frame values so we can calculate changes below
    CGFloat x = videoContainer.frame.origin.x;
    CGFloat y = videoContainer.frame.origin.y;
    CGFloat width = videoContainer.frame.size.width;
    CGFloat height = videoContainer.frame.size.height;
    CGRect startRect = [[[videoContainer layer] presentationLayer] frame];
    
    
    if(CGRectContainsPoint(startRect, touchStart))
    {
        NSLog(@"Moving");
        // not dragging from a corner -- move the view
        videoContainer.frame = CGRectMake(x+deltaWidth, y+deltaHeight, width, height);
    }
    
    
    if (isResizingUD) {
         NSLog(@"Resizing");
        videoContainer.frame = CGRectMake(x, y, width, height+deltaHeight);
    } else if (isResizingLR) {
        NSLog(@"Resizing");
        videoContainer.frame = CGRectMake(x, y, width+deltaWidth, height);
    } else if (isMoving) {
       
    }
    
}


- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer
{
    
     [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) loadVideoInfo:(NSString*) urlString
{
    
    NSURL *videoIdURL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:videoIdURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *items = [responseObject objectForKey:@"items"];
         NSLog(@"JSON Retrieved");
         
         for (NSDictionary *item in items )
         {
             NSDictionary* snippet = [item objectForKey:@"snippet"];
             title.text = [snippet objectForKey:@"title"];
             
             NSArray *array = [[snippet objectForKey:@"publishedAt"] componentsSeparatedByString:@"T"];
             date.text = [NSString stringWithFormat:@"%@ в %@",array[0], [(NSString*)array[1] substringToIndex:8 ]];
             duration.text = [[item objectForKey:@"contentDetails"] objectForKey:@"duration"];
             viewCount.text = [[item objectForKey:@"statistics"] objectForKey:@"viewCount"];
             likes.text = [[item objectForKey:@"statistics"]objectForKey:@"likeCount"];
             dislikes.text = [[item objectForKey:@"statistics"] objectForKey:@"dislikeCount"];
         }
         
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving PlayList"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
    
    // 5
    [operation start];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getVideoID:(NSString*)videoIDStr
{
    videoID = videoIDStr;
}


@end
