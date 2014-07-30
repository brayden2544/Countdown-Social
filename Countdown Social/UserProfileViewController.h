//
//  UserProfileViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/29/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backgroundProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;

//LeftCircileImages
@property (strong, nonatomic) IBOutlet UIImageView *facebookCircle;
@property (strong, nonatomic) IBOutlet UIImageView *instagramCircle;
@property (strong, nonatomic) IBOutlet UIImageView *twitterCircle;
@property (strong, nonatomic) IBOutlet UIImageView *snapchatCircle;
@property (strong, nonatomic) IBOutlet UIImageView *phoneCircle;

//requestButtons
@property (strong, nonatomic) IBOutlet UIButton *facebookAdd;
@property (strong, nonatomic) IBOutlet UIButton *twitterAdd;
@property (strong, nonatomic) IBOutlet UIButton *instagramAdd;
@property (strong, nonatomic) IBOutlet UIButton *snapchatAdd;
@property (strong, nonatomic) IBOutlet UIButton *phoneAdd;

//addedButtons
@property (strong, nonatomic) IBOutlet UIButton *facebokAdded;
@property (strong, nonatomic) IBOutlet UIButton *instagramAdded;
@property (strong, nonatomic) IBOutlet UIButton *twitterAdded;
@property (strong, nonatomic) IBOutlet UIButton *snapchatAdded;
@property (strong, nonatomic) IBOutlet UIButton *phoneAdded;

//viewProfileButtons
@property (strong, nonatomic) IBOutlet UIButton *facebookProfile;
@property (strong, nonatomic) IBOutlet UIButton *twitterProfile;
@property (strong, nonatomic) IBOutlet UIButton *instagramProfile;
@property (strong, nonatomic) IBOutlet UIButton *snapchatProfile;
@property (strong, nonatomic) IBOutlet UIButton *phoneProfile;


//pendingButtons
@property (strong, nonatomic) IBOutlet UIButton *facebookPending;
@property (strong, nonatomic) IBOutlet UIButton *twitterPending;
@property (strong, nonatomic) IBOutlet UIButton *instagramPending;



- (IBAction)backToConnections:(id)sender;
- (IBAction)goToMessaging:(id)sender;
- (IBAction)goToUserVideo:(id)sender;
- (IBAction)addFacebookFriend:(id)sender;

@end
