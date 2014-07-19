//
//  LeftMenuViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 6/26/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FBProfilePictureView.h>
#import <FacebookSDK/FBSession.h>
#import "AppDelegate.h"

@interface LeftMenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;

- (IBAction)presentProfile:(id)sender;
- (IBAction)presentLocation:(id)sender;
- (IBAction)presentSocial:(id)sender;
- (IBAction)presentScore:(id)sender;
- (IBAction)presentTellFriends:(id)sender;
- (IBAction)presentFeedback:(id)sender;
- (IBAction)presentSettings:(id)sender;

//Shade over button outletes
@property (strong, nonatomic) IBOutlet UIImageView *feedbackImage;
@property (strong, nonatomic) IBOutlet UIImageView *tellFriendsImage;
@property (strong, nonatomic) IBOutlet UIImageView *scoreImage;
@property (strong, nonatomic) IBOutlet UIImageView *socialImage;
@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *settingsImage;
@property (strong, nonatomic) IBOutlet UIImageView *homeImage;

@end
