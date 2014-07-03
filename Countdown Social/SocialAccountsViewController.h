//
//  SocialAccountsViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/3/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialAccountsViewController : UIViewController

/*Labels*/
@property (strong, nonatomic) IBOutlet UILabel *facebookLabel;
@property (strong, nonatomic) IBOutlet UILabel *instagramLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterLabel;
@property (strong, nonatomic) IBOutlet UILabel *snapchatLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;


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

/*Edit Buttons*/
- (IBAction)editInstagram:(id)sender;
- (IBAction)editTwitter:(id)sender;
- (IBAction)editSnapchat:(id)sender;
- (IBAction)editPhone:(id)sender;


@end
