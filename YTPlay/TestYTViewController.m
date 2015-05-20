//
//  TestYTViewController.m
//  YTPlay
//
//  Created by Андрей Щербинин on 18.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import "TestYTViewController.h"
#import "YTPlayerView.h"

@interface TestYTViewController ()

@end

@implementation TestYTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//        NSLog(@"Nav Size - %f",self.navigationController.navigationBar.frame.size.height);
//    YTWebView *youTubeView = [[YTWebView alloc]
//                                initWithStringAsURL:@"http://www.youtube.com/watch?v=dt_5TE-lfwQ"
//                                frame:CGRectMake(100, 170, 120, 120)];
//    youTubeView.backgroundColor = [UIColor blueColor];
//    [[self view] addSubview:youTubeView];
    [self.playerView loadWithVideoId:@"dt_5TE-lfwQ"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
