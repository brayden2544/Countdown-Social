//
//  PotentialMatchesViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 5/19/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "PotentialMatchesViewController.h"
#import "PotentialMatches.h"
#import "User.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "InstagramViewController.h"
#import "PotentialMatchesLoadingView.h"
#import "RESideMenu/RESideMenu.h"
#import "LeftMenuViewController.h"

@interface PotentialMatchesViewController ()

@property (strong, nonatomic) IBOutlet UILabel *timer;
@property (retain) UIImageView *blur;
@property (retain) UIView *darken;
@property (retain) UIView *potentialMatchesLoadingView;
@property (strong, nonatomic) IBOutlet UIView *createMatch;
@property  BOOL playButtonHeld;
@property  BOOL likeCurrentUser;
@property  BOOL loading;
@property (strong, nonatomic) UIImage *videoImage;
@property NSTimeInterval timeRemaining;
@property int checkVideoCount;
@property NSOperationQueue *backgroundQueue;

@property bool twitter;
@property bool instagram;
@property bool snapchat;
@property bool phone;
@property bool facebook;

@end

@implementation PotentialMatchesViewController

@synthesize currentPotentialMatch;
@synthesize user;
@synthesize moviePlayer;
@synthesize playButton;



- (void)viewDidLoad
{
    //Notification observers for LoadStateChange and FinishPlaying on self.moviePlayer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                               object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoHasFinishedPlaying:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
    
    self.navigationController.navigationBarHidden = YES;
    //Pull in user object and check buttons.
    User *obj = [User getInstance];
    user = obj.user;
    [self buttonCheck];
    
    _backgroundQueue = [[NSOperationQueue alloc]init];
    
    //change countdown timer to circle.
    self.timer.layer.cornerRadius = 19;
    countdownTimer = [[CountdownTimer alloc]init];
    [countdownTimer changePercentage:100];
    [self.view addSubview:countdownTimer];
    
    
    self.moviePlayer = [[MPMoviePlayerController alloc]init];
    self.moviePlayer.shouldAutoplay = NO;
    self.moviePlayer.controlStyle =MPMovieControlStyleNone;
    [self.moviePlayer.view setFrame:CGRectMake (0, 100, 320, 320)];
    [self.moviePlayer setFullscreen:NO
                           animated:NO];
    [self.view addSubview:self.moviePlayer.view];
    [NSTimer scheduledTimerWithTimeInterval: .05
                                     target: self
                                   selector:@selector(VideoTimer:)
                                   userInfo: nil repeats:YES];
    
    
    self.potentialMatchesLoadingView = [[PotentialMatchesLoadingView alloc]initWithFrame:CGRectMake(0, 57, 320, 363)];
    
    self.blur=[[UIImageView alloc] initWithFrame:CGRectMake (0, 100, 320, 320)];
    
    
    
    //make countdown timer transparent.
    self.timer.alpha = .7;
    
    NSLog(@"ViewDidLoad");
    
    //get first match
    [self firstMatch];
    
}

- (void)firstMatch{
    NSLog(@"first Match");
    
    //Get instance of potential matches
    PotentialMatches *obj =[PotentialMatches getInstance];
    
    //Test to see if the array has potential matches
    if ([obj.potentialMatches count] == 0){
        [self.view addSubview:self.potentialMatchesLoadingView];
        _loading = TRUE;
        [NSTimer    scheduledTimerWithTimeInterval:2.0    target:self    selector:@selector(nextMatch)    userInfo:nil repeats:NO];
        
    }
    
    //If there are users
    else {
        _checkVideoCount = 0;
        [self checkForVideo];
    }
    
}

