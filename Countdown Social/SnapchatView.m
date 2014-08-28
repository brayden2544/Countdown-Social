//
//  SnapchatView.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/8/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "SnapchatView.h"
#import "User.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"


@implementation SnapchatView

@synthesize snapchatUsername;


- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
[self.snapchatUserText becomeFirstResponder];
}
    return self;
}
- (IBAction)setSnapchatButton:(id)sende{
    snapchatUsername = self.snapchatUserText.text;
    [self snapchatUsernameUpload];
    self.hidden = TRUE;
    [self endEditing:YES];
}
- (IBAction)cancel:(id)sender{
    self.hidden = TRUE;
    [self endEditing:YES];
}



-(void)snapchatUsernameUpload
{
    
    NSString *urlAsString =kBaseURL;
    urlAsString = [urlAsString stringByAppendingString:@"user"];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url];
    if (snapchatUsername.length >0) {
        [urlRequest setHTTPBody:[[NSString stringWithFormat:@"snapchat_username=%@",snapchatUsername] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        snapchatUsername=[NSString stringWithFormat:@"%@", [NSNull null]];
        [urlRequest setHTTPBody:[[NSString stringWithFormat:@"snapchat_username=%@",snapchatUsername] dataUsingEncoding:NSUTF8StringEncoding]];

    }
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    //Get singleton from LoginLoadView Controller
    
    
    NSString *FbToken = [session accessTokenData].accessToken;
    
    // NSLog(@"Token is %@", FbToken);
    
    [urlRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSOperationQueue *queque = [[NSOperationQueue alloc] init];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        
        
        [NSURLConnection
         sendAsynchronousRequest:urlRequest
         queue:queque
         completionHandler:^(NSURLResponse *response,
                             NSData *data,
                             NSError *error){
             if ([data length] >0 && error == nil){
                 id UserJson = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:NSJSONReadingAllowFragments
                                error:&error];
                 //  user = UserJson;
                 User *Userobj =  [User getInstance];
                 Userobj.user= UserJson;
                 
                 NSLog(@"Snapchat Username and User Singleton Updated");
                 
                 
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"POST Nothing was downloaded.");
             }
             else if (error !=nil){
                 NSLog(@"Error happened = %@", error);
                 NSLog(@"POST BROKEN");
             }
         }];
    });
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
