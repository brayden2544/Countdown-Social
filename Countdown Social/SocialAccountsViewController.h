//
//  SocialAccountsViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/3/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialAccountsViewController : UIViewController

/*User Dictionary*/
@property (strong, nonatomic) NSDictionary *user;

/*View Outlets*/
@property (strong, nonatomic) IBOutlet UIView *phoneNumberView;
@property (strong, nonatomic) IBOutlet UIView *snapChatView;

/*Text View Outlets*/
@property (strong, nonatomic) IBOutlet UITextField *snapchatTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;


/*ConnectedImages*/
@property (strong, nonatomic) IBOutlet UIImageView *facebookConnected;
@property (strong, nonatomic) IBOutlet UIImageView *instagramConnected;
@property (strong, nonatomic) IBOutlet UIImageView *twitterConnected;
@property (strong, nonatomic) IBOutlet UIImageView *snapchatConnected;
@property (strong, nonatomic) IBOutlet UIImageView *phoneConnected;


/*DisconnectedImages*/
@property (strong, nonatomic) IBOutlet UIImageView *snapchatDisconnected;
@property (strong, nonatomic) IBOutlet UIImageView *twitterDisconnected;
@property (strong, nonatomic) IBOutlet UIImageView *instagramDisconnected;
@property (strong, nonatomic) IBOutlet UIImageView *phoneDisconnected;


/*Connected Buttons*/
- (IBAction)connectInstagram:(id)sender;
- (IBAction)connectSnapchat:(id)sender;
- (IBAction)connectTwitter:(id)sender;
- (IBAction)connectPhone:(id)sender;

/*Connected Button Outlets*/
@property (strong, nonatomic) IBOutlet UIButton *connectInstagramButton;
@property (strong, nonatomic) IBOutlet UIButton *connectTwitterButton;
@property (strong, nonatomic) IBOutlet UIButton *connectSnapchatButton;
@property (strong, nonatomic) IBOutlet UIButton *connectPhoneButton;



/*Edit Buttons*/
- (IBAction)editInstagram:(id)sender;
- (IBAction)editTwitter:(id)sender;
- (IBAction)editSnapchat:(id)sender;
- (IBAction)editPhone:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *editInstagramButton;
@property (strong, nonatomic) IBOutlet UIButton *editTwitterButton;
@property (strong, nonatomic) IBOutlet UIButton *editSnapchatButton;
@property (strong, nonatomic) IBOutlet UIButton *editPhoneButton;


/*View Profile Button Outlets*/
@property (strong, nonatomic) IBOutlet UIButton *viewFacebookButton;
@property (strong, nonatomic) IBOutlet UIButton *viewInstagramProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *viewTwitterButton;
@property (strong, nonatomic) IBOutlet UIButton *viewSnapchatButton;
@property (strong, nonatomic) IBOutlet UIButton *viewPhoneButton;

/*View Profile Actions*/
- (IBAction)ViewInstagramProfile:(id)sender;
- (IBAction)viewFacebookProfile:(id)sender;
- (IBAction)viewTwitterProfile:(id)sender;
- (IBAction)viewSnapchatProfile:(id)sender;
- (IBAction)viewPhoneProfile:(id)sender;

/*Set Snap/Phone Button Actions*/
- (IBAction)setPhoneNumber:(id)sender;
- (IBAction)setSnapchatUsername:(id)sender;
 

/*Label Outlets*/
@property (strong, nonatomic) IBOutlet UILabel *facebookLabel;
@property (strong, nonatomic) IBOutlet UILabel *instagramLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterLabel;
@property (strong, nonatomic) IBOutlet UILabel *snapchatLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

- (IBAction)presentMenu:(id)sender;



@end
