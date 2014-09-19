//
//  LoginViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 4/27/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.imageFile isEqualToString:@""]) {
        self.facebookLoginButton.enabled=TRUE;
        self.pageImage.hidden = TRUE;
        
    }else{
        self.pageImage.hidden = FALSE;
        self.pageImage.image = [UIImage imageNamed:self.imageFile];
        self.facebookLoginButton.enabled = FALSE;
    }
    self.pageControl.currentPage = self.pageIndex;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonTouched:(id)sender
{
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


@end

