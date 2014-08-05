//
//  ConnectionVideoViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 8/4/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerView.h"

@interface ConnectionVideoViewController : ViewController

@property (nonatomic,strong) AVPlayer *moviePlayer;
@property (nonatomic, strong) AVPlayerLayer *moviePlayerLayer;
@property (nonatomic, strong) AVAsset *currentVideo;
@property (nonatomic ,strong) AVPlayerItem *currentVideoItem;
@property (nonatomic,strong) NSURL *videoUrl;
@property (nonatomic,strong) PlayerView *moviePlayerView;



- (IBAction)backToProfile:(id)sender;

@end
