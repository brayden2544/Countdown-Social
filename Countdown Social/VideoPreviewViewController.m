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
@property (nonatomic,strong) NSDictionary *user;


@end

@implementation VideoPreviewViewController

@synthesize user;

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
    //Start Playing User's newly recorded video
    [self startPlayingVideo:nil];

}


//Method to start playing video preview
- (void) startPlayingVideo:(id)paramSender{
    
    //Get instance of videopath and init MPMoviePlayerController with videoPath
    VideoPath *obj = [VideoPath getInstance];
    NSURL *url = [NSURL fileURLWithPath:obj.videoPath];
    self.moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    
    //Movie Player Settings.
    [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    self.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.moviePlayer.controlStyle =MPMovieControlStyleNone;
    self.moviePlayer.shouldAutoplay = TRUE;
    [self.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    if (self.moviePlayer != nil){
        NSLog(@"Video Player Successfully Instanciated");
        
        //Scale Player to fit Aspect Ratio
        [self.moviePlayer.view setFrame:CGRectMake (0, 80, 320, 320)];

        [self.view addSubview:self.moviePlayer.view];

        [self.moviePlayer play];
    }
    else {
        NSLog(@"Failed to instanciate video player");
    }
}


//Posts profile video to servers.
-(void)uploadProfileVideo{
    User *userObj = [User getInstance];
    user = userObj.user;
    NSString *urlAsString =@"http://api-dev.countdownsocial.com/user/";
    urlAsString = [urlAsString stringByAppendingFormat:@"%@",[user objectForKey:@"uid"]];
    urlAsString = [urlAsString stringByAppendingString:@"/video"];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url];
    
    VideoPath *obj = [VideoPath getInstance];
    _videoPath = obj.videoPath;
    NSData *videoData = [[NSFileManager defaultManager] contentsAtPath:_videoPath];
    
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    NSString *FbToken = [session accessTokenData].accessToken;

    
    NSString *postLength = [NSString stringWithFormat:@"%d", [videoData length]];
    
    [urlRequest setValue:@"video/quicktime" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody:videoData];
    
    
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
             dispatch_sync(dispatch_get_main_queue(), ^(void) {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Success!" message: @"Your video was uploaded successfully."
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"Okay", nil];
             [alertView show];
             });
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
             NSLog(@"Video Not Uploaded");
         }
     }];
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"login in again hoping for more matches. button index = %d",buttonIndex);
    
    if (buttonIndex == 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
        [self presentViewController:menuViewController animated:YES completion:nil];
    }

}

-(void)startActivityView{
    UIView *darkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [darkView setBackgroundColor:[UIColor blackColor]];
    darkView.alpha = 0.8;
    [self.view addSubview:darkView];
     
     
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    activityView.frame = self.view.frame;
    [activityView startAnimating];
    
    [self.view addSubview:activityView];
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
    [self.moviePlayer stop];
    [self startActivityView];
    [self uploadProfileVideo];
}

- (IBAction)back:(id)sender {
    [self.moviePlayer stop];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PBJViewController *pbjViewController = [[PBJViewController alloc] init];
    [self presentViewController:pbjViewController animated:YES completion:nil];

}
@end
