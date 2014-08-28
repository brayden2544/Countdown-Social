//
//  ConnectionVideoViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 8/4/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ConnectionVideoViewController.h"
#import "RESideMenu/RESideMenu.h"
#import "Connection.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Connection.h"


@interface ConnectionVideoViewController ()
@property Connection *connection;
@property NSDictionary *currentConnection;
@property NSURL *connectionVideo;

@end

@implementation ConnectionVideoViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    Connection *connectionObj = [Connection getInstance];
    NSDictionary *connection =connectionObj.connection;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[[connection objectForKey:@"liked_user"]objectForKey:@"firstName"]];
    _connection = [Connection getInstance];
    _currentConnection = [_connection.connection objectForKey:@"liked_user"];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *urlAsString =kBaseURL;
    urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"user/%@",[_currentConnection objectForKey:@"uid" ]]];
    
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSDictionary *params = @{};
    [manager GET:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _videoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"video_uri"]]];
        [self playVideo];
               
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];

    self.navigationController.navigationBarHidden = YES;
    
    
    

    // Do any additional setup after loading the view.
}

- (void)playVideo{
    self.moviePlayerView = [[PlayerView alloc]initWithFrame:CGRectMake (0, 100, 320, 320)];
    self.currentVideoItem = [[AVPlayerItem alloc]initWithURL:_videoUrl];
    self.moviePlayerView.player = [[AVPlayer alloc]initWithPlayerItem:self.currentVideoItem];
    //self.currentVideoItem = [AVPlayerItem playerItemWithURL:_videoUrl];
    //[self.moviePlayerView.player replaceCurrentItemWithPlayerItem:self.currentVideoItem];
    self.moviePlayerLayer = [[AVPlayerLayer alloc]init];
    self.moviePlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayerView.player] ;
    [self.moviePlayerView.layer addSublayer:self.moviePlayerLayer];
    [self.view addSubview:self.moviePlayerView];
    [self.moviePlayerView.player play];

}


- (IBAction)replayVideo:(id)sender {
    [self.moviePlayerView.player seekToTime:kCMTimeZero];
    [self.moviePlayerView.player play];
}

- (IBAction)backToProfile:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];}

@end
