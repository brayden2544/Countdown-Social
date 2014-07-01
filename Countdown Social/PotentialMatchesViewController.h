//
//  PotentialMatchesViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 5/19/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface PotentialMatchesViewController : ViewController
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) NSURL *videoUrl;
@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSDictionary *currentPotentialMatch;
@property  BOOL *menuOpen;

@property (strong, nonatomic) IBOutlet UIImageView *fbProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) IBOutlet UILabel *meetLabel;

@property (strong, nonatomic) IBOutlet UIButton *instagramDeselect;
@property (strong, nonatomic) IBOutlet UIButton *twitterDeselect;
@property (strong, nonatomic) IBOutlet UIButton *snapchatDeselect;
@property (strong, nonatomic) IBOutlet UIButton *facebookDeselect;
@property (strong, nonatomic) IBOutlet UIButton *phoneDeselect;

@property (strong, nonatomic) IBOutlet UIButton *phoneSelect;
@property (strong, nonatomic) IBOutlet UIButton *facebookSelect;
@property (strong, nonatomic) IBOutlet UIButton *snapchatSelect;
@property (strong, nonatomic) IBOutlet UIButton *twitterSelect;
@property (strong, nonatomic) IBOutlet UIButton *instagramSelect;

- (IBAction)enableInstagram:(id)sender;
- (IBAction)enableTwitter:(id)sender;
- (IBAction)enableSnapChat:(id)sender;
- (IBAction)enableFacebook:(id)sender;
- (IBAction)enablePhone:(id)sender;

- (IBAction)disableInstagram:(id)sender;
- (IBAction)disableTwitter:(id)sender;
- (IBAction)disableSnapChat:(id)sender;
- (IBAction)disableFacebook:(id)sender;
- (IBAction)disablePhone:(id)sender;
- (IBAction)HoldPlay:(id)sender;

- (IBAction)Pass:(id)sender;
- (IBAction)Like:(id)sender;

- (void) playButtonReleased;


@end
