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
    static ConnectionsList *instance;
    static dispatch_once_t onceToken;
    User *obj = [User getInstance];
    NSDictionary *user = obj.user;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        instance.connections = [[NSMutableArray alloc]init];
        //download initial connections
        NSString *urlAsString =[NSString stringWithFormat:@"http://countdown-java-dev.elasticbeanstalk.com/user/%@/matches/all", [user objectForKey:@"uid"]];
        
        
        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        
        NSString *FbToken = [session accessTokenData].accessToken;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        NSDictionary *params = @{};
        [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [instance.connections addObjectsFromArray: responseObject];
            NSLog(@"%d Connections ",[instance.connections count]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newConnections" object:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Connections not downloaded %@",error);
        }];
                  urlAsString =[NSString stringWithFormat:@"http://countdown-java-dev.elasticbeanstalk.com/user/%@/matches/new", [user objectForKey:@"uid"]];
                  [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * newConnections = [[NSMutableArray alloc]initWithArray:instance.connections];
        for (NSDictionary *newConnection in responseObject) {
            for (NSDictionary *connection in newConnections) {
                if ([[NSString stringWithFormat:@"%@",[[connection objectForKey:@"liked_user"]objectForKey:@"uid"]] isEqualToString:[NSString stringWithFormat:@"%@",[[newConnection objectForKey:@"liked_user"]objectForKey:@"uid"]]]) {
                    NSMutableDictionary *newConnectionWithNotification = [[NSMutableDictionary alloc]initWithDictionary: newConnection];
                    [newConnectionWithNotification setValue:@true forKey:@"is_new"];
                    [instance.connections replaceObjectAtIndex:[instance.connections indexOfObjectIdenticalTo:connection] withObject:newConnectionWithNotification];
                }
            }
        }
        
        NSLog(@"Connections %@",instance.connections);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Connections not downloaded %@",error);
    }
                   ];
        
        dispatch_queue_t backgroundQueue= dispatch_queue_create("backgroundQueue", 0);
        dispatch_async(backgroundQueue, ^{
            [NSTimer scheduledTimerWithTimeInterval: 90
                                             target: self
                                           selector:@selector(updateMatches)
                                           userInfo: nil repeats:YES];
            
            
            [self updateMatches];
            
        });
    }); return instance;
    
    
    
}

+(ConnectionsList*)updateMatches{
    static ConnectionsList *instance;
    instance = [self getInstance];
    User *obj = [User getInstance];
    NSDictionary *user = obj.user;
    //download initial connections
    NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
    NSString *userID = [user objectForKey:@"uid"];
    urlAsString = [urlAsString stringByAppendingString:userID];
    urlAsString = [urlAsString stringByAppendingString:@"/matches/new"];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    NSString *FbToken = [session accessTokenData].accessToken;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSDictionary *params = @{};
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count]>0) {
            
            NSLog(@"new connections%@" , responseObject);
            NSMutableArray *connections = [[NSMutableArray alloc]init];
            for (NSMutableDictionary *newConnections in responseObject) {
                NSMutableDictionary *connection = [[NSMutableDictionary alloc]initWithDictionary: newConnections];
                [connection setValue:@true forKey:@"is_new"];
                [connections addObject:connection];
            }
            
            NSMutableArray *newConnections = [[NSMutableArray alloc]initWithArray:connections];
            for (NSMutableDictionary *connection in instance.connections) {
                for (NSMutableDictionary *newConnection in connections) {
                    if ([[NSString stringWithFormat:@"%@",[[connection objectForKey:@"liked_user"]objectForKey:@"uid"]]  isEqualToString:[NSString stringWithFormat:@"%@",[[newConnection objectForKey:@"liked_user"]objectForKey:@"uid"]]] ) {
                        [newConnections removeObjectAtIndex:[newConnections indexOfObjectIdenticalTo:newConnection]];
                        NSLog(@"user is same");
                    }
                }
            }
            [instance.connections addObjectsFromArray:newConnections];
            NSLog(@"%d New Connections", [newConnections count]);
            if ([newConnections count]>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newConnections" object:nil];
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Connections not downloaded %@",error);
    }
     ];
    
    return instance;
}



@end
