//
//  PotentialMatches.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/19/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "PotentialMatches.h"
#import "AppDelegate.h"
#import "User.h"

@implementation PotentialMatches
@synthesize potentialMatches;
@synthesize user;

+(PotentialMatches *)getInstance{
    static PotentialMatches *instance = nil;
    static dispatch_once_t onceToken;
    
   dispatch_once(&onceToken, ^{
            instance= [[self alloc]init];
       instance.potentialMatches = [[NSMutableArray alloc]init];
       User *obj = [User getInstance];
       NSDictionary *user = obj.user;
       //start filling Potential Matches Queue
       dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       
       
       dispatch_async(concurrentQueue, ^{
           //Download potential matches here
           NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
           NSString *userID = [[user objectForKey:@"uid"]stringValue];
           urlAsString = [urlAsString stringByAppendingString:userID];
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
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                    for (int i = 0; i < [potentialMatchesArray count]; i ++) {
                    //Download Video
                    //download the file in a seperate thread.
                        NSLog(@"Downloading Started");
                        NSDictionary *currentPotentialMatch = [instance.potentialMatches objectAtIndex:i];
                        
                        //Get video Uri
                        NSURL *videoUrl =[NSURL URLWithString:[currentPotentialMatch objectForKey:@"videoUri"]];
                        //NSString *urlToDownload = @"http://www.somewhere.com/thefile.mp4";
                        //NSURL  *url = [NSURL URLWithString:urlToDownload];
                        NSData *urlData = [NSData dataWithContentsOfURL:videoUrl];
                        if ( urlData )
                        {
                            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString  *documentsDirectory = [paths objectAtIndex:0];
                            
                            NSString  *filePath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory,[[currentPotentialMatch objectForKey:@"uid"]stringValue]];
                            
                            //saving is done on main thread
                                [urlData writeToFile:filePath atomically:YES];
                                [currentPotentialMatch setValue:filePath forKey:@"fileURL"];
                                [instance.potentialMatches replaceObjectAtIndex:0 withObject:currentPotentialMatch];
                                NSLog(@"File Saved !");
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessful" object:nil];
                            

                        }
                        

                    }
                    });

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
    [instance.potentialMatches removeObjectAtIndex:0];
//    NSMutableArray *matches = instance.potentialMatches;
//    if ([instance.potentialMatches count ] > 1){
//    [matches removeObjectAtIndex:0];
//     instance.potentialMatches = matches;
//    }
//    NSLog(@"@%d",[instance.potentialMatches count]);

    if ([instance.potentialMatches count] <= 2 ){
        User *obj = [User getInstance];
        NSDictionary *user = obj.user;
        //start filling Potential Matches Queue
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        
        dispatch_async(concurrentQueue, ^{
            //Download potential matches here
            NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
            NSString *userID = [[user objectForKey:@"uid"]stringValue];
            urlAsString = [urlAsString stringByAppendingString:userID];
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
                                         id potentialMatchesJson = [NSJSONSerialization
                                                JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                error:&error];
                     NSMutableArray *potentialMatchesArray = potentialMatchesJson;
                     PotentialMatches *obj =[PotentialMatches getInstance];
                     //Iterate through array for duplicate potential Matches
                     for (int i = 0; i <[instance.potentialMatches count] -1; i++) {
                         NSString *uid = [[[instance.potentialMatches objectAtIndex:i] objectForKey:@"uid"] stringValue];
                         for (int n = 0; n < [potentialMatchesArray count] -1; n++) {
                             if ([[[[potentialMatchesArray objectAtIndex:n] objectForKey:@"uid"]stringValue] isEqualToString:uid]){
                                 [potentialMatchesArray removeObjectAtIndex:n];
                             }
                         }
                     }
                     
                    //[instance.potentialMatches addObjectsFromArray:potentialMatchesArray];
                     NSLog(@"getting next matches%@",[obj.potentialMatches objectAtIndex:0]);
                     //Download Video for each new piece of array
                     //download the file in a seperate thread.
                     for (int i = 0; i < [potentialMatchesArray count] -1; i++) {
                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                         NSLog(@"Downloading Started");
                         NSDictionary *currentPotentialMatch = [potentialMatchesArray objectAtIndex:i];
                         
                         //Get video Uri
                         NSURL *videoUrl =[NSURL URLWithString:[currentPotentialMatch objectForKey:@"videoUri"]];
                         
                         NSData *urlData = [NSData dataWithContentsOfURL:videoUrl];
                         if ( urlData )
                         {
                             NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                             NSString  *documentsDirectory = [paths objectAtIndex:0];
                             
                             NSString  *filePath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory,[[currentPotentialMatch objectForKey:@"uid"]stringValue]];
                             
                             //saving is done on main thread
                                 [urlData writeToFile:filePath atomically:YES];
                                 [currentPotentialMatch setValue:filePath forKey:@"fileURL"];
                                 //[potentialMatchesArray replaceObjectAtIndex:0 withObject:currentPotentialMatch];
                                 [instance.potentialMatches addObject:currentPotentialMatch];
                                 NSLog(@"File Saved !");
                                 
                         }
                         
                     });

                     }
                     
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





@end
