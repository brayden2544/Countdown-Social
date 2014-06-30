//
//  VideoPath.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/30/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "VideoPath.h"

@implementation VideoPath


@synthesize videoPath;

+ (VideoPath*)getInstance{
    static VideoPath *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        instance.videoPath = @"Default Video Path";
        
    }); return instance;
}

@end