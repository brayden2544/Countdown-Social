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


@end