-(void)checkForVideo{
    _checkVideoCount +=1;
    if (_checkVideoCount<5) {
        
        
        NSLog(@"check for video");
        //Get current potential match
        PotentialMatches *obj =[PotentialMatches getInstance];
        currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
        if ([currentPotentialMatch objectForKey:@"fileURL"]) {
            _loading = FALSE;
            
            //Set text for name label
            _nameLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
            [self.potentialMatchesLoadingView removeFromSuperview];
            
            
            //Load initial instance of self.movieplayer with fileurl of current match
            _videoUrl =[currentPotentialMatch objectForKey:@"fileURL"];
            
            [self.moviePlayer setContentURL:_videoUrl];
            
            
            if ([currentPotentialMatch objectForKey:@"time_remaining"]) {
                [self.moviePlayer setInitialPlaybackTime:[[currentPotentialMatch objectForKey:@"time_remaining"]doubleValue]];
                NSLog(@"video already started %f",[[currentPotentialMatch objectForKey:@"time_remaining"]doubleValue]);
                
                
            }
            
            //Set Profile Pic for current potential match
            [self setProfilePic];
        }
        else{
            [self.view addSubview:self.potentialMatchesLoadingView];
            _loading = TRUE;
            [NSTimer    scheduledTimerWithTimeInterval:2.0    target:self    selector:@selector(checkForVideo)    userInfo:nil repeats:NO];
        }
    }
    else{
        [self nextMatch];
    }
    
}

//Set profile picture for current potential match
- (void)setProfilePic{
    NSLog(@"setProfilePic");
    
    //Creat URL for image and download image
    NSString *picURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200", [currentPotentialMatch objectForKey:@"facebook_uid"]];
    
    NSLog(@"setProfilePicURL:%@",picURL);
    NSURL *url = [NSURL URLWithString:picURL];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    self.fbProfilePic.image = [UIImage imageWithData:imageData];
    
    //set size limitations of current potential match
    self.fbProfilePic.layer.cornerRadius = self.fbProfilePic.frame.size.height/2;
    self.fbProfilePic.layer.masksToBounds = YES;
    self.fbProfilePic.layer.borderColor = [UIColor colorWithRed:248 green:248 blue:248 alpha:0.4].CGColor;
    self.fbProfilePic.layer.borderWidth = 2.0f;
    
}

//When video is loaded this method is called
- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    //    if (self.moviePlayer.loadState == MPMovieLoadStatePlayable)
    //    {
    //Play Video if Video is loaded and Playable and user is holding play button
    //    [NSTimer scheduledTimerWithTimeInterval: .05
    //                                     target: self
    //                                   selector:@selector(VideoTimer:)
    //                                   userInfo: nil repeats:YES];
    //}
}

/*Captures Screenshot of Current Matching Video*/
- (void)CaptureSnapshot{
    UIImage *thumbnail = [self.moviePlayer thumbnailImageAtTime:self.moviePlayer.currentPlaybackTime
                                                     timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:thumbnail.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    _videoImage = [UIImage imageWithCGImage:cgImage];
    //create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    //once image is captured Blur the image and present it.
    [self BlurImage];
}


/*Blurs and Presents Screenshot of Currenet Matching Video*/
-(void)BlurImage{
    
    //Blur Video Screenshot and add it infront of video
    // self.blur=[[UIImageView alloc] init];
    [self.blur setImage:_videoImage];
    self.blur.userInteractionEnabled = YES;
    self.blur.frame = self.moviePlayer.view.frame;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:self.blur];
        self.blur.hidden = false;
        self.createMatch.hidden = false;
        [self.view insertSubview:self.createMatch aboveSubview:self.blur];
        
    });
    
}

- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification{
    int reason = [[[paramNotification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        //movie finished playing
        if(_likeCurrentUser == FALSE){
            if([currentPotentialMatch objectForKey:@"time_remaining"]){
                [self firstMatch];
                NSLog(@"user left view controller");
                NSLog(@"%f",_timeRemaining);
                [currentPotentialMatch removeObjectForKey:@"time_remaining"];
                PotentialMatches *obj = [PotentialMatches getInstance];
                if ([obj.potentialMatches count] >0) {
                    [obj.potentialMatches replaceObjectAtIndex:0 withObject:currentPotentialMatch];
                }
            }else {
                NSLog(@"%f",_timeRemaining);
                [self userPass];
                NSLog(@"user considered as passed");
            }
            
        }
        if (_likeCurrentUser ==TRUE) {
            [self nextMatch];
        }
    }else if (reason == MPMovieFinishReasonUserExited) {
        //user hit the done button
    }else if (reason == MPMovieFinishReasonPlaybackError) {
        //error
    }
}



- (IBAction)HoldPlay:(id)sender {
    
    if( _loading ==FALSE) {
        _playButtonHeld = TRUE;
        self.blur.hidden = TRUE;
        self.createMatch.hidden = TRUE;
        [self.view bringSubviewToFront:self.moviePlayer.view];
        [self.moviePlayer play];
    }
}

- (IBAction)ReleasePlay:(id)sender {
    
    if(_likeCurrentUser ==FALSE & _loading ==FALSE){
        _playButtonHeld = FALSE;
        [self.moviePlayer pause];
        [self CaptureSnapshot];
    }
}


-(void) playVideo{
    [self.moviePlayer setContentURL:_videoUrl];
    self.moviePlayer.initialPlaybackTime = -.01;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:self.moviePlayer.view];
        [self.view insertSubview:countdownTimer aboveSubview:self.moviePlayer.view];
        
    });
    if(_playButtonHeld == TRUE){
        [self.moviePlayer play];
    }
    else if(playButton.isTouchInside){
        [self.moviePlayer play];
    }
    
    
}



-(void) userPass{
    NSString *urlAsString =@"http://api-dev.countdownsocial.com/user/";
    PotentialMatches *obj =[PotentialMatches getInstance];
    [obj.passedUsers addObject:currentPotentialMatch];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    [fileManager removeItemAtURL:[currentPotentialMatch objectForKey:@"fileURL"] error:NULL];
    //    NSLog(@"Item deleted");
    
    urlAsString = [urlAsString stringByAppendingString:[currentPotentialMatch objectForKey:@"uid"]];
    urlAsString =[urlAsString stringByAppendingString:@"/pass"];
    
    
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    [NSMutableURLRequest requestWithURL:url];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    
    NSString *FbToken = [session accessTokenData].accessToken;
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.operationQueue = _backgroundQueue;
    NSDictionary *params = @{};
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(concurrentQueue, ^{
            
            NSLog(@"JSON: %@", responseObject);
        });
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
    [self nextMatch];
    
}

-(void) reportUser{
    NSString *urlAsString =@"http://api-dev.countdownsocial.com/user/";
    PotentialMatches *obj =[PotentialMatches getInstance];
    [obj.passedUsers addObject:currentPotentialMatch];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    [fileManager removeItemAtURL:[currentPotentialMatch objectForKey:@"fileURL"] error:NULL];
    //    NSLog(@"Item deleted");
    
    urlAsString = [urlAsString stringByAppendingString:[currentPotentialMatch objectForKey:@"uid"]];
    urlAsString =[urlAsString stringByAppendingString:@"/report"];
    
    
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    [NSMutableURLRequest requestWithURL:url];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    
    NSString *FbToken = [session accessTokenData].accessToken;
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.operationQueue = _backgroundQueue;
    NSDictionary *params = @{};
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(concurrentQueue, ^{
            
            NSLog(@"JSON: %@", responseObject);
        });
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
    
}
-(void) userLike{
    
    _likeCurrentUser = TRUE;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    self.blur.hidden = TRUE;
    self.createMatch.hidden = TRUE;
    
    if (self.instagramDeselect.enabled == false) {
        [params setValue:@"true" forKey:@"instagram"];
    }else{
        [params setValue:@"false" forKey:@"instagram"];
    }
    
    if (self.twitterDeselect.enabled == false) {
        [params setValue:@"true" forKey:@"twitter"];
    }else{
        [params setValue:@"false" forKey:@"twitter"];
    }
    
    if (self.snapchatDeselect.enabled == false) {
        [params setValue:@"true" forKey:@"snapchat"];
    }
    else{
        [params setValue:@"false" forKey:@"snapchat"];
    }
    
    if (self.phoneDeselect.enabled == false) {
        [params setValue:@"true" forKey:@"phone"];
    }
    else{
        [params setValue:@"false" forKey:@"phone"];
    }
    
    if (self.facebookDeselect.enabled == false) {
        [params setValue:@"true" forKey:@"facebook"];
    }
    else{
        [params setValue:@"false" forKey:@"facebook"];
    }
    
    
    
    
    
    
    PotentialMatches *obj =[PotentialMatches getInstance];
    [obj.passedUsers addObject:currentPotentialMatch];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    [fileManager removeItemAtURL:[currentPotentialMatch objectForKey:@"fileURL"] error:NULL];
    //    NSLog(@"Item deleted");
    
    
    
    NSString *urlAsString =@"http://api-dev.countdownsocial.com/user/";
    urlAsString = [urlAsString stringByAppendingString:[currentPotentialMatch objectForKey:@"uid"]];
    urlAsString =[urlAsString stringByAppendingString:@"/like"];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.operationQueue = _backgroundQueue;
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject objectForKey:@"liked_user"] != [NSNull null]) {
            NSLog(@"MATCH");
        }
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
    [self.moviePlayer play];
    
}



