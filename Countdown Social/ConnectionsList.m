//
//  ConnectionsList.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/28/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ConnectionsList.h"
#import "AppDelegate.h"

@implementation ConnectionsList
@synthesize connections;

+(ConnectionsList*)getInstance{
    static ConnectionsList *instance = nil;
    static dispatch_once_t onceToken;
    User *obj = [User getInstance];
    NSDictionary *user = obj.user;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        instance.connections = [[NSMutableArray alloc]init];
        //download initial connections
        NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
        NSString *userID = [user objectForKey:@"uid"];
        urlAsString = [urlAsString stringByAppendingString:userID];
        urlAsString = [urlAsString stringByAppendingString:@"/matches/all"];
        
        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        
        NSString *FbToken = [session accessTokenData].accessToken;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        NSDictionary *params = @{};
        [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            instance.connections = responseObject;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessful" object:nil];
            NSLog(@"Connections %@",instance.connections);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Connections not downloaded %@",error);
        }
         ];
        
    }); return instance;
}


@end
