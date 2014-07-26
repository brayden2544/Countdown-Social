//
//  Connection.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/25/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "Connection.h"

@implementation Connection
@synthesize connection;

+(Connection*)getInstance{
    static Connection *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        instance.connection = [[NSDictionary alloc]init];
        
    }); return instance;
}

@end

