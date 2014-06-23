//
//  User.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/23/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize user;

+(User*)getInstance{
    static User *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        instance.user = [[NSDictionary alloc]init];
    
    }); return instance;
}

@end
