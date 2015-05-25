//
//  VideoTableTableViewController.m
//  YTPlay
//
//  Created by Андрей Щербинин on 18.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import "VideoTableViewController.h"
#import "YTPlayerVIew.h"
#import "TableVideoCell.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "YTJsonItem.h"
#import "MBProgressHUD.h"
#import "VideoDetailViewController.h"
#import "UIImageView+AFNetworking.h"



@interface VideoTableViewController () <UITableViewDelegate,
                                        UITableViewDataSource,
                                        UISearchBarDelegate,
                                        UISearchControllerDelegate,
                                        YTPlayerViewDelegate>

@property bool isMinimized;
@property BOOL sbNeed;
@end

@implementation VideoTableViewController
@synthesize detailView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //GlobalVariable *gl = [[GlobalVariable alloc]init];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController setHidesNavigationBarDuringPresentation:NO];
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Поиск!";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.videoView.delegate = self;
    
     self.tableView.tableHeaderView = self.searchController.searchBar;
  
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    
    CGRect playerViewRect = CGRectMake(0- self.view.frame.size.width,
                                       0 + self.view.frame.size.height,
                                       self.view.frame.size.width,
                                       self.view.frame.size.width / 16 * 9 + 20);
    CGRect detailsViewRect = CGRectMake(playerViewRect.origin.x,
                                        playerViewRect.size.height,
                                        playerViewRect.size.width,
                                        self.view.frame.size.height - playerViewRect.size.height);
    
    self.videoView.frame = playerViewRect;
    
    self.detailView.frame = detailsViewRect;
    
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.videoView addGestureRecognizer:swipeDown];
    [self.videoView addGestureRecognizer:swipeUp];
    [self.videoView addGestureRecognizer:swipeLeft];
    
    self.tableView.frame = self.view.bounds;
    NSLog(@"Video view frame=%@", NSStringFromCGRect(_videoView.frame));
    NSLog(@"Detail View frame=%@", NSStringFromCGRect(detailView.frame));
    NSLog(@"Table View frame=%@", NSStringFromCGRect(_tableView.frame));
    [self loadPlayListVideos:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PLgMaGEI-ZiiZ0ZvUtduoDRVXcU5ELjPcI&fields=items(contentDetails%2Cid%2Csnippet)&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo"];
    [self updateUI];
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _videoObjects = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [_videoObjects removeAllObjects];
    
    
    NSString *searchBarString = [self replaceWhiteByPlus:searchBar.text] ;
    searchBarString = [searchBarString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *searchString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=%@&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo",searchBarString];
    
    [self loadPlayListVideos:searchString];
    
}

                   
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [self.view endEditing:YES];
    
      [self loadPlayListVideos:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PLgMaGEI-ZiiZ0ZvUtduoDRVXcU5ELjPcI&fields=items(contentDetails%2Cid%2Csnippet)&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo"];

}

- (NSString *)replaceWhiteByPlus:(NSString *)string {
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSString *trimmedReplacement = [[string componentsSeparatedByCharactersInSet:charactersToRemove]
                                    componentsJoinedByString:@"+"];
    
    return trimmedReplacement;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    NSLog(@"Count element in init number row - %lu",(unsigned long)[_videoObjects count]);
    return [_videoObjects count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *CellIdentifier = @"VideoCell";
    TableVideoCell *cell = (TableVideoCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableVideoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    YTJsonItem *oneVideoItem = [_videoObjects objectAtIndex:indexPath.row];
    
   NSLog(@"Номер строки - %ld",(long)[indexPath row]);
    
  // [cell.ytPlayerView loadWithVideoId:oneVideoItem.videoID playerVars:playerVars];
    
    NSString *imageStringURL = oneVideoItem.thumbURl;;
        NSURL* imageURL = [NSURL URLWithString: imageStringURL];
        if(imageURL != nil)
        {
            [cell.imageView setImageWithURL: imageURL];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"glnews.png"];
        }
    
    cell.title.text =oneVideoItem.videoTitle;
    
    NSArray *array = [oneVideoItem.videoDate componentsSeparatedByString:@"T"];
    cell.date.text = [NSString stringWithFormat:@"Опубликовано: %@ в %@",array[0], [(NSString*)array[1] substringToIndex:8 ]];
    
    return cell;
        
    
}




- (void)updateUI {
    //
    // Playlist table.
    //
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    


}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}





 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
     
     if(indexPath)
     {
         YTJsonItem *item = [_videoObjects objectAtIndex:indexPath.row];
         [self.videoView loadWithVideoId:item.videoID playerVars:playerVars];
         
         [self loadVideoInfo:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet%%2C+statistics%%2C+contentDetails&id=%@&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo",item.videoID]];
     }

     [[self navigationController] setNavigationBarHidden:YES animated:YES];

     
      [self.view endEditing:YES];
     
     self.sbNeed = NO;
     [self setNeedsStatusBarAppearanceUpdate];
     
     
     [UIView animateWithDuration:0.3 animations:^
      {
          CGRect playerViewRect = self.videoView.frame;
          CGRect detailsViewRect = self.detailView.frame;
          
          NSLog(@"Video view frame=%@", NSStringFromCGRect(_videoView.frame));
          NSLog(@"Detail View frame=%@", NSStringFromCGRect(detailView.frame));
          
          playerViewRect.origin.x = 0;
          playerViewRect.origin.y = 0;
          playerViewRect.size.width = self.view.bounds.size.width;
          playerViewRect.size.height = playerViewRect.size.width / 16 * 9 + 20;
          self.videoView.frame = playerViewRect;
          
          detailsViewRect.origin.x = 0;
          detailsViewRect.origin.y = playerViewRect.size.height;
          self.detailView.frame = detailsViewRect;
          self.detailView.alpha = 1.0;
          
          [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
      }];

     
  
 }

#pragma mark - Loding data
#
-(void) loadPlayListVideos:(NSString*) urlString
{
     [_videoObjects removeAllObjects];
    
    NSURL *mostPopularURL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:mostPopularURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *items = [responseObject objectForKey:@"items"];
         NSLog(@"JSON Retrieved");
         
         NSLog(@"Результат поиска - %@ элементов",[[responseObject objectForKey:@"pageInfo"]objectForKey:@"totalResults"]);
         
         for (NSDictionary *item in items )
         {
             YTJsonItem *tempYTItem = [[YTJsonItem alloc]init];
             NSDictionary* snippet = [item objectForKey:@"snippet"];
             tempYTItem.videoTitle = [snippet objectForKey:@"title"];
             NSString *videoIDStr = [[snippet objectForKey:@"resourceId"]objectForKey:@"videoId"];
             if (videoIDStr == nil)
             {
                 videoIDStr = [[item objectForKey:@"id"] objectForKey:@"videoId"];
                 if (videoIDStr == nil)
                 {
                     videoIDStr = [[item objectForKey:@"id"] objectForKey:@"playlistId"];
                     if(videoIDStr == nil)
                     {
                         videoIDStr = [[item objectForKey:@"id"] objectForKey:@"channelId"];
                     }
                 }
             }
             tempYTItem.videoID = videoIDStr;
             tempYTItem.thumbURl= [[[snippet objectForKey:@"thumbnails"] objectForKey:@"high"] objectForKey:@"url"];
             tempYTItem.videoDate =[snippet objectForKey:@"publishedAt"];
             [_videoObjects addObject:tempYTItem];
             
         }
         
         [self updateUI];
         
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

- (BOOL)IsMinimized {
    return self.videoView.frame.origin.y > 50;
}


- (void)swipeDown:(UIGestureRecognizer *)gr {
    [self minimizeVideo:YES animated:YES];
}

- (void)swipeUp:(UIGestureRecognizer *)gr {
    [self minimizeVideo:NO animated:YES];
}

- (void)swipeLeft:(UIGestureRecognizer *)gr {
    NSLog(@"Swipe Left");
    if(![self IsMinimized])
    {
        return;
    }
    CGRect playerFrame = self.videoView.frame;
    playerFrame.origin.x = -self.videoView.frame.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.videoView.frame = playerFrame;

    }];
}


- (void)minimizeVideo:(BOOL)minimized animated:(BOOL)animated {
    
    if ([self IsMinimized] == minimized) return;
    
    CGRect tallContainerFrame, containerFrame;
    CGFloat tallContainerAlpha;
    
    if (minimized)
    {
        CGFloat mpWidth = self.videoView.frame.size.width / 2;
        CGFloat mpHeight = self.videoView.frame.size.height / 2;
        
        CGFloat x = self.view.bounds.size.width-mpWidth - 20;
        CGFloat y = self.view.bounds.size.height-mpHeight - 20;
        
        NSLog(@"X: Bound:%f, Frame: %f, Position: %f", self.view.bounds.size.width, self.view.frame.size.width, x);
        NSLog(@"Y: Bound:%f, Frame: %f, Position: %f", self.view.bounds.size.height, self.view.frame.size.height, y);
        
        tallContainerFrame = CGRectMake(0, self.view.frame.size.height,
                                        self.detailView.frame.size.width, self.detailView.frame.size.height);
        containerFrame = CGRectMake(x, y, mpWidth, mpHeight);
        tallContainerAlpha = 0.0;
        
        self.searchController.active = NO;
        [self.view endEditing:YES];
        
        self.sbNeed = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    else
    {
        containerFrame.origin.x = 0;
        containerFrame.origin.y = 0;
        containerFrame.size.width = self.view.bounds.size.width;
        containerFrame.size.height = containerFrame.size.width / 16 * 9 + 20;
        
        tallContainerFrame = self.detailView.frame;
        tallContainerFrame.origin.y = containerFrame.size.height;
        tallContainerAlpha = 1.0;
        
      
        self.sbNeed = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
    
    NSTimeInterval duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        
        //self.youTubePlayer.frame = containerFrame;
        self.videoView.frame = containerFrame;
        // self.playerView.webView.frame = CGRectMake(0, 0, containerFrame.size.width, containerFrame.size.height);
        self.detailView.frame = tallContainerFrame;
        self.detailView.alpha = tallContainerAlpha;
        
    }];
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
             _titleVideo.text = [snippet objectForKey:@"title"];
             
             NSArray *array = [[snippet objectForKey:@"publishedAt"] componentsSeparatedByString:@"T"];
             _date.text = [NSString stringWithFormat:@"%@ в %@",array[0], [(NSString*)array[1] substringToIndex:8 ]];
             _duration.text = [[item objectForKey:@"contentDetails"] objectForKey:@"duration"];
             _viewCount.text = [[item objectForKey:@"statistics"] objectForKey:@"viewCount"];
             _likeCount.text = [[item objectForKey:@"statistics"]objectForKey:@"likeCount"];
             _dislikeCount.text = [[item objectForKey:@"statistics"] objectForKey:@"dislikeCount"];
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

- (BOOL)prefersStatusBarHidden
{
    return !self.sbNeed;
}


@end
