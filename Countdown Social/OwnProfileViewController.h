//
//  OwnProfileViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 8/15/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *facebook;
@property (strong, nonatomic) IBOutlet UIButton *phone;
@property (strong, nonatomic) IBOutlet UIButton *snapchat;
@property (strong, nonatomic) IBOutlet UIButton *twitter;
@property (strong, nonatomic) IBOutlet UIButton *instagram;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundProfilePic;

- (IBAction)backAction:(id)sender;
- (IBAction)facebookAction:(id)sender;
- (IBAction)phoneAction:(id)sender;
- (IBAction)snapchatAction:(id)sender;
- (IBAction)twitterAction:(id)sender;
- (IBAction)instagramAction:(id)sender;
- (IBAction)viewVideoAction:(id)sender;
- (IBAction)changeVideoAction:(id)sender;

@end
