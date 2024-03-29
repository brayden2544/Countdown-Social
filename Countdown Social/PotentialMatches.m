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
#import "Constants.h"

@implementation PotentialMatches
@synthesize potentialMatches;
@synthesize user;
@synthesize passedUsers;
@synthesize moreMatchesTimer;

+(PotentialMatches *)getInstance{
    static dispatch_once_t onceToken;
    static PotentialMatches *instance;
    
    dispatch_once(&onceToken, ^{
        instance= [[self alloc]init];
        instance.potentialMatches = [[NSMutableArray alloc]init];
        User *obj = [User getInstance];
        NSDictionary *user = obj.user;
        instance.passedUsers = [[NSMutableArray alloc] init];
        //start filling Potential Matches Queue
        
        
        //Download potential matches here
        NSString *urlAsString =kBaseURL;
        urlAsString = [urlAsString stringByAppendingString: @"user/"];
        NSString *userID = [user objectForKey:@"uid"];
        urlAsString = [urlAsString stringByAppendingString:userID];
        urlAsString = [urlAsString stringByAppendingString:@"/nextPotentials"];
        
        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        
        NSString *FbToken = [session accessTokenData].accessToken;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        NSDictionary *params = @{};
        [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSMutableArray *potentialMatchesArray = responseObject;
            [instance.potentialMatches addObjectsFromArray:potentialMatchesArray];
            
            //For loop to iterate through array
            NSMutableArray *tempPotentialMatches = [[NSMutableArray alloc]initWithArray:instance.potentialMatches];
            
            for (id obj in instance.potentialMatches) {
            if ([obj objectForKey:@"video_uri"]== [NSNull null] ){
                NSLog(@"no video");
                NSString *FbToken = [session accessTokenData].accessToken;
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
                NSMutableDictionary *currentPotentialMatch = [[NSMutableDictionary alloc]initWithDictionary:obj];
                manager.responseSerializer = [AFImageResponseSerializer serializer];
                NSString *picURL = kBaseURL;
                picURL = [picURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/photo", [currentPotentialMatch objectForKey:@"uid"]]];
                [manager GET:picURL parameters:@{@"height":@640,
                                                 @"width": @640} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    NSLog(@"Photo Object %@",responseObject);
                                                     if ([instance.potentialMatches indexOfObject:obj] < [tempPotentialMatches count]){
                                                     [currentPotentialMatch setObject:responseObject forKey:@"profilePic"];
                                                     [tempPotentialMatches replaceObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj] withObject:currentPotentialMatch];
                                                     }
                                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     NSLog(@"Photo failed to load%@",error);
                                                     if ([instance.potentialMatches indexOfObject:obj] < [tempPotentialMatches count]){
                                                     [tempPotentialMatches removeObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj]];
                                                     }
                                                 }];

                //[tempPotentialMatches addObject:obj];
            }else{

                ///Download Video for Each instance in array
                NSMutableDictionary *currentPotentialMatch = [[NSMutableDictionary alloc]initWithDictionary:obj];
                NSString *videoUrlString =[currentPotentialMatch objectForKey:@"video_uri"];
                NSURL *videoURl = [NSURL URLWithString:videoUrlString];
                NSURLRequest *videoRequest = [NSURLRequest requestWithURL:videoURl];
                
                AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSURLSessionDownloadTask *videoDownload =[sessionManager downloadTaskWithRequest:videoRequest progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    
                    NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
                    return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
                }
                                                                               completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                                   if (error ==nil) {
                                                                                       if ([filePath isKindOfClass:[NSNull class]]) {
                                                                                           NSLog(@"Video Null at %@",filePath);
                                                                                           
                                                                                           [tempPotentialMatches removeObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj]];
                                                                                           
                                                                                       }else{
                                                                                           [currentPotentialMatch setValue:filePath forKey:@"fileURL"];
                                                                                           if ([instance.potentialMatches indexOfObject:obj] < [tempPotentialMatches count]){
                                                                                               [tempPotentialMatches replaceObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj] withObject:currentPotentialMatch];
                                                                                           }
                                                                                       }
                                                                                   }else{
                                                                                       if ([tempPotentialMatches count]>[tempPotentialMatches indexOfObjectIdenticalTo:obj]) {
                                                                                           NSLog(@"error with video download : %@",error);
                                                                                           [tempPotentialMatches removeObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj]];
                                                                                       }
                                                                                       
                                                                                       
                                                                                   }
                                                                                   
                                                                               }];
                [videoDownload resume];
            }
            }
            instance.potentialMatches = tempPotentialMatches;
            NSLog(@"(first match)potential matches has:%lu",(unsigned long)[instance.potentialMatches count]);

        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
        
    });
    
    return instance;
}

