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
    bool isMinimized;
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
@synthesize textContainerView;

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
                                 @"playsinline" : @"1",
                                 @"autoplay" :@1,
                                 @"showinfo" :@0,
                                 @"controls" :@1,
                                 @"enablejsapi" :@1,
                                 @"modestbranding" :@1,
                                 @"rel": @0,
                                 @"fs": @1,
                                 @"theme" :@"light"
                                 
                                 
                                 };
//    CGRect videoFrame = CGRectMake(0, 0, 200, 140);
//   // [videoPlayerView.webView setFrame:videoFrame];
//    [videoPlayerView setFrame:videoFrame];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.videoPlayerView addGestureRecognizer:swipeDown];
    [self.videoPlayerView addGestureRecognizer:swipeUp];

    
    [videoPlayerView loadWithVideoId:videoID playerVars:playerVars];
    
    [self loadVideoInfo:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet%%2C+statistics%%2C+contentDetails&id=%@&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo",videoID]];
    
//    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
//                                                    initWithTarget:self
//                                                    action:@selector(oneFingerSwipeLeft:)] ;
//    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGFloat kResizeThumbSize = 25.0f;
//    touchStart = [[touches anyObject] locationInView:self.view];
//    
//    CGFloat xO = videoContainer.frame.origin.x;
//    CGFloat yO = videoContainer.frame.origin.y;
//    CGFloat width = videoContainer.frame.size.width;
//    CGFloat height = videoContainer.frame.size.height;
//    NSLog(@"x0 - %f, y0-%f, width-%f, height-%f",xO,yO,width,height);
////    isResizingUD = (xO - kResizeThumbSize < touchStart.x &&
////                    touchStart.x < xO + width + kResizeThumbSize &&
////                    yO + height - kResizeThumbSize < touchStart.y);
////    isResizingLR = (yO + kResizeThumbSize < touchStart.y &&
////                    touchStart.y< yO + height - kResizeThumbSize &&
////                    xO + width - kResizeThumbSize < touchStart.x);
//    isMoving = (xO+kResizeThumbSize< touchStart.x &&
//                touchStart.x < xO + width - kResizeThumbSize  &&
//                yO + kResizeThumbSize < touchStart.y &&
//                touchStart.y< yO + height - kResizeThumbSize);
//    
//}


//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
//    CGPoint previous = [[touches anyObject] previousLocationInView:self.view];
//    
//    CGFloat deltaWidth = touchPoint.x - previous.x;
//    CGFloat deltaHeight = touchPoint.y - previous.y;
//     NSLog(@"deltaWidth - %f, deltaHeight-%f",deltaWidth,deltaHeight);
//    // get the frame values so we can calculate changes below
//    CGFloat x = videoContainer.frame.origin.x;
//    CGFloat y = videoContainer.frame.origin.y;
//    CGFloat width = videoContainer.frame.size.width;
//    CGFloat height = videoContainer.frame.size.height;
//    CGRect startRect = [[[videoContainer layer] presentationLayer] frame];
//    
//    
//    if(CGRectContainsPoint(startRect, touchStart))
//    {
//        NSLog(@"Moving");
//        // not dragging from a corner -- move the view
//        videoContainer.frame = CGRectMake(x+deltaWidth, y+deltaHeight, width, height);
//    }
//    
//    
//    if (isResizingUD) {
//         NSLog(@"Resizing");
//        videoContainer.frame = CGRectMake(x, y, width, height+deltaHeight);
//    } else if (isResizingLR) {
//        NSLog(@"Resizing");
//        videoContainer.frame = CGRectMake(x, y, width+deltaWidth, height);
//    } else if (isMoving) {
//       
//    }
//    
//}


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

- (BOOL)mpIsMinimized {
    NSLog(@"Y %f",self.videoPlayerView.frame.origin.y);
     NSLog(@"IS minimezed");
    return self.videoPlayerView.frame.origin.y > 10;
}


- (void)minimizeMp:(BOOL)minimized animated:(BOOL)animated {
    
    NSLog(@"X: %f Y: %f", self.videoContainer.frame.origin.x, self.videoPlayerView.frame.origin.y);
    if (isMinimized == minimized) return;
    
    CGRect tallContainerFrame, containerFrame;
    CGFloat tallContainerAlpha;
    
    if (minimized)
    {
        CGFloat mpWidth = videoPlayerView.frame.size.width / 2;
        CGFloat mpHeight = videoPlayerView.frame.size.height / 2;
        
        CGFloat x = self.view.bounds.size.width-mpWidth - 20;
        CGFloat y = self.view.bounds.size.height-mpHeight - 40;
        
        NSLog(@"X: Bound:%f, Frame: %f, Position: %f", self.view.bounds.size.width, self.view.frame.size.width, x);
        NSLog(@"Y: Bound:%f, Frame: %f, Position: %f", self.view.bounds.size.height, self.view.frame.size.height, y);
        NSLog(@"MPWidth %f, MPHeight %f", mpWidth, mpHeight);
        
        tallContainerFrame = CGRectMake(0, 0,
                                        self.view.frame.size.width, self.view.frame.size.height);
        containerFrame = CGRectMake(x, y, mpWidth, mpHeight);
        tallContainerAlpha = 0.0;
        
        isMinimized = true;
      
        [self setNeedsStatusBarAppearanceUpdate];
        
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    else
    {
        containerFrame.origin.x = 0;
        containerFrame.origin.y = 64;
        containerFrame.size.width = self.view.bounds.size.width;
        containerFrame.size.height = containerFrame.size.width / 16 * 9 + 40;
        
        tallContainerFrame = self.view.frame;
        tallContainerFrame.origin.y = containerFrame.size.height;
        tallContainerAlpha = 1.0;
        
        isMinimized = false;
        
       
//        [self setNeedsStatusBarAppearanceUpdate];
//        
//        
//        
//        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        [videoPlayerView setFrame:containerFrame];
        [videoContainer setFrame:containerFrame];
        
        NSLog(@"videocontainer frame=%@", NSStringFromCGRect(self.videoContainer.frame));
        NSLog(@"videoplayer frame=%@", NSStringFromCGRect(self.videoContainer.frame));
        
        NSLog(@"X: Bound:%f, Frame: %f", self.videoPlayerView.bounds.size.width, self.videoPlayerView.frame.size.width);
        NSLog(@"Y: Bound:%f, Frame: %f", self.videoPlayerView.bounds.size.height, self.videoPlayerView.frame.size.height);
        // self.playerView.webView.frame = CGRectMake(0, 0, containerFrame.size.width, containerFrame.size.height);
        
        [textContainerView setFrame:tallContainerFrame];
        [textContainerView setAlpha:tallContainerAlpha];
        //self.textContainerView.frame = tallContainerFrame;
        //self.textContainerView.alpha = tallContainerAlpha;
 
        
    }];
}


- (void)swipeDown:(UIGestureRecognizer *)gr {
    NSLog(@"Swipe Down");

    [self minimizeMp:YES animated:YES];
}

- (void)swipeUp:(UIGestureRecognizer *)gr {
    NSLog(@"Swipe up");
    [self minimizeMp:NO animated:YES];
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
