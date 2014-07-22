//
//  SocialAccountsViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/3/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "SocialAccountsViewController.h"

#import "User.h"
#import "PhoneNumberView.h"
#import "SnapchatView.h"
#import "RESideMenu/RESideMenu.h"

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
    self.navigationController.navigationBarHidden =YES;
        [self buttonCheck];
}

-(void)buttonCheck{
    //Add Facebook Text
    User *Userobj = [User getInstance];
    user = Userobj.user;
    NSString *name = [user objectForKey:@"firstName"];
    name =[name stringByAppendingString:@" "];
    name = [name stringByAppendingString:[user objectForKey:@"lastName"]];
    NSLog(@"%@",name);
    self.facebookLabel.text = name;
    self.facebookLabel.textAlignment = 0;
    //Check for Twitter Account
    if ([[user objectForKey: @"twitter_username"] isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"twitter_username"]isEqualToString:@""] ||
        [[user objectForKey: @"twitter_username"]isEqualToString:@"<null>"]){
        self.twitterDisconnected.hidden = FALSE;
        self.twitterConnected.hidden=TRUE;
        self.editTwitterButton.hidden=TRUE;
        self.connectTwitterButton.hidden=FALSE;
        self.connectTwitterButton.enabled=TRUE;
        NSLog(@"Twitter username blank");
    }
    else{
        self.twitterDisconnected.hidden = TRUE;
        self.twitterConnected.hidden = FALSE;
        self.editTwitterButton.hidden= FALSE;
        self.twitterLabel.text = [user objectForKey:@"twitter_username"];
        self.twitterLabel.textAlignment = 0;
        self.connectTwitterButton.hidden=TRUE;
        self.connectTwitterButton.enabled=FALSE;
    }
    
    //Check for Instagram Account
    if ([[user objectForKey: @"instagram_username"] isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"instagram_username"]isEqualToString:@""] ||
        [[user objectForKey: @"instagram_username"]isEqualToString:@"<null>"]){
        self.instagramDisconnected.hidden = FALSE;
        self.instagramConnected.hidden=TRUE;
        self.editInstagramButton.hidden=TRUE;
        self.connectInstagramButton.hidden=FALSE;
        self.connectInstagramButton.enabled=TRUE;
        NSLog(@"Instagram username blank");

    }
    else{
        self.instagramDisconnected.hidden = TRUE;
        self.instagramConnected.hidden = FALSE;
        self.editInstagramButton.hidden= FALSE;
        self.connectInstagramButton.hidden=TRUE;
        self.connectInstagramButton.enabled=FALSE;
        self.instagramLabel.text = [user objectForKey:@"instagram_username"];
        self.instagramLabel.textAlignment = 0;
    }
         //Check for Phone Number
    if ([[user objectForKey: @"phone_number"]isKindOfClass:[NSNull class]] ||
        [[user objectForKey: @"phone_number"]isEqualToString:@""] ||
         [[user objectForKey: @"phone_number"]isEqualToString:@"<null>"])
    {
        self.phoneDisconnected.hidden = FALSE;
        self.phoneConnected.hidden=TRUE;
        self.editPhoneButton.hidden=TRUE;
        self.connectPhoneButton.hidden=FALSE;
        self.connectPhoneButton.enabled=TRUE;
        NSLog(@"Phone Number blank");
    }
    else{
        self.phoneDisconnected.hidden = TRUE;
        self.phoneConnected.hidden = FALSE;
        self.editPhoneButton.hidden= FALSE;
        self.connectPhoneButton.hidden=TRUE;
        self.connectPhoneButton.enabled=FALSE;
        
        self.phoneLabel.text = [user objectForKey:@"phone_number"];
        self.phoneLabel.textAlignment = 0;
    }

  
    //Check for Snapchat Account
    if ([[user objectForKey: @"snapchat_username"]isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@""] ||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@"<null>"]){
        self.snapchatDisconnected.hidden = FALSE;
        self.snapchatConnected.hidden=TRUE;
        self.editSnapchatButton.hidden=TRUE;
        self.connectSnapchatButton.hidden=FALSE;
        self.connectSnapchatButton.enabled=TRUE;
        NSLog(@"SnapChat username blank");

    }
    else{
        self.snapchatDisconnected.hidden = TRUE;
        self.snapchatConnected.hidden = FALSE;
        self.editSnapchatButton.hidden= FALSE;
        self.connectSnapchatButton.hidden=TRUE;
        self.connectSnapchatButton.enabled=FALSE;

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
    self.snapChatView.hidden=FALSE;
    [self.snapchatTextField becomeFirstResponder];
}

- (IBAction)connectTwitter:(id)sender {
}

- (IBAction)connectPhone:(id)sender {
    self.phoneNumberView.hidden=FALSE;
    [self.phoneTextField becomeFirstResponder];
    
}
- (IBAction)editInstagram:(id)sender {
    
}

- (IBAction)editTwitter:(id)sender {
}

- (IBAction)editSnapchat:(id)sender {
    self.snapChatView.hidden=FALSE;
    [self.snapchatTextField becomeFirstResponder];
}

- (IBAction)editPhone:(id)sender {
    self.phoneNumberView.hidden=FALSE;
    [self.phoneTextField becomeFirstResponder];
    
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
- (IBAction)setPhoneNumber:(id)sender {
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self buttonCheck];
            });

}

- (IBAction)setSnapchatUsername:(id)sender {
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self buttonCheck];
    });

}
- (IBAction)presentMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];

}
@end
