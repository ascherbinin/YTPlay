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



@interface VideoTableViewController ()

@property (nonatomic,strong) NSMutableArray* videoObjects;

@end

@implementation VideoTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openVideo)];
    self.navigationItem.rightBarButtonItem = item;
    
  
    
    self.searchBar = [[UISearchBar alloc] init];
    
    [self loadPlayListVideos:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PLgMaGEI-ZiiZ0ZvUtduoDRVXcU5ELjPcI&fields=items(contentDetails%2Cid%2Csnippet)&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo"];
    
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
    
    NSString *str = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=%@&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo",searchBar.text];
    
    [self loadPlayListVideos:str];
    
}
    
    //[self loadPlayListVideos:str];
    

                   
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [self.view endEditing:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 250;
}


-(void) loadPlayListVideos:(NSString*) urlString
{
    
   
    
    NSURL *mostPopularURL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:mostPopularURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *items = [responseObject objectForKey:@"items"];
         NSLog(@"JSON Retrieved");
         NSLog(@"%@", self.videoObjects);
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
    cell.description.text =oneVideoItem.videoID;
    cell.date.text = [NSString stringWithFormat:@"Дата публикации: %@",oneVideoItem.videoDate];

  //  cell.date.text = @"Дата публикации: %d",oneVideoItem.videoDate;
    
    return cell;
        
    
}


-(void) openVideo
{
    [self.navigationController pushViewController:self.ytViewController animated:YES];
    
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
    
//    BOOL isFetchingPlaylist = (_channelListTicket != nil || _playlistItemListTicket != nil);
//    if (isFetchingPlaylist) {
//        [_playlistProgressIndicator startAnimation:self];
//    } else {
//        [_playlistProgressIndicator stopAnimation:self];
//    }


}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

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

@end
