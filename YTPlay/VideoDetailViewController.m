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

@interface VideoDetailViewController ()


@end

@implementation VideoDetailViewController

@synthesize videoID;
@synthesize videoPlayerView;
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
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"showinfo" :@0,
                                 @"controls" :@2,
                                 
                                 };
    
    
    [videoPlayerView loadWithVideoId:videoID playerVars:playerVars];
    [self loadVideoInfo:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet%%2C+statistics%%2C+contentDetails&id=%@&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo",videoID]];
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
