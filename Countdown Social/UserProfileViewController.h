//
//  UserProfileViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/29/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController <MFMessageComposeViewControllerDelegate, UIActionSheetDelegate, UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *backgroundProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;

@property (strong, nonatomic) IBOutlet UILabel *facebookLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterLabel;
@property (strong, nonatomic) IBOutlet UILabel *instagramLabel;
@property (strong, nonatomic) IBOutlet UILabel *snapchatLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;


//LeftCircileImages
@property (strong, nonatomic) IBOutlet UIImageView *facebookCircle;
@property (strong, nonatomic) IBOutlet UIImageView *instagramCircle;
@property (strong, nonatomic) IBOutlet UIImageView *twitterCircle;
@property (strong, nonatomic) IBOutlet UIImageView *snapchatCircle;
@property (strong, nonatomic) IBOutlet UIImageView *phoneCircle;

@property (strong, nonatomic) IBOutlet UIButton *facebookViewProfileSmall;
@property (strong, nonatomic) IBOutlet UIButton *twitterViewProfileSmall;
@property (strong, nonatomic) IBOutlet UIButton *instagramViewProfileSmall;

@property (strong, nonatomic) IBOutlet UIButton *facebookAdded;
@property (strong, nonatomic) IBOutlet UIButton *instagramAdded;
@property (strong, nonatomic) IBOutlet UIButton *twitterAdded;

@property (strong, nonatomic) IBOutlet UIButton *phoneButton;
@property (strong, nonatomic) IBOutlet UIButton *snapButton;
@property (strong, nonatomic) IBOutlet UIButton *instaButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

- (IBAction)reportAction:(id)sender;

//viewProfileButtons


- (IBAction)backToConnections:(id)sender;
- (IBAction)goToMessaging:(id)sender;
- (IBAction)goToUserVideo:(id)sender;


- (IBAction)goToUserFacebook:(id)sender;
- (IBAction)goToUserTwitter:(id)sender;
- (IBAction)goToUserInstagram:(id)sender;
- (IBAction)goToSMS:(id)sender;
- (IBAction)goToSnap:(id)sender;

@end
