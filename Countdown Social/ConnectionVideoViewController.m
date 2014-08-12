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


@interface ConnectionVideoViewController ()
@property Connection *connection;
@property NSDictionary *currentConnection;

@end

@implementation ConnectionVideoViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    _connection = [Connection getInstance];
    _currentConnection = [_connection.connection objectForKey:@"liked_user"];
    self.navigationController.navigationBarHidden = YES;
    
    self.moviePlayerView = [[PlayerView alloc]initWithFrame:CGRectMake (0, 100, 320, 320)];
    _videoUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_currentConnection objectForKey:@"videoUri"]]];
    self.moviePlayerView.player = [[AVPlayer alloc]initWithURL:_videoUrl];
    //self.currentVideoItem = [AVPlayerItem playerItemWithURL:_videoUrl];
    //[self.moviePlayerView.player replaceCurrentItemWithPlayerItem:self.currentVideoItem];
    self.moviePlayerLayer = [[AVPlayerLayer alloc]init];
    self.moviePlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayerView.player] ;
    self.moviePlayerView.backgroundColor = [UIColor redColor];
    [self.moviePlayerView.layer addSublayer:self.moviePlayerLayer];
    [self.view addSubview:self.moviePlayerView];
    [self.moviePlayerView.player play];

    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backToProfile:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];}

@end