+(PotentialMatches *)nextMatch{
    
    static PotentialMatches *instance;
    instance = [self getInstance];
    if ([instance.potentialMatches count] >0) {
        [instance.passedUsers addObject:[instance.potentialMatches objectAtIndex:0]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([[instance.potentialMatches objectAtIndex:0]objectForKey:@"fileURL"]) {
            [fileManager removeItemAtURL:[[instance.potentialMatches objectAtIndex:0] objectForKey:@"fileURL"] error:NULL];
            NSLog(@"Item deleted at: %@",[[instance.potentialMatches objectAtIndex:0] objectForKey:@"fileURL"] );
        }
        
        [instance.potentialMatches removeObjectAtIndex:0];
        NSLog(@"Item deleted ");
        
    }

    
    if ([instance.potentialMatches count] <= 6 ){
        User *obj = [User getInstance];
        NSDictionary *user = obj.user;
        //start filling Potential Matches Queue
        
        
        //Download potential matches here
        NSString *urlAsString =kBaseURL;
        urlAsString = [urlAsString stringByAppendingString: @"user/"];
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
            NSLog(@"Next Match Object: %@", responseObject);
            
            NSMutableArray *temppotentialMatchArray1 = [[NSMutableArray alloc]initWithArray:responseObject];
            NSMutableArray *potentialMatchArray = [[NSMutableArray alloc]initWithArray:responseObject];
            for (NSMutableDictionary *potentialMatch in temppotentialMatchArray1){
                for (NSMutableDictionary *currentPotenialMatch in instance.potentialMatches){
                    if ([[potentialMatch objectForKey:@"uid"] isEqual:[currentPotenialMatch objectForKey:@"uid"]]) {
                        [potentialMatchArray removeObjectIdenticalTo:potentialMatch];
                        NSLog(@"removed: %@",[potentialMatch objectForKey:@"uid"]);
                    }
                }
            }
            
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:potentialMatchArray];
            if ([instance.passedUsers count]>0) {
                for ( NSMutableDictionary *passedUser in instance.passedUsers) {
                    for (NSMutableDictionary *potentialUser in tempArray){
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
                }else if ([obj objectForKey:@"video_uri"]== [NSNull null] ){
                    NSLog(@"no video");
                    NSString *FbToken = [session accessTokenData].accessToken;
                    
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
                    NSMutableDictionary *currentPotentialMatch = [[NSMutableDictionary alloc]initWithDictionary:obj];
                    manager.responseSerializer = [AFImageResponseSerializer serializer];
                    NSString *picURL = kBaseURL;
                    picURL = [picURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/photo", [currentPotentialMatch objectForKey:@"uid"]]];
                    [manager GET:picURL parameters:@{@"height":@640,
                                                     @"width": @640} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                         NSLog(@"Photo Object %@",responseObject);
                                                         if ([tempPotentialMatches indexOfObject:obj] < [tempPotentialMatches count]){
                                                         [currentPotentialMatch setObject:responseObject forKey:@"profilePic"];
                                                         [tempPotentialMatches replaceObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj] withObject:currentPotentialMatch];
                                                         }
                                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                         NSLog(@"Photo failed to load%@",error);
                                                         if ([tempPotentialMatches indexOfObject:obj] < [tempPotentialMatches count]){
                                                         [tempPotentialMatches removeObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj]];
                                                         }
                                                     }];

                    //[tempPotentialMatches addObject:obj];
                }
                else{
                    ///Download Video for Each instance in array
                    NSMutableDictionary *currentPotentialMatch = [[NSMutableDictionary alloc]initWithDictionary:obj];
                    NSString *videoUrlString =[currentPotentialMatch objectForKey:@"video_uri"];
                    NSURL *videoURl = [NSURL URLWithString:videoUrlString];
                    NSURLRequest *videoRequest = [NSURLRequest requestWithURL:videoURl];
                    
                    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    NSURLSessionDownloadTask *videoDownload =[sessionManager downloadTaskWithRequest:videoRequest progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                        
                        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
                        return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
                    }
                                                                                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                                       if (error ==nil) {
                                                                                           if ([filePath isKindOfClass:[NSNull class]]) {
                                                                                               NSLog(@"Video Null at %@",filePath);
                                                                                               
                                                                                               [tempPotentialMatches removeObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj]];
                                                                                               
                                                                                           }else{
                                                                                               [currentPotentialMatch setValue:filePath forKey:@"fileURL"];
                                                                                               if ([tempPotentialMatches indexOfObject:obj] < [tempPotentialMatches count]){
                                                                                                   [tempPotentialMatches replaceObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj] withObject:currentPotentialMatch];
                                                                                               }
                                                                                           }
                                                                                       }else{
                                                                                           if ([tempPotentialMatches count]>[tempPotentialMatches indexOfObjectIdenticalTo:obj]) {
                                                                                               NSLog(@"error with video download : %@",error);
                                                                                               [tempPotentialMatches removeObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj]];
                                                                                           }
                                                                                           
                                                                                           
                                                                                       }
                                                                                       
                                                                                       
                                                                                   }];
                    [videoDownload resume];
                }
                instance.potentialMatches = tempPotentialMatches;
                //Added if matches is empty.
                NSLog(@"potential matches has:%lu",(unsigned long)[instance.potentialMatches count]);
               
            }
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"failed with : %@",error);
              }];
        
    }
        if ([instance.potentialMatches count] ==0) {
       instance.moreMatchesTimer = [NSTimer scheduledTimerWithTimeInterval:9.0 target:self selector:@selector(moreMatches) userInfo:nil repeats:NO];
    }

    return instance;
}

