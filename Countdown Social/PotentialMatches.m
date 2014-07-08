//
//  PotentialMatches.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/19/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "PotentialMatches.h"
#import "AppDelegate.h"

@implementation PotentialMatches
@synthesize potentialMatches;

+(PotentialMatches *)getInstance{
    static PotentialMatches *instance = nil;
    static dispatch_once_t onceToken;
    
   dispatch_once(&onceToken, ^{
            instance= [[self alloc]init];
       instance.potentialMatches = [[NSMutableArray alloc]init];
       //start filling Potential Matches Queue
       dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       
       
       dispatch_async(concurrentQueue, ^{
           //Download potential matches here
           NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
           // TODO:NSString *userID = [user objectForKey:@"uid"];
           urlAsString = [urlAsString stringByAppendingString:@"690825080"];
           urlAsString = [urlAsString stringByAppendingString:@"/nextPotentials"];
           NSLog(@"%@", urlAsString);
           
           NSURL *PotentialMatchesUrl = [NSURL URLWithString:urlAsString];
           
           NSMutableURLRequest *potentialMatchesRequest = [NSMutableURLRequest requestWithURL:PotentialMatchesUrl];
           
           
           FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
           
           NSString *FbToken = [session accessTokenData].accessToken;
           [potentialMatchesRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
           
           [potentialMatchesRequest setTimeoutInterval:30.0f];
           [potentialMatchesRequest setHTTPMethod:@"POST"];
           NSLog(@"IN DISPATCH");
           NSOperationQueue *potentialMatchesQueue = [[NSOperationQueue alloc] init];
           
           [NSURLConnection
            sendAsynchronousRequest:potentialMatchesRequest
            queue:potentialMatchesQueue
            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                
                if ([data length] >0 && error == nil){
                    NSString *html =
                    [[NSString alloc] initWithData:data
                                          encoding:NSUTF8StringEncoding];
                    id potentialMatchesJson = [NSJSONSerialization
                                               JSONObjectWithData:data
                                               options:NSJSONReadingMutableContainers
                                               error:&error];
                    NSMutableArray *potentialMatchesArray = potentialMatchesJson;
                    [instance.potentialMatches addObjectsFromArray:potentialMatchesArray];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessful" object:nil];
                    //NSlog(@"%@",potentialMatchesArray);
                    
                }
                else if ([data length] == 0 && error == nil){
                    NSLog(@"No Matches Downloaded");
                }
                else if (error !=nil){
                    NSLog(@"Error happened with Potential Matches. = %@", error);
                    
                }
            }];
           
           
           
       });
       


       
   }); return instance;
    }

+(PotentialMatches *)nextMatch{
    static PotentialMatches *instance = nil;
    instance = [self getInstance];
    NSMutableArray *matches = instance.potentialMatches;
    if ([matches count ] > 0){
    [matches removeObjectAtIndex:0];
     instance.potentialMatches = matches;
    }
    NSLog(@"@%d",[instance.potentialMatches count]);

    if ([matches count] <= 2 ){
        //start filling Potential Matches Queue
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        
        dispatch_async(concurrentQueue, ^{
            //Download potential matches here
            NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
            // TODO:NSString *userID = [user objectForKey:@"uid"];
            urlAsString = [urlAsString stringByAppendingString:@"690825080"];
            urlAsString = [urlAsString stringByAppendingString:@"/nextPotentials"];
            NSLog(@"%@", urlAsString);
            
            NSURL *PotentialMatchesUrl = [NSURL URLWithString:urlAsString];
            
            NSMutableURLRequest *potentialMatchesRequest = [NSMutableURLRequest requestWithURL:PotentialMatchesUrl];
            
            
            FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
            
            NSString *FbToken = [session accessTokenData].accessToken;
            [potentialMatchesRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
            
            [potentialMatchesRequest setTimeoutInterval:30.0f];
            [potentialMatchesRequest setHTTPMethod:@"POST"];
            NSLog(@"IN DISPATCH");
            NSOperationQueue *potentialMatchesQueue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection
             sendAsynchronousRequest:potentialMatchesRequest
             queue:potentialMatchesQueue
             completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 
                 if ([data length] >0 && error == nil){
                     NSString *html =
                     [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
                     id potentialMatchesJson = [NSJSONSerialization
                                                JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                error:&error];
                     NSMutableArray *potentialMatchesArray = potentialMatchesJson;
                     PotentialMatches *obj =[PotentialMatches getInstance];
                     [instance.potentialMatches addObjectsFromArray:potentialMatchesArray];
                     NSLog(@"%@",[obj.potentialMatches objectAtIndex:0]);
                     
                 }
                 else if ([data length] == 0 && error == nil){
                     NSLog(@"No Matches Downloaded");
                 }
                 else if (error !=nil){
                     NSLog(@"Error happened with Potential Matches. = %@", error);
                     
                 }
             }];
            
            
            
        });

    }
    return instance;
}
//-(id)init{
//    if (self = [super init]) {
//        potentialMatches = [NSMutableArray arrayWithCapacity:100];
//    }
//    return self;
//}


@end
