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
@synthesize passedUsers;

+(PotentialMatches *)getInstance{
        static dispatch_once_t onceToken;
        static PotentialMatches *instance;

    dispatch_once(&onceToken, ^{
        instance= [[self alloc]init];
        instance.potentialMatches = [[NSMutableArray alloc]init];
        instance.passedUsers = [[NSMutableArray alloc]init];
        User *obj = [User getInstance];
        NSDictionary *user = obj.user;
        //start filling Potential Matches Queue
        
        
        //Download potential matches here
        NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
        NSString *userID = [user objectForKey:@"uid"];
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
            NSMutableArray *tempPotentialMatches = [[NSMutableArray alloc]initWithArray:instance.potentialMatches];
            
            for (id obj in instance.potentialMatches) {
                
                ///Download Video for Each instance in array
                NSMutableDictionary *currentPotentialMatch = [[NSMutableDictionary alloc]initWithDictionary:obj];
                NSString *videoUrlString =[currentPotentialMatch objectForKey:@"videoUri"];
                NSURL *videoURl = [NSURL URLWithString:videoUrlString];
                NSURLRequest *videoRequest = [NSURLRequest requestWithURL:videoURl];
                
                AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSURLSessionDownloadTask *videoDownload =[sessionManager downloadTaskWithRequest:videoRequest progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    
                    NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
                    return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
                }
                                                                               completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                                   NSLog(@"Video Saved at %@",filePath);
                                                                                   [currentPotentialMatch setValue:filePath forKey:@"fileURL"];
                                                                                   [tempPotentialMatches replaceObjectAtIndex:[instance.potentialMatches indexOfObject:obj] withObject:currentPotentialMatch];
                                                                                   
                                                                               }];
                [videoDownload resume];
            }
            instance.potentialMatches = tempPotentialMatches;
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
    if ([instance.potentialMatches count] >0) {
        //instance.passedUsers = [instance.potentialMatches objectAtIndex:0];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtURL:[[instance.potentialMatches objectAtIndex:0] objectForKey:@"fileURL"] error:NULL];
//        NSLog(@"Item deleted");
        [instance.potentialMatches removeObjectAtIndex:0];
    }
    
    if ([instance.potentialMatches count] <= 2 ){
        User *obj = [User getInstance];
        NSDictionary *user = obj.user;
        //start filling Potential Matches Queue
        
        
        //Download potential matches here
        NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
        NSString *userID = [user objectForKey:@"uid"];
        urlAsString = [urlAsString stringByAppendingString:userID];
        urlAsString = [urlAsString stringByAppendingString:@"/nextPotentials"];
        NSLog(@"%@", urlAsString);
        
        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        
        NSString *FbToken = [session accessTokenData].accessToken;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        NSDictionary *params = @{};
        [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            
            NSMutableArray *temppotentialMatchArray1 = [[NSMutableArray alloc]initWithArray:responseObject];
            NSMutableArray *potentialMatchArray = [[NSMutableArray alloc]initWithArray:responseObject];
            for (NSDictionary *potentialMatch in temppotentialMatchArray1){
                for (NSDictionary *currentPotenialMatch in instance.potentialMatches){
                    if ([[potentialMatch objectForKey:@"uid"] isEqual:[currentPotenialMatch objectForKey:@"uid"]]) {
                        [potentialMatchArray removeObjectIdenticalTo:potentialMatch];
                        NSLog(@"removed: %@",[potentialMatch objectForKey:@"uid"]);
                    }
                }
            }
            
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:potentialMatchArray];
                if ([instance.passedUsers count]>0) {
                    for ( NSDictionary *passedUser in instance.passedUsers) {
                    for (NSDictionary *potentialUser in tempArray){
                        if ([[passedUser objectForKey:@"uid"] isEqual:[potentialUser objectForKey:@"uid"]]) {
                            [potentialMatchArray removeObjectIdenticalTo:potentialUser];
                            NSLog(@"removed: %@",[potentialUser objectForKey:@"uid"]);
                            NSLog(@"removed");

                        }
                    }
                }
            }
            
            [instance.potentialMatches addObjectsFromArray:potentialMatchArray];
            
            
            
            //Download Video for each new piece of array
            //download the file in a seperate thread.
            
            NSMutableArray *tempPotentialMatches = [[NSMutableArray alloc]initWithArray:instance.potentialMatches];
            
            for (id obj in instance.potentialMatches) {
                if ([obj objectForKey:@"fileURL"]) {
                    NSLog(@"Video Already Downloaded");
                }
                else{
                    ///Download Video for Each instance in array
                    NSMutableDictionary *currentPotentialMatch = [[NSMutableDictionary alloc]initWithDictionary:obj];
                    NSString *videoUrlString =[currentPotentialMatch objectForKey:@"videoUri"];
                    NSURL *videoURl = [NSURL URLWithString:videoUrlString];
                    NSURLRequest *videoRequest = [NSURLRequest requestWithURL:videoURl];
                    
                    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    NSURLSessionDownloadTask *videoDownload =[sessionManager downloadTaskWithRequest:videoRequest progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                        
                        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
                        return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
                    }
                                                                                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                                       NSLog(@"Video Saved at %@",filePath);
                                                                                       [currentPotentialMatch setValue:filePath forKey:@"fileURL"];
                                                                                       [tempPotentialMatches replaceObjectAtIndex:[tempPotentialMatches indexOfObject:obj] withObject:currentPotentialMatch];
                                                                                       
                                                                                   }];
                    [videoDownload resume];
                }
                instance.potentialMatches = tempPotentialMatches;
            }
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"failed");
              }];
        
    }
    return instance;
}





@end