- (void)nextMatch{
    _likeCurrentUser = FALSE;
    
    PotentialMatches *obj =[PotentialMatches nextMatch];
    //NSLog(@"@%@",obj.potentialMatches);
    if ([obj.potentialMatches count]==0){
        NSLog(@"Potential Matches Empty, wait 15 seconds");
        [self.view addSubview:self.potentialMatchesLoadingView];
        _loading = TRUE;
        [NSTimer    scheduledTimerWithTimeInterval:15.0    target:self    selector:@selector(nextMatch)    userInfo:nil repeats:NO];
        
        
    }
    else {
        NSLog(@"Next Match");
        currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
        NSLog(@"crash ehre?");
        if ([currentPotentialMatch objectForKey:@"fileURL"]){
            _loading = FALSE;
            [self.potentialMatchesLoadingView removeFromSuperview];
            _videoUrl =[currentPotentialMatch objectForKey:@"fileURL"];
            
            //Change lables on main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _nameLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
            });
            
            //play current Match Video
            [self playVideo];
            [self setProfilePic];
        }else{
            NSLog(@"Loading video");
            //self.potentialMatchesLoadingView = [[PotentialMatchesLoadingView alloc]initWithFrame:CGRectMake(0, 90, 320, 320)];
            [self.view addSubview:self.potentialMatchesLoadingView];
            _playButtonHeld = FALSE;
            _loading = TRUE;
            _checkVideoCount = 0;
            [NSTimer    scheduledTimerWithTimeInterval:2.0    target:self    selector:@selector(checkForVideo)    userInfo:nil repeats:NO];
            
        }
        
    }
    
}
//Alert showing there are no more users or a server error has occured.
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"login in again hoping for more matches. button index = %d",buttonIndex);
    
    if (buttonIndex == 1){
        
    }
    if (buttonIndex ==2){
        
    }
}
//Actionsheet listener for social media applications that havent yet been configured
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==0) {
        
        if (buttonIndex == 0) {
            NSLog(@"button index 0 selected");
            LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc]init];
            leftMenuViewController.socialImage.hidden = false;
            leftMenuViewController.homeImage.hidden = true;
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SocialAccountsViewController"]]animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
            
        } else if (buttonIndex == 1) {
            NSLog(@"button index 1 selected");
        }
    }
    if (actionSheet.tag ==1) {
        if (buttonIndex ==0) {
            NSLog(@"report User");
            [self reportUser];
            
            [self userPass];
            _likeCurrentUser = false;
        }
    }
}



