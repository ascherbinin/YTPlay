//
//  GlobalVariable.h
//  YTPlay
//
//  Created by Андрей Щербинин on 20.05.15.
//  Copyright (c) 2015 Андрей Щербинин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariable : NSObject

@property (nonatomic,strong) NSString *developerKey;

@property (nonatomic,strong) NSString *searchPatternUrl;

@property (nonatomic,strong) NSString *mostPopularPatternUrl;

@end
