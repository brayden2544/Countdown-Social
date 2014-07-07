//
//  SocialAccountsViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/3/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "SocialAccountsViewController.h"

#import "User.h"

@interface SocialAccountsViewController ()

@end

@implementation SocialAccountsViewController

@synthesize user;

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
    User *Userobj = [User getInstance];
    user = Userobj.user;
    [self buttonCheck];
}

-(void)buttonCheck{
    //Check for Twitter Account
    if ([[user objectForKey: @"twitter_username"] isKindOfClass:[NSNull class]]){
        self.twitterDisconnected.hidden = TRUE;
        self.twitterConnected.hidden=FALSE;
       // self.addTwitter.enabled=FALSE;
        self.addTwitter.hidden=TRUE;
        self.editTwitterButton.hidden=FALSE;
        //self.editTwitterButton.enabled = TRUE;
    }
    else{
        self.twitterDisconnected.hidden = FALSE;
        self.twitterConnected.hidden = TRUE;
        self.addTwitter.hidden = FALSE;
       // self.addTwitter.enabled = TRUE;
        self.editTwitterButton.hidden= TRUE;
       // self.editTwitterButton.enabled=FALSE;
        NSLog(@"Twitter username blank");
    }
    
    //Check for Instagram Account
    if ([[user objectForKey: @"instagram_username"] isKindOfClass:[NSNull class]]){
        self.instagramDisconnected.hidden = TRUE;
        self.instagramConnected.hidden=FALSE;
        //self.addInstagram.enabled=FALSE;
        self.addInstagram.hidden=TRUE;
        self.editInstagramButton.hidden=FALSE;
       // self.editInstagramButton.enabled = TRUE;
    }
    else{
        self.instagramDisconnected.hidden = FALSE;
        self.instagramConnected.hidden = TRUE;
        self.addInstagram.hidden = FALSE;
        //self.addInstagram.enabled = TRUE;
        self.editInstagramButton.hidden= TRUE;
       // self.editInstagramButton.enabled=FALSE;
        NSLog(@"Instagram username blank");
    }
         //Check for Phone Number
    if ([[user objectForKey: @"phone_number"]isKindOfClass:[NSNull class]]){
        self.phoneDisconnected.hidden = TRUE;
        self.phoneConnected.hidden=FALSE;
       // self.addPhone.enabled=FALSE;
        self.addPhone.hidden=TRUE;
        self.editPhoneButton.hidden=FALSE;
        //self.editPhoneButton.enabled = TRUE;
    }
    else{
        self.phoneDisconnected.hidden = FALSE;
        self.phoneConnected.hidden = TRUE;
        self.addPhone.hidden = FALSE;
      //  self.addPhone.enabled = TRUE;
        self.editPhoneButton.hidden= TRUE;
       // self.editPhoneButton.enabled=FALSE;
        NSLog(@"Phone Number blank");
    }

  
    //Check for Snapchat Account
    if ([[user objectForKey: @"snapchat_username"]isKindOfClass:[NSNull class]]){
        self.snapchatDisconnected.hidden = TRUE;
        self.snapchatConnected.hidden=FALSE;
        //self.addSnapchat.enabled=FALSE;
        self.addSnapchat.hidden=TRUE;
        self.editSnapchatButton.hidden=FALSE;
      //  self.editSnapchatButton.enabled = TRUE;
    }
    else{
        self.snapchatDisconnected.hidden = FALSE;
        self.snapchatConnected.hidden = TRUE;
        self.addSnapchat.hidden = FALSE;
        //self.addSnapchat.enabled = TRUE;
        self.editSnapchatButton.hidden= TRUE;
        //self.editSnapchatButton.enabled=FALSE;
        NSLog(@"SnapChat username blank");
    }

    //Facebook is alwayas available
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)connectInstagram:(id)sender {
}
- (IBAction)connectSnapchat:(id)sender {
}

- (IBAction)connectTwitter:(id)sender {
}

- (IBAction)connectPhone:(id)sender {
    
}
- (IBAction)editInstagram:(id)sender {
    
}

- (IBAction)editTwitter:(id)sender {
}

- (IBAction)editSnapchat:(id)sender {
    
}

- (IBAction)editPhone:(id)sender {
    
}
- (IBAction)viewFacebook:(id)sender {
    
}

- (IBAction)ViewInstagramProfile:(id)sender {
    
}

- (IBAction)viewFacebookProfile:(id)sender {
}

- (IBAction)viewTwitterProfile:(id)sender {
}

- (IBAction)viewSnapchatProfile:(id)sender {
}

- (IBAction)viewPhoneProfile:(id)sender {
}
@end
