//
//  ConnectionViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/28/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *matchProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *userProfilePic;

@property (strong, nonatomic) IBOutlet UIButton *phoneButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *snapchatButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *instagrambutton;
@property (strong, nonatomic) IBOutlet UIButton *messagButton;
@property (strong, nonatomic) IBOutlet UILabel *connectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *checkOutLabel;

- (IBAction)facebookAction:(id)sender;
- (IBAction)phoneAction:(id)sender;
- (IBAction)snapchatAction:(id)sender;
- (IBAction)twitterAction:(id)sender;
- (IBAction)instagramAction:(id)sender;
- (IBAction)messageAction:(id)sender;

- (IBAction)keepPlayingAction:(id)sender;






@end
