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
@end
