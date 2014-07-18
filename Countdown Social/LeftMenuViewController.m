//
//  LeftMenuViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/26/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "RESideMenu/RESideMenu.h"


@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
@synthesize userProfileImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 //self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.objectID;
             }
         }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Change Facebook profile image to be circular
    //    self.userProfileImage.layer.borderColor = [UIColor colorWithRed:248 green:248 blue:248 alpha:0.4].CGColor;
    //    self.userProfileImage.layer.borderWidth = 3.0f;
    self.userProfileImage.alpha = 0.8;
    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height/2;
    self.userProfileImage.layer.masksToBounds=YES;
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}


- (IBAction)presentProfile:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PBJViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
    
}

- (IBAction)presentLocation:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SetLocationViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (IBAction)presentSocial:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SocialAccountsViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (IBAction)presentScore:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserScoreViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (IBAction)presentTellFriends:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TellFriendsViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (IBAction)presentFeedback:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (IBAction)presentSettings:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}
@end
