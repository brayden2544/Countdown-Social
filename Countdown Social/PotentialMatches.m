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
           
        //   NSURL *PotentialMatchesUrl = [NSURL URLWithString:urlAsString];
           
        //   NSMutableURLRequest *potentialMatchesRequest = [NSMutableURLRequest requestWithURL:PotentialMatchesUrl];
           
           
           FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
           
           NSString *FbToken = [session accessTokenData].accessToken;
           
           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
           [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
           NSDictionary *params = @{};
           [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSLog(@"JSON: %@", responseObject);
               NSMutableArray *potentialMatchesArray = responseObject;
               [instance.potentialMatches addObjectsFromArray:potentialMatchesArray];
               [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessful" object:nil];

               //For loop to iterate through array
               for (int i = 0; i < [potentialMatchesArray count] ; i ++) {
                   
                   //Download Video for Each instance in array
                   NSMutableDictionary *currentPotentialMatch = [[NSMutableDictionary alloc]initWithDictionary:[instance.potentialMatches objectAtIndex:i]];
                   [instance.potentialMatches objectAtIndex:i];
                   NSString *videoUrl =[currentPotentialMatch objectForKey:@"videoUri"];
                   NSString *UID = [[currentPotentialMatch objectForKey:@"uid"]stringValue];
                   
                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                   NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",UID]];
                   
                   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                   AFHTTPRequestOperation *operation = [manager GET:videoUrl
                                                  parameters:nil
                                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                         NSLog(@"successful download to %@", path);
                                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                         NSLog(@"Error: %@", error);
                                                     }];
                   operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:YES];
                   [currentPotentialMatch setValue:path forKeyPath:@"fileURL"];
                   [instance.potentialMatches replaceObjectAtIndex:i withObject:currentPotentialMatch];


               }

               
           }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"Error: %@", error);
            }];

           
           
//           [potentialMatchesRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
//           
//           [potentialMatchesRequest setTimeoutInterval:30.0f];
//           [potentialMatchesRequest setHTTPMethod:@"POST"];
//           NSLog(@"IN DISPATCH");
//           NSOperationQueue *potentialMatchesQueue = [[NSOperationQueue alloc] init];
//           
//           [NSURLConnection
//            sendAsynchronousRequest:potentialMatchesRequest
//            queue:potentialMatchesQueue
//            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                
//                if ([data length] >0 && error == nil){
//                    NSString *html =
//                    [[NSString alloc] initWithData:data
//                                          encoding:NSUTF8StringEncoding];
//                    id potentialMatchesJson = [NSJSONSerialization
//                                               JSONObjectWithData:data
//                                               options:NSJSONReadingMutableContainers
//                                               error:&error];
//                    NSMutableArray *potentialMatchesArray = potentialMatchesJson;
//                    [instance.potentialMatches addObjectsFromArray:potentialMatchesArray];
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                    for (int i = 0; i < [potentialMatchesArray count] ; i ++) {
//                    //Download Video
//                    //download the file in a seperate thread.
//                        NSLog(@"Downloading Started");
//                        NSDictionary *currentPotentialMatch = [instance.potentialMatches objectAtIndex:i];
//                        
//                        //Get video Uri
//                        NSURL *videoUrl =[NSURL URLWithString:[currentPotentialMatch objectForKey:@"videoUri"]];
//                        NSData *urlData = [NSData dataWithContentsOfURL:videoUrl];
//                        if ( urlData )
//                        {
//                            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                            NSString  *documentsDirectory = [paths objectAtIndex:0];
//                            
//                            NSString  *filePath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory,[[currentPotentialMatch objectForKey:@"uid"]stringValue]];
//                            
//                            //saving is done on main thread
//                                [urlData writeToFile:filePath atomically:YES];
//                                [currentPotentialMatch setValue:filePath forKey:@"fileURL"];
//                                [instance.potentialMatches replaceObjectAtIndex:i withObject:currentPotentialMatch];
//                                NSLog(@"File Saved !");
//                        }
//                        
//
//                    }
//                    });
//
//                    //NSlog(@"%@",potentialMatchesArray);
//                    
//                }
//                else if ([data length] == 0 && error == nil){
//                    NSLog(@"No Matches Downloaded");
//                }
//                else if (error !=nil){
//                    NSLog(@"Error happened with Potential Matches. = %@", error);
//                    
//                }
          //  }];
           
           
           
       });
       


 
   });

    return instance;
    }

+(PotentialMatches *)nextMatch{
    
    static PotentialMatches *instance = nil;
    instance = [self getInstance];
    NSDictionary *passedUser = [instance.potentialMatches objectAtIndex:0];
    [instance.potentialMatches removeObjectAtIndex:0];
    if ([instance.potentialMatches count] <= 2 ){
        User *obj = [User getInstance];
        NSDictionary *user = obj.user;
        //start filling Potential Matches Queue
        
        
            //Download potential matches here
            NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
            NSString *userID = [[user objectForKey:@"uid"]stringValue];
            urlAsString = [urlAsString stringByAppendingString:userID];
            urlAsString = [urlAsString stringByAppendingString:@"/nextPotentials"];
            NSLog(@"%@", urlAsString);
            
            FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
            
            NSString *FbToken = [session accessTokenData].accessToken;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        NSDictionary *params = @{};
        [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSMutableArray *potentialMatchesArray = responseObject;
            for (int i = 0; i <[potentialMatchesArray count]; i++) {
                if ([[potentialMatchesArray objectAtIndex:i] objectForKey:@"uid"] ==[passedUser objectForKey:@"uid"]) {
                    [potentialMatchesArray removeObjectAtIndex:i];
                }
            }
            [instance.potentialMatches addObjectsFromArray:potentialMatchesArray];
            
            
            //Download Video for each new piece of array
            //download the file in a seperate thread.
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            
            dispatch_async(concurrentQueue, ^{
            for (int i = 0; i < [potentialMatchesArray count] ; i ++) {
                
                //Download Video for Each instance in array
                NSMutableDictionary *currentPotentialMatch = [[NSMutableDictionary alloc]initWithDictionary:[instance.potentialMatches objectAtIndex:i]];
                [instance.potentialMatches objectAtIndex:i];
                NSString *videoUrl =[currentPotentialMatch objectForKey:@"videoUri"];
                NSString *UID = [[currentPotentialMatch objectForKey:@"uid"]stringValue];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",UID]];
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                AFHTTPRequestOperation *operation = [manager GET:videoUrl
                                                      parameters:nil
                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                             dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                                             
                                                             
                                                             dispatch_async(concurrentQueue, ^{
                                                             operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:YES];
                                                             [currentPotentialMatch setValue:path forKeyPath:@"fileURL"];
                                                             [instance.potentialMatches replaceObjectAtIndex:i withObject:currentPotentialMatch];
                                                             NSLog(@"successful download to %@", path);
                                                             });
                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                             NSLog(@"Error: %@", error);
                                                         }];
                
            }
            });

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
        }];
    }
    return instance;
}





@end
