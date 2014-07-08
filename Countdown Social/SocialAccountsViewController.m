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
    //Add Facebook Text
    NSString *name = [user objectForKey:@"firstName"];
    name =[name stringByAppendingString:@" "];
    name = [name stringByAppendingString:[user objectForKey:@"lastName"]];
    NSLog(@"%@",name);
    self.facebookLabel.text = name;
    self.facebookLabel.textAlignment = 0;
    //Check for Twitter Account
    if ([[user objectForKey: @"twitter_username"] isKindOfClass:[NSNull class]]){
        self.twitterDisconnected.hidden = FALSE;
        self.twitterConnected.hidden=TRUE;
       // self.addTwitter.enabled=FALSE;
        self.addTwitter.hidden=FALSE;
        self.editTwitterButton.hidden=TRUE;
        //self.editTwitterButton.enabled = TRUE;
        NSLog(@"Twitter username blank");
    }
    else{
        self.twitterDisconnected.hidden = TRUE;
        self.twitterConnected.hidden = FALSE;
        self.addTwitter.hidden = TRUE;
       // self.addTwitter.enabled = TRUE;
        self.editTwitterButton.hidden= FALSE;
        self.twitterLabel.text = [user objectForKey:@"twitter_username"];
        self.twitterLabel.textAlignment = 0;
       // self.editTwitterButton.enabled=FALSE;
    }
    
    //Check for Instagram Account
    if ([[user objectForKey: @"instagram_username"] isKindOfClass:[NSNull class]]){
        self.instagramDisconnected.hidden = FALSE;
        self.instagramConnected.hidden=TRUE;
        //self.addInstagram.enabled=FALSE;
        self.addInstagram.hidden=FALSE;
        self.editInstagramButton.hidden=TRUE;
       // self.editInstagramButton.enabled = TRUE;
        NSLog(@"Instagram username blank");

    }
    else{
        self.instagramDisconnected.hidden = TRUE;
        self.instagramConnected.hidden = FALSE;
        self.addInstagram.hidden = TRUE;
        //self.addInstagram.enabled = TRUE;
        self.editInstagramButton.hidden= FALSE;
       // self.editInstagramButton.enabled=FALSE;
        self.instagramLabel.text = [user objectForKey:@"instagram_username"];
        self.instagramLabel.textAlignment = 0;
    }
         //Check for Phone Number
    if ([[user objectForKey: @"phone_number"]isKindOfClass:[NSNull class]]){
        self.phoneDisconnected.hidden = FALSE;
        self.phoneConnected.hidden=TRUE;
       // self.addPhone.enabled=FALSE;
        self.addPhone.hidden=FALSE;
        self.editPhoneButton.hidden=TRUE;
        //self.editPhoneButton.enabled = TRUE;
        NSLog(@"Phone Number blank");
    }
    else{
        self.phoneDisconnected.hidden = TRUE;
        self.phoneConnected.hidden = FALSE;
        self.addPhone.hidden = TRUE;
      //  self.addPhone.enabled = TRUE;
        self.editPhoneButton.hidden= FALSE;
       // self.editPhoneButton.enabled=FALSE;
    }

  
    //Check for Snapchat Account
    if ([[user objectForKey: @"snapchat_username"]isKindOfClass:[NSNull class]]){
        self.snapchatDisconnected.hidden = FALSE;
        self.snapchatConnected.hidden=TRUE;
        //self.addSnapchat.enabled=FALSE;
        self.addSnapchat.hidden=FALSE;
        self.editSnapchatButton.hidden=TRUE;
      //  self.editSnapchatButton.enabled = TRUE;
        NSLog(@"SnapChat username blank");

    }
    else{
        self.snapchatDisconnected.hidden = TRUE;
        self.snapchatConnected.hidden = FALSE;
        self.addSnapchat.hidden = TRUE;
        //self.addSnapchat.enabled = TRUE;
        self.editSnapchatButton.hidden= FALSE;
        //self.editSnapchatButton.enabled=FALSE;
        self.snapchatLabel.text = [user objectForKey:@"snapchat_username"];
        self.snapchatLabel.textAlignment = 0;

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

    NSLog(@"Add snapchat button pushed");
}

- (IBAction)connectTwitter:(id)sender {
}

- (IBAction)connectPhone:(id)sender {
    
    NSLog(@"Add phone button pushed");

    
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