+(PotentialMatches *)moreMatches{
    
    static PotentialMatches *instance;
    instance = [self getInstance];
    [instance.moreMatchesTimer invalidate];
    if ([instance.potentialMatches count] <= 6 ){
        User *obj = [User getInstance];
        NSDictionary *user = obj.user;
        //start filling Potential Matches Queue
        
        
        //Download potential matches here
        NSString *urlAsString =kBaseURL;
        urlAsString = [urlAsString stringByAppendingString: @"user/"];
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
            NSLog(@"Next Match Object: %@", responseObject);
            
            NSMutableArray *temppotentialMatchArray1 = [[NSMutableArray alloc]initWithArray:responseObject];
            NSMutableArray *potentialMatchArray = [[NSMutableArray alloc]initWithArray:responseObject];
            for (NSMutableDictionary *potentialMatch in temppotentialMatchArray1){
                for (NSMutableDictionary *currentPotenialMatch in instance.potentialMatches){
                    if ([[potentialMatch objectForKey:@"uid"] isEqual:[currentPotenialMatch objectForKey:@"uid"]]) {
                        [potentialMatchArray removeObjectIdenticalTo:potentialMatch];
                        NSLog(@"removed: %@",[potentialMatch objectForKey:@"uid"]);
                    }
                }
            }
            
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:potentialMatchArray];
            if ([instance.passedUsers count]>0) {
                for ( NSMutableDictionary *passedUser in instance.passedUsers) {
                    for (NSMutableDictionary *potentialUser in tempArray){
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
                }else if ([obj objectForKey:@"video_uri"]== [NSNull null] ){
                    NSLog(@"no video");
                    //[tempPotentialMatches addObject:obj];
                }
                else{
                    ///Download Video for Each instance in array
                    NSMutableDictionary *currentPotentialMatch = [[NSMutableDictionary alloc]initWithDictionary:obj];
                    NSString *videoUrlString =[currentPotentialMatch objectForKey:@"video_uri"];
                    NSURL *videoURl = [NSURL URLWithString:videoUrlString];
                    NSURLRequest *videoRequest = [NSURLRequest requestWithURL:videoURl];
                    
                    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    NSURLSessionDownloadTask *videoDownload =[sessionManager downloadTaskWithRequest:videoRequest progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                        
                        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
                        return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
                    }
                                                                                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                                       if (error ==nil) {
                                                                                           if ([filePath isKindOfClass:[NSNull class]]) {
                                                                                               NSLog(@"Video Null at %@",filePath);
                                                                                               
                                                                                               [tempPotentialMatches removeObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj]];
                                                                                               
                                                                                           }else{
                                                                                               [currentPotentialMatch setValue:filePath forKey:@"fileURL"];
                                                                                               if ([tempPotentialMatches indexOfObject:obj] < [tempPotentialMatches count]){
                                                                                                   [tempPotentialMatches replaceObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj] withObject:currentPotentialMatch];
                                                                                               }
                                                                                           }
                                                                                       }else{
                                                                                           if ([tempPotentialMatches count]>[tempPotentialMatches indexOfObjectIdenticalTo:obj]) {
                                                                                               NSLog(@"error with video download : %@",error);
                                                                                               [tempPotentialMatches removeObjectAtIndex:[tempPotentialMatches indexOfObjectIdenticalTo:obj]];
                                                                                           }
                                                                                           
                                                                                           
                                                                                       }
                                                                                       
                                                                                       
                                                                                   }];
                    [videoDownload resume];
                }
                instance.potentialMatches = tempPotentialMatches;
                //Added if matches is empty.
                NSLog(@"potential matches has:%lu",(unsigned long)[instance.potentialMatches count]);
                
            }
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"failed with : %@",error);
              }];
        
    }
    if ([instance.potentialMatches count] ==0) {
        instance.moreMatchesTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(moreMatches) userInfo:nil repeats:NO];
    }
    
    return instance;
}




@end
