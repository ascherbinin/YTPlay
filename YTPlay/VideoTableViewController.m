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

@property BOOL isMinimized; //  переменная для проверки состояния плейера (уменьшен или нет)
@property BOOL isDetailed; // переменная для проверки состояния view (detail или table)
@property BOOL sbNeed; // переменная для указания необходимости отображать status bar
@property BOOL isCanMinimize; // переменная для указания возможности уменьшения видео плейера

@end

@implementation VideoTableViewController
@synthesize detailView;

#pragma mark - Инициализация и загрузка

- (void)viewDidLoad {
    [super viewDidLoad];

    //Инициализация поиска
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //self.searchController.dimsBackgroundDuringPresentation = NO;
    //[self.searchController setHidesNavigationBarDuringPresentation:NO];
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Поиск!";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.videoView.delegate = self;
    
     self.tableView.tableHeaderView = self.searchController.searchBar;
  
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    
    
    //Задание первоначальных позиций и размеров для player и деталий видео (за экраном)
       CGRect playerViewRect = CGRectMake(0- self.view.frame.size.width,
                                           0 + self.view.frame.size.height,
                                           self.view.frame.size.width,
                                           self.view.frame.size.width / 16 * 9 );
       CGRect detailsViewRect = CGRectMake(playerViewRect.origin.x,
                                            playerViewRect.size.height,
                                            playerViewRect.size.width,
                                   self.view.frame.size.height - playerViewRect.size.height);
   
    
    
    self.videoView.frame = playerViewRect;
    
    self.detailView.frame = detailsViewRect;
    
    
    //Регистрация реакции на свайпы по плееру
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
    
    
    //Загрузка плейлиста в таблицу
    [self loadPlayListVideos:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PLgMaGEI-ZiiZ0ZvUtduoDRVXcU5ELjPcI&fields=items(contentDetails%2Cid%2Csnippet)&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo"];
    
    [self.tableView reloadData];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _videoObjects = [[NSMutableArray alloc] init]; //Инициализация массива для хранения и вывода информации о видео в таблицу
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Блок с отловом событий изменения ориентации

- (void)orientationChanged:(NSNotification *)notification
{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation
{
    
    switch (orientation)
    {
            
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            
            if(_isDetailed == true)
            {
                _isCanMinimize = true;
                NSLog(@"Portrait Orientation");
                CGRect playerViewRect = CGRectMake(0,
                                                   0,
                                                   self.view.frame.size.width,
                                                   self.view.frame.size.width / 16 * 9 );
                self.videoView.frame = playerViewRect;
                
                
                
                CGRect detailsViewRect = CGRectMake(playerViewRect.origin.x,
                                                    playerViewRect.size.height,
                                                    playerViewRect.size.width,
                                                    self.view.frame.size.height - playerViewRect.size.height);
                
                
                
                self.detailView.frame = detailsViewRect;
            }
            
            
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            _isCanMinimize = false;
            
            NSLog(@"Landscape Orientation");
            
            if(_isDetailed == true)
            {
                CGRect playerViewRect = CGRectMake(0,
                                                   0,
                                                   self.view.frame.size.width,
                                                   self.view.frame.size.height);
                self.videoView.frame = playerViewRect;
                
            }
            NSLog(@"%@",NSStringFromCGRect(self.videoView.frame));
            
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}



#pragma mark - Блок с поиском

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



#pragma mark - Работа с таблицей

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  
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
    
    //Загрузка изображения в ячейку
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
    
    
    //Загрузка остальных данных в ячейку таблицы
    cell.title.text =oneVideoItem.videoTitle;
    
    NSArray *array = [oneVideoItem.videoDate componentsSeparatedByString:@"T"];
    cell.date.text = [NSString stringWithFormat:@"Опубликовано: %@ в %@",array[0], [(NSString*)array[1] substringToIndex:8 ]];
    
    return cell;
        
    
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
     
     _isDetailed = true;
     
     if(indexPath)
     {
         YTJsonItem *item = [_videoObjects objectAtIndex:indexPath.row];
         [self.videoView loadWithVideoId:item.videoID playerVars:playerVars];
         
         [self loadVideoInfo:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet%%2C+statistics%%2C+contentDetails&id=%@&key=AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo",item.videoID]];
     }

     [[self navigationController] setNavigationBarHidden:YES animated:YES];

     
// Реализация теней на странице с деталями о видео
     _titleShadow.layer.masksToBounds = NO;
     _titleShadow.layer.shadowColor = [UIColor grayColor].CGColor;
     _titleShadow.layer.shadowOffset = CGSizeMake(0, 0);
     _titleShadow.layer.shadowOpacity = 0.9;
     _titleShadow.layer.shadowRadius = 5;
     _titleShadow.layer.shadowPath = [[UIBezierPath bezierPathWithRect:_titleShadow.layer.bounds] CGPath];
     
     _detailShadow.layer.masksToBounds = NO;
     _detailShadow.layer.shadowColor = [UIColor grayColor].CGColor;
     _detailShadow.layer.shadowOffset = CGSizeMake(0, 0);
     _detailShadow.layer.shadowOpacity = 0.9;
     _detailShadow.layer.shadowRadius = 5;
     _detailShadow.layer.shadowPath = [[UIBezierPath bezierPathWithRect:_titleShadow.layer.bounds] CGPath];
     
     _descriptionShadow.layer.masksToBounds = NO;
     _descriptionShadow.layer.shadowColor = [UIColor grayColor].CGColor;
     _descriptionShadow.layer.shadowOffset = CGSizeMake(0, 0);
     _descriptionShadow.layer.shadowOpacity = 0.9;
     _descriptionShadow.layer.shadowRadius = 5;
     _descriptionShadow.layer.shadowPath = [[UIBezierPath bezierPathWithRect:_titleShadow.layer.bounds] CGPath];

     
     
      [self.view endEditing:YES];
     
     self.sbNeed = NO;
     [self setNeedsStatusBarAppearanceUpdate];
     
 
     //Анимация появления страницы с деталями о видео
         
     
     [UIView animateWithDuration:0.3 animations:^
      {
          CGRect videoViewRect = self.videoView.frame;
          CGRect detailsViewRect = self.detailView.frame;
          
          NSLog(@"Video view frame=%@", NSStringFromCGRect(_videoView.frame));
          NSLog(@"Detail View frame=%@", NSStringFromCGRect(detailView.frame));
          
          videoViewRect.origin.x = 0;
          videoViewRect.origin.y = 0;
          videoViewRect.size.width = self.view.bounds.size.width;
          videoViewRect.size.height = videoViewRect.size.width / 16 * 9 ;
          self.videoView.frame = videoViewRect;
          
          detailsViewRect.origin.x = 0;
          detailsViewRect.origin.y = videoViewRect.size.height;
          self.detailView.frame = detailsViewRect;
          self.detailView.alpha = 1.0;
          
          [[UIApplication sharedApplication] setStatusBarHidden:NO];
          _isCanMinimize = true;
    
      }];
         
       

     
  
 }


#pragma mark - Загрузка данных о плейлисте и видео

-(void) loadPlayListVideos:(NSString*) urlString
{
    
     [_videoObjects removeAllObjects];
    self.loadingView.hidden =false;
    
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
             self.loadingView.hidden = true;
             
         }
         
         [self.tableView reloadData];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         self.loadingView.hidden = true;
         
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

-(void) loadVideoInfo:(NSString*) urlString
{
    
    self.loadingView.hidden =false;

    
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
             NSString *descriptionText = [snippet objectForKey:@"description"];
             if([descriptionText isEqualToString:@""])
             {
                 _textView.text = @"Описание отсутствует";
             }
             else
             {
                 _textView.text = descriptionText;
                 
             }
             NSArray *array = [[snippet objectForKey:@"publishedAt"] componentsSeparatedByString:@"T"];
             _date.text = [NSString stringWithFormat:@"%@ в %@",array[0], [(NSString*)array[1] substringToIndex:8 ]];
             NSMutableString *duration = [[item objectForKey:@"contentDetails"] objectForKey:@"duration"];
             
             
             _duration.text = [self changeYouTubeDurationToNormal:duration];
             
             _viewCount.text = [[item objectForKey:@"statistics"] objectForKey:@"viewCount"];
             _likeCount.text = [[item objectForKey:@"statistics"]objectForKey:@"likeCount"];
             _dislikeCount.text = [[item objectForKey:@"statistics"] objectForKey:@"dislikeCount"];
         }
         
         self.loadingView.hidden =true;

     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         self.loadingView.hidden =true;
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

#pragma mark - Блок по работе с свайпами и уменьшением видео


- (void)swipeDown:(UIGestureRecognizer *)gr {
    [self minimizeVideo:YES animated:YES];
    NSLog(@"Swipe Down");
}

- (void)swipeUp:(UIGestureRecognizer *)gr {
    [self minimizeVideo:NO animated:YES];
    NSLog(@"Swipe Up");
}

- (void)swipeLeft:(UIGestureRecognizer *)gr {
    NSLog(@"Swipe Left");
    if(![self IsMinimized])
    {
        return;
    }
    _isDetailed = false;
    CGRect playerFrame = self.videoView.frame;
    playerFrame.origin.x = -self.videoView.frame.size.width;

  
    [UIView animateWithDuration:0.3 animations:^{
        
        self.videoView.frame = playerFrame;
        [self.videoView stopVideo];
    }];
}


- (void)minimizeVideo:(BOOL)minimized animated:(BOOL)animated {
    
    if ([self IsMinimized] == minimized) return;
    
    CGRect fullContainerFrame, smallContainerFrame;
    CGFloat fullContainerAlpha;
    
    if (minimized && _isCanMinimize)
    {
        CGFloat mpWidth = self.videoView.frame.size.width / 2;
        CGFloat mpHeight = self.videoView.frame.size.height / 2;
        
        CGFloat x = self.view.bounds.size.width-mpWidth - 20;
        CGFloat y = self.view.bounds.size.height-mpHeight - 20;
      
        
        fullContainerFrame = CGRectMake(0, self.view.frame.size.height,
                                        self.detailView.frame.size.width, self.detailView.frame.size.height);
        
        _isDetailed = false;
        
        smallContainerFrame = CGRectMake(x, y, mpWidth, mpHeight);
        fullContainerAlpha = 0.0;
        
        self.searchController.active = NO;
        [self.view endEditing:YES];
        
        self.sbNeed = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    else
    {
        _isDetailed = true;
        
        smallContainerFrame.origin.x = 0;
        smallContainerFrame.origin.y = 0;
        smallContainerFrame.size.width = self.view.bounds.size.width;
        smallContainerFrame.size.height = smallContainerFrame.size.width / 16 * 9;
        
        fullContainerFrame = self.detailView.frame;
        fullContainerFrame.origin.y = smallContainerFrame.size.height;
        fullContainerAlpha = 1.0;
        
      
        self.sbNeed = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
    
    
    [UIView animateWithDuration:(animated)? 0.3 : 0.0 animations:^{
        
        //self.youTubePlayer.frame = containerFrame;
        self.videoView.frame = smallContainerFrame;
        // self.playerView.webView.frame = CGRectMake(0, 0, containerFrame.size.width, containerFrame.size.height);
        self.detailView.frame = fullContainerFrame;
        self.detailView.alpha = fullContainerAlpha;
        
    }];
}



#pragma mark - Вспомогательные методы

- (BOOL)prefersStatusBarHidden
{
    return !self.sbNeed;
}

- (BOOL)IsMinimized {
    return self.videoView.frame.origin.y > 50;
}

- (NSString *)replaceWhiteByPlus:(NSString *)string {
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSString *trimmedReplacement = [[string componentsSeparatedByCharactersInSet:charactersToRemove]
                                    componentsJoinedByString:@"+"];
    
    return trimmedReplacement;
    
}

-(NSString*) changeYouTubeDurationToNormal:(NSMutableString*)duration
{
    NSString *temp = [duration substringFromIndex:2];
    //temp = [temp substringToIndex:[temp length] - 1];
    duration = [NSMutableString stringWithString: temp];
    int i = 0;
    int length = (int)[duration length];
    while (i<length)
    {
        char c = [duration characterAtIndex:i];
        if(!(c>='0' && c<='9'))
        {
            NSRange range = {i,1};
            switch (c)
            {
                case 'H':
                    [duration replaceCharactersInRange:range withString:@"ч:"];
                    i++;
                    length++;
                    break;
                case 'M':
                    [duration replaceCharactersInRange:range withString:@"м:"];
                    i++;
                    length++;
                    break;
                case 'S':
                    [duration replaceCharactersInRange:range withString:@"с"];
                    break;
                case ':':
                    break;
                default:
                    [duration replaceCharactersInRange:range withString:@" "];
                    break;
            }
        }
        i++;
    }
    return duration;
}


@end
