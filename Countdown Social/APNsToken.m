//
//  APNsToken.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/23/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "APNsToken.h"

@implementation APNsToken

@synthesize APNsToken;

+(APNsToken*)getInstance{
    static APNsToken *instance = nil;
    static dispatch_once_t onceTokenAPNS;
    
    dispatch_once(&onceTokenAPNS, ^{
        instance = [[self alloc]init];
        instance.APNsToken = [[NSString alloc]init];
        
    }); return instance;
}

@end