-(void)buttonCheck{
    //Check for Twitter Account
    if ([[user objectForKey: @"twitter_username"] isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"twitter_username"]isEqualToString:@""] ||
        [[user objectForKey: @"twitter_username"]isEqualToString:@"<null>"]){
        self.twitterDeselect.hidden = false;
        self.twitterSelect.enabled = false;
        self.twitterDeselect.enabled=TRUE;
        self.twitterSelect.hidden =TRUE;
    }
    else{
        self.twitterDeselect.hidden = TRUE;
        self.twitterSelect.enabled = TRUE;
        self.twitterDeselect.enabled=FALSE;
        self.twitterSelect.hidden=FALSE;
        NSLog(@"Twitter username blank");
    }
    
    //Check for Instagram Account
    if ([[user objectForKey: @"instagram_username"]isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"instagram_username"]isEqualToString:@""] ||
        [[user objectForKey: @"instagram_username"]isEqualToString:@"<null>"]){
        self.instagramDeselect.hidden = FALSE;
        self.instagramSelect.enabled = false;
        self.instagramDeselect.enabled=TRUE;
        self.instagramSelect.hidden =TRUE;
        
    }
    else{
        self.instagramDeselect.hidden = TRUE;
        self.instagramSelect.enabled = TRUE;
        self.instagramDeselect.enabled=false;
        self.instagramSelect.hidden =false;
        
    }
    
    //Check for Phone Number
    if ([[user objectForKey: @"phone_number"]isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"phone_number"]isEqualToString:@""] ||
        [[user objectForKey: @"phone_number"]isEqualToString:@"<null>"]){
        self.phoneDeselect.hidden = FALSE;
        self.phoneSelect.enabled = false;
        self.phoneDeselect.enabled=TRUE;
        self.phoneSelect.hidden =TRUE;
        
    }
    else{
        self.phoneDeselect.hidden = TRUE;
        self.phoneSelect.enabled = TRUE;
        self.phoneDeselect.enabled=false;
        self.phoneSelect.hidden =false;
        
    }
    
    //Check for Snapchat Account
    if ([[user objectForKey: @"snapchat_username"]isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@""] ||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@"<null>"]){
        self.snapchatDeselect.hidden = FALSE;
        self.snapchatSelect.enabled = false;
        self.snapchatDeselect.enabled=TRUE;
        self.snapchatSelect.hidden =TRUE;
        
    }
    else{
        self.snapchatDeselect.hidden = TRUE;
        self.snapchatSelect.enabled = TRUE;
        self.snapchatDeselect.enabled=false;
        self.snapchatSelect.hidden =false;
        
    }
    
    
    
    //Facebook is alwayas available
    self.facebookSelect.hidden=FALSE;
    self.facebookDeselect.enabled =FALSE;
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    PotentialMatches *obj = [PotentialMatches getInstance];
    NSNumber *timeStopped = [NSNumber numberWithDouble:self.moviePlayer.currentPlaybackTime];
    if (_likeCurrentUser ==FALSE) {
        
        if ([obj.potentialMatches count] >0) {
            [[obj.potentialMatches objectAtIndex:0] setValue:timeStopped forKey:@"time_remaining"];
            
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"NSNotification Observer Disappeared");
}

