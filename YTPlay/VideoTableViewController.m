//
//  VideoTableTableViewController.m
//  YTPlay
//
//  Created by Андрей Щербинин on 18.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import "VideoTableViewController.h"
#import "TestYTViewController.h"
#import "TableVideoCell.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "YTJsonItem.h"
#import "MBProgressHUD.h"
#import "VideoDetailViewController.h"



@interface VideoTableViewController ()

@property (nonatomic,strong) NSMutableArray* videoObjects;

@end

@implementation VideoTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //GlobalVariable *gl = [[GlobalVariable alloc]init];
    
    self.searchBar = [[UISearchBar alloc] init];
    
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
    TableVideoCell *cell = (TableVideoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableVideoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    YTJsonItem *oneVideoItem = [_videoObjects objectAtIndex:indexPath.row];
    
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"showinfo" :@0,
                                 @"controls" :@2,
                                 
                                 };
    NSLog(@"Номер строки - %ld",(long)[indexPath row]);
    
   [cell.ytPlayerView loadWithVideoId:oneVideoItem.videoID playerVars:playerVars];
    
//    NSString *imageStringURL = oneVideoItem.thumbURl;;
//        NSURL* imageURL = [NSURL URLWithString: imageStringURL];
//        if(imageURL != nil)
//        {
//            [cell.ytPlayerView setImageWithURL: imageURL];
//        }
//        else
//        {
//            cell.imageView.image = [UIImage imageNamed:@"glnews.png"];
//        }
    
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
 // Navigation logic may go here. Create and push another view controller.
 // If you want to push another view upon tapping one of the cells on your table.
 
 
 VideoDetailViewController *detailVideoViewController = [[VideoDetailViewController alloc] initWithNibName:@"VideoDetailViewController" bundle:nil];
 
 if(indexPath)
 {
 YTJsonItem *item = [_videoObjects objectAtIndex:indexPath.row];
 [detailVideoViewController getVideoID:item.videoID];
 }
 // ...
 // Pass the selected object to the new view controller.
 [self.navigationController pushViewController:detailVideoViewController animated:YES];
 
 }

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *nameSection;
    switch (section) {
        case 0:
            nameSection = @"Популярное на YouTube";
            break;
            
        default:
            break;
    }
    return nameSection;
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
             tempYTItem.thumbURl= [[[snippet objectForKey:@"thumbnails"] objectForKey:@"default"] objectForKey:@"url"];
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


@end
