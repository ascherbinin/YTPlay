//
//  GlobalVariable.m
//  YTPlay
//
//  Created by Андрей Щербинин on 20.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import "GlobalVariable.h"

@implementation GlobalVariable
{

}

@synthesize developerKey;
@synthesize searchPatternUrl;
@synthesize mostPopularPatternUrl;

-(id) init
{
    developerKey = @"AIzaSyCzTRyYshWtUlqkE9OP4VOjZbFh7dlxvuo";
    searchPatternUrl = @"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=%@&key=%@";
    mostPopularPatternUrl = @"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PLgMaGEI-ZiiZ0ZvUtduoDRVXcU5ELjPcI&fields=items(contentDetails%2Cid%2Csnippet)&key=%@";
    
    return self;
}

@end
