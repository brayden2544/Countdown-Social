//
//  ProfileViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/23/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ProfileViewController.h"
#import "RESideMenu.h"
#import "VideoPath.h"
#import <MediaPlayer/MediaPlayer.h>
#import "User.h"


@interface ProfileViewController ()
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) NSString *videoPath;
@property (atomic, strong) NSDictionary *currentVideo;
@property (nonatomic,strong) NSDictionary *user;

@end

@implementation ProfileViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    //Start Playing User's newly recorded video
    User *obj = [User getInstance];
    _videoPath = [obj.user objectForKey:@"videoUri"];
    [self startPlayingVideo:nil];
    
    
}


//Method to start playing video preview
- (void) startPlayingVideo:(id)paramSender{
    
    //Get instance of videopath and init MPMoviePlayerController with videoPath
    NSURL *url = [NSURL URLWithString:_videoPath];
    self.moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    
    //Movie Player Settings.
    [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    self.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.moviePlayer.controlStyle =MPMovieControlStyleNone;
    self.moviePlayer.shouldAutoplay = TRUE;
    [self.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    if (self.moviePlayer != nil){
        NSLog(@"Video Player Successfully Instanciated with %@", url);
        
        //Scale Player to fit Aspect Ratio
        [self.moviePlayer.view setFrame:CGRectMake (0, 80, 320, 320)];
        
        [self.view addSubview:self.moviePlayer.view];
        
        [self.moviePlayer play];
    }
    else {
        NSLog(@"Failed to instanciate video player");
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.moviePlayer stop];
}


- (IBAction)recordVideo:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PBJViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)presentLeftMenu:(id)sender {
    [self.moviePlayer pause];
    [self.sideMenuViewController presentLeftMenuViewController];
}
@end
