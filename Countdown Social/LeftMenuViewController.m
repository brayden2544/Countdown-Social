//
//  LeftMenuViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/26/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "LeftMenuViewController.h"


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
    self.userProfileImage.layer.borderColor = [UIColor colorWithRed:248 green:248 blue:248 alpha:0.4].CGColor;
    self.userProfileImage.layer.borderWidth = 3.0f;
    self.userProfileImage.alpha = 0.8;
    self.userProfileImage.layer.cornerRadius = 34.5;
    self.userProfileImage.layer.masksToBounds=YES;
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
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

@end
