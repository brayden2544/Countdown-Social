//
//  SettingsViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/18/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "SettingsViewController.h"
#import "RESideMenu.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "User.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)facebookSignOut:(id)sender {
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_likes"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             // Retrieve the app delegate
             AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

-(void)uploadSettings{
    
    NSString *isStraight;
    NSString *isActive;
    
    
    if (sexualOrientation.isOn) {
        isStraight = @"true";
    }
    else{
        isStraight = @"false";
    }
    
    if (hideProfile.isOn) {
        isActive = @"true";
    }
    else{
        isActive = @"false";
    }
    User *obj = [User getInstance];
    NSDictionary *user = obj.user;
    
    NSString *urlAsString =@"http://api-dev.countdownsocial.com/user/";
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc]init];
    manager.operationQueue = backgroundQueue;
    NSDictionary *params = @{@"straight":isStraight,
                             @"active":isActive};
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        obj.user = responseObject;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback Uploaded!!"
                                                        message:@"Thanks for helping us make Countdown better!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Okay", nil];
        [alert show];
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback Not Uploaded!!"
                                                         message:@"Please try again!"
                                                        delegate:self
                                               cancelButtonTitle:@"Okay"
                                               otherButtonTitles:nil];
         [alert show];
         
     }];

}






- (IBAction)presentMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
@end
