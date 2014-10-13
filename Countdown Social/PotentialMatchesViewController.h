//
//  PotentialMatchesViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 5/19/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CountdownTimer.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerView.h"
#import  "CSAnimationView.h"
#import "SevenSwitch.h"



@interface PotentialMatchesViewController : ViewController <UIActionSheetDelegate>
{
    CountdownTimer *countdownTimer;
}

@property (nonatomic,strong) AVPlayer *moviePlayer;
@property (nonatomic, strong) AVPlayerLayer *moviePlayerLayer;
@property (nonatomic, strong) AVAsset *currentVideo;
@property (nonatomic ,strong) AVPlayerItem *currentVideoItem;
@property (nonatomic,strong) NSURL *videoUrl;
@property (nonatomic,strong) PlayerView *moviePlayerView;


@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSMutableDictionary *currentPotentialMatch;
@property (nonatomic, strong) NSMutableDictionary *currentMatch;


@property (strong, nonatomic) IBOutlet UIImageView *fbProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UILabel *playButtonLabel;

@property (strong, nonatomic) IBOutlet CSAnimationView *nameView;
@property (strong, nonatomic) IBOutlet CSAnimationView *imageView;
@property (strong, nonatomic) IBOutlet CSAnimationView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *FullProfileImageView;

@property (strong, nonatomic) SevenSwitch *facebookSwitch;
@property (strong, nonatomic) SevenSwitch *phoneSwitch;
@property (strong, nonatomic) SevenSwitch *snapchatSwitch;
@property (strong, nonatomic) SevenSwitch *twitterSwitch;
@property (strong, nonatomic) SevenSwitch *instagramSwitch;

//Connection Updates
@property (strong, nonatomic) IBOutlet UILabel *connectionLabel;
@property (strong, nonatomic) IBOutlet UIButton *connectionSkipButton;

//Regular Buttons
@property (strong, nonatomic) IBOutlet UIButton *potentialSkipButton;
@property (strong, nonatomic) IBOutlet UIButton *potentialConnectButton;


@property (strong, nonatomic) IBOutlet UIImageView *miniWatchButton;

- (IBAction)HoldPlay:(id)sender;
- (IBAction)passConnection:(id)sender;

- (IBAction)Pass:(id)sender;
- (IBAction)Like:(id)sender;

- (IBAction)presentLeftMenu:(id)sender;
- (IBAction)presentRightMenu:(id)sender;

- (IBAction)reportUser:(id)sender;

@end
