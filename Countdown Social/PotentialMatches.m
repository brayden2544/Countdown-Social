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
                   NSString *videoUrlString =[currentPotentialMatch objectForKey:@"videoUri"];
                   NSString *UID = [[currentPotentialMatch objectForKey:@"uid"]stringValue];
                   NSURL *videoURl = [NSURL URLWithString:videoUrlString];
                   NSURLRequest *videoRequest = [NSURLRequest requestWithURL:videoURl];
                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                   NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",UID]];
                   
                   AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
                   [[sessionManager dataTaskWithRequest:videoRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                       
                   }] resume];
                   
                   NSURLSessionDownloadTask *videoDownload = [sessionManager downloadTaskWithRequest:videoRequest progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                       NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject]];
                       return [documentsDirectoryPath URLByAppendingPathComponent:[targetPath lastPathComponent]];
                   } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       NSLog(@"File downloaded to: %@", filePath);
                       [currentPotentialMatch setValue:filePath forKeyPath:@"fileURL"];
                   }];
                   [videoDownload resume];

               }

               
           }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"Error: %@", error);
            }];

   });

    return instance;
    }

+(PotentialMatches *)nextMatch{
    
    static PotentialMatches *instance = nil;
    instance = [self getInstance];
    NSDictionary *passedUser;
    if ([instance.potentialMatches count] >0) {
        passedUser = [instance.potentialMatches objectAtIndex:0];
        [instance.potentialMatches removeObjectAtIndex:0];
    }
    
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
                [manager GET:videoUrl
                                                      parameters:nil
                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                             dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                                             
                                                             
                                                             operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:YES];
                                                             [currentPotentialMatch setValue:path forKeyPath:@"fileURL"];
                                                             [instance.potentialMatches replaceObjectAtIndex:i withObject:currentPotentialMatch];
                                                             NSLog(@"successful download to %@", path);
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