- (void)VideoTimer:(NSTimer *)timer{
    //Initialize CountdownTimer
    _timeRemaining =(1 -(self.moviePlayer.currentPlaybackTime / self.moviePlayer.duration))*100;
    [countdownTimer changePercentage:_timeRemaining];
    if (_timeRemaining ==100) {
        _miniWatchButton.hidden = TRUE;
    }
    else if (_timeRemaining >=15){
        _miniWatchButton.hidden = FALSE;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)enableInstagram:(id)sender {
    if([[user objectForKey:@"instagram_username"] isKindOfClass:[NSNull class]]||
       [[user objectForKey: @"instagram_username"]isEqualToString:@""] ||
       [[user objectForKey: @"instagram_username"]isEqualToString:@"<null>"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You can't match with others on Instagram until you have your Instagram account linked" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Social Account Settings", nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
    }
    else {
        self.instagramSelect.hidden = FALSE;
        self.instagramSelect.enabled=TRUE;
        self.instagramDeselect.hidden=TRUE;
    }
}

- (IBAction)enableTwitter:(id)sender {
    if ([[user objectForKey:@"twitter_username"] isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"twitter_username"]isEqualToString:@""] ||
        [[user objectForKey: @"twitte_username"]isEqualToString:@"<null>"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You can't match with others on Twitter until you have your Twitter account linked" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Social Account Settings", nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
    }
    else {
        self.twitterSelect.hidden=FALSE;
        self.twitterSelect.enabled=TRUE;
        self.twitterDeselect.hidden=TRUE;
    }
}

- (IBAction)enableSnapChat:(id)sender {
    if ([[user objectForKey:@"snapchat_username"] isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@""] ||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@"<null>"]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You can't match with others on Snapchat until you add your Snapchat username" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Social Account Settings", nil];
        actionSheet.tag = 0;
        
        
        [actionSheet showInView:self.view];
    }
    else{
        self.snapchatSelect.hidden=FALSE;
        self.snapchatSelect.enabled=TRUE;
        self.snapchatDeselect.hidden=TRUE;
    }
}

- (IBAction)enableFacebook:(id)sender {
    self.facebookSelect.hidden=FALSE;
    self.facebookSelect.enabled=TRUE;
    self.facebookDeselect.hidden=TRUE;
}

- (IBAction)enablePhone:(id)sender {
    if ([[user objectForKey:@"phone_number"] isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"phone_number"]isEqualToString:@""] ||
        [[user objectForKey: @"phone_number"]isEqualToString:@"<null>"]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"To be able to use this feature you first need to have your phone number added" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Social Account Settings", nil];
        actionSheet.tag = 0;
        
        
        [actionSheet showInView:self.view];
    }
    else{
        
        self.phoneSelect.hidden=FALSE;
        self.phoneSelect.enabled=TRUE;
        self.phoneDeselect.hidden=TRUE;
    }
}

- (IBAction)disableInstagram:(id)sender {
    self.instagramSelect.hidden = TRUE;
    self.instagramDeselect.hidden=FALSE;
    self.instagramDeselect.enabled=TRUE;
    
}

- (IBAction)disableTwitter:(id)sender {
    self.twitterSelect.hidden = TRUE;
    self.twitterDeselect.hidden=FALSE;
    self.twitterDeselect.enabled=TRUE;
    
}

- (IBAction)disableSnapChat:(id)sender {
    self.snapchatSelect.hidden = TRUE;
    self.snapchatDeselect.hidden=FALSE;
    self.snapchatDeselect.enabled=TRUE;
    
}

- (IBAction)disableFacebook:(id)sender {
    self.facebookSelect.hidden = TRUE;
    self.facebookDeselect.enabled=TRUE;
    self.facebookDeselect.hidden=FALSE;
}

- (IBAction)disablePhone:(id)sender {
    self.phoneSelect.hidden = TRUE;
    self.phoneDeselect.hidden=FALSE;
    self.phoneDeselect.enabled=TRUE;
}

- (IBAction)Like:(id)sender {
    if ([currentPotentialMatch count] >0){
        if ([user objectForKey:@"videoUri"] != [NSNull null]) {
            [self userLike];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You don't have a Video!!"
                                                            message:@"You can't connect until you have uploaded a video!"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Okay", nil];
            [alert show];
        }
        
    }
    else{
    }
}

- (IBAction)presentLeftMenu:(id)sender {
    [self.moviePlayer pause];
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

- (IBAction)reportUser:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to report this user for inappropriate video content?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Report User" otherButtonTitles:nil, nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)Pass:(id)sender {
    if ([currentPotentialMatch count] >0){
        [self userPass];
        _likeCurrentUser = false;
        
    }
    else{
    }
}



@end
