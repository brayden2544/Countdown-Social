//
//  VideoPreviewViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 5/14/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "VideoPreviewViewController.h"
#import "PBJViewController.h"
#import <MediaPlayer/MediaPlayer.h>



@interface VideoPreviewViewController ()
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) NSString *videoPath;
@property (atomic, strong) NSDictionary *currentVideo;


@end

@implementation VideoPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //PBJViewController *sharedPBJViewController = [PBJViewController sharedPBJViewController];
   // _videoPath = sharedPBJViewController.videoPath;
    //_currentVideo = sharedPBJViewController.videoDict;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Action to start playing video through playButton
- (IBAction)playVideo:(id)sender {
    [self startPlayingVideo: (id) sender];
}

- (void) startPlayingVideo:(id)paramSender{
    //Construct url of file in application bundle that needs to get played by movie player
    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:_videoFile ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:_videoFile];
    
    NSLog(@"%@", filepath);
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    self.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (self.moviePlayer != nil){
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(videoHasFinishedPlaying:)
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:self.moviePlayer];
        
        NSLog(@"Video Player Successfully Instanciated");
        
        //Scale Player to fit Aspect Ratio
        
        [self.view addSubview:self.moviePlayer.view];
        //self.moviePlayer.view.frame = CGRectMake(10.0f, 55.0f, 300.0f, 460.0f);

        
        //[self.moviePlayer setFullscreen:YES
          //                     animated:NO];
        
        [self.moviePlayer play];
    }
    else {
        NSLog(@"Failed to instanciate video player");
    }
}

-(void) stopPlayingVideo:(id)paramSender {
    
    if (self.moviePlayer !=nil){
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:self.moviePlayer];
    }
}

- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification{
    //Show reason why video stopped playing
    NSNumber *reason =
    paramNotification.userInfo
    [MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if (reason !=nil){
        NSInteger reasonAsInteger = [reason integerValue];
        
        switch (reasonAsInteger) {
            case MPMovieFinishReasonPlaybackEnded:{
                //Movie Ended Normally
                break;
            }
            case MPMovieFinishReasonPlaybackError:{
                //An error occured and movie ended
            }
            case MPMovieFinishReasonUserExited:{
                //User ended video playback
            }
        }
        NSLog(@"Finish reason = %ld", (long)reasonAsInteger);
        [self stopPlayingVideo:nil];
    }
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


@end
