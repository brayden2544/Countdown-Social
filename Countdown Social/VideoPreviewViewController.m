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
#import "User.h"
#import "VideoPath.h"
#import "AppDelegate.h"


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
//    User *obj =[User getInstance];
//    NSDictionary *user =obj.user;
//    _videoPath =[user objectForKey:@"videoUri"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [self startPlayingVideo:nil];

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
    VideoPath *obj = [VideoPath getInstance];
    NSURL *url = [NSURL fileURLWithPath:obj.videoPath];
    self.moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    self.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (self.moviePlayer != nil){
        NSLog(@"Video Player Successfully Instanciated");
        
        //Scale Player to fit Aspect Ratio
        [self.moviePlayer.view setFrame:CGRectMake (0, 80, 320, 320)];

        [self.view addSubview:self.moviePlayer.view];

        
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
        
    }
}
-(void)uploadProfileVideo{
    NSString *urlAsString =@"http://api-dev.countdownsocial.com/user/690825080/video";
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url];
    
    VideoPath *obj = [VideoPath getInstance];
    _videoPath = obj.videoPath;
    //NSURL *videoURL = [NSURL URLWithString:_videoPath];
    NSData *videoData = [[NSFileManager defaultManager] contentsAtPath:_videoPath];
    
    //NSLog(@"%@",videoURL);
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    NSString *FbToken = [session accessTokenData].accessToken;
    
    NSLog(@"Token is %@", FbToken);
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [videoData length]];
    NSLog(@"stupid length%@",postLength);
    
    [urlRequest setValue:@"video/quicktime" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody:videoData];
    //NSLog(@"post thing %@", videoData);
    
    
    
    
    [urlRequest setTimeoutInterval:15.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSOperationQueue *queque = [[NSOperationQueue alloc] init];
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queque
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error){
         if ([data length] >0 && error == nil){
             NSString *html =
             [[NSString alloc] initWithData:data
                                   encoding:NSUTF8StringEncoding];
             
             NSLog(@" POST HTML = %@", html);
             
             
             
             id UserJson = [NSJSONSerialization
                            JSONObjectWithData:data
                            options:NSJSONReadingAllowFragments
                            error:&error];
             NSDictionary *user = UserJson;
             NSLog(@"dictionary contains %@" , user);
             
             
         }
         else if ([data length] == 0 && error == nil){
             NSLog(@"POST Nothing was downloaded.");
         }
         else if (error !=nil){
             NSLog(@"Error happened = %@", error);
             NSLog(@"POST BROKEN");
         }
     }];

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


//Action when user approves video and wants to approve it.
- (IBAction)approveVideo:(id)sender {
    [self uploadProfileVideo];
    
}
@end
