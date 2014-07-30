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





//viewProfileButtons
@property (strong, nonatomic) IBOutlet UIButton *facebookProfile;
@property (strong, nonatomic) IBOutlet UIButton *twitterProfile;
@property (strong, nonatomic) IBOutlet UIButton *instagramProfile;


- (IBAction)backToConnections:(id)sender;
- (IBAction)goToMessaging:(id)sender;
- (IBAction)goToUserVideo:(id)sender;

@end
