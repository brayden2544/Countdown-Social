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
#import "UIImage+ImageEffects.h"
#import "AppDelegate.h"

@interface PotentialMatchesViewController ()

@property (strong, nonatomic) IBOutlet UILabel *timer;
@property (retain) UIView *blur;
@property (retain) UIView *darken;
@property (strong, nonatomic) IBOutlet UIView *createMatch;
@property  BOOL *playButtonHeld;
@property (strong, nonatomic) UIImage *videoImage;

@end

@implementation PotentialMatchesViewController

@synthesize currentPotentialMatch;
@synthesize user;
@synthesize moviePlayer;
@synthesize menuOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (IBAction)HoldPlay:(id)sender {
    [self.blur removeFromSuperview];
    self.createMatch.hidden = TRUE;
    [self.moviePlayer play];
    _playButtonHeld = true;
}






/*Blurs and Presents Screenshot of Currenet Matching Video*/
-(void)BlurImage{

        //Blur Video Screenshot and add it infront of video
        self.blur=[[UIImageView alloc] initWithImage:_videoImage];
        self.blur.userInteractionEnabled = YES;
        self.blur.frame = self.moviePlayer.view.frame;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:self.blur];
        self.createMatch.hidden = false;
        [self.view insertSubview:self.createMatch aboveSubview:self.blur];
        
    });
   
}
/*Captures Screenshot of Current Matching Video*/
- (void)CaptureSnapshot{
    UIImage *thumbnail = [self.moviePlayer thumbnailImageAtTime:0.1
                                                     timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:thumbnail.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    _videoImage = [UIImage imageWithCGImage:cgImage];
    //create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    [self BlurImage];
}
- (void) playButtonReleased {
    [self.moviePlayer pause];
    [self CaptureSnapshot];
    _playButtonHeld = false;
}
- (IBAction)ReleasePlay:(id)sender {
    [self playButtonReleased];

}


-(void) playVideo{

        if (menuOpen == false){
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(videoHasFinishedPlaying:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:self.moviePlayer];

    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:_videoUrl];
    self.moviePlayer.shouldAutoplay = NO;
    self.moviePlayer.controlStyle =MPMovieControlStyleNone;
    [self.moviePlayer.view setFrame:CGRectMake (0, 115, 320, 320)];
    [self.view addSubview:self.moviePlayer.view];
    
    //self.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    [self.moviePlayer setFullscreen:NO
                           animated:NO];
    NSLog(@"Video Loaded");

    }

}

-(void) userPass{
    NSString *urlAsString =@"http://api-dev.countdownsocial.com/user/";
    urlAsString = [urlAsString stringByAppendingString:[[currentPotentialMatch objectForKey:@"uid"] stringValue]];
    urlAsString =[urlAsString stringByAppendingString:@"/pass"];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    
    NSString *FbToken = [session accessTokenData].accessToken;
    
    
    [urlRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSOperationQueue *queque = [[NSOperationQueue alloc] init];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        
        
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
                 NSLog(@"%@",html);
                 
           
    
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"POST Nothing was downloaded.");
             }
             else if (error !=nil){
                 NSLog(@"Error happened = %@", error);
                 NSLog(@"POST BROKEN");
#warning TODO: Create alert and restart app in case of bad server connection.
             }
         }];
    });
    
    [self nextMatch];

}

- (void)setProfilePic{
    NSString *picURL = @"http://graph.facebook.com/";
    //NSString *uid =[[currentPotentialMatch objectForKey:@"uid"] stringValue];
#warning enable this top one once we are using real users.
    NSString *uid = @"1159358848";
    picURL= [picURL stringByAppendingString:uid];
    picURL = [picURL stringByAppendingString:@"/picture?width=200&height=200"];
    NSURL *url = [NSURL URLWithString:picURL];
    NSLog(@"%@",picURL);
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    self.fbProfilePic.layer.cornerRadius = self.fbProfilePic.frame.size.height/2;
    self.fbProfilePic.layer.masksToBounds = YES;
    self.fbProfilePic.layer.borderColor = [UIColor colorWithRed:248 green:248 blue:248 alpha:0.4].CGColor;
    self.fbProfilePic.layer.borderWidth = 2.0f;
    //self.fbProfilePic.alpha = 0.8;

    self.fbProfilePic.image = [UIImage imageWithData:imageData];
}

- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification{
    int reason = [[[paramNotification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        //movie finished playing
        [self userPass];
    }else if (reason == MPMovieFinishReasonUserExited) {
        //user hit the done button
    }else if (reason == MPMovieFinishReasonPlaybackError) {
        //error
    }
    }

- (void)nextMatch{
    PotentialMatches *obj =[PotentialMatches nextMatch];
    NSLog(@"@%@",obj.potentialMatches);
    if ([obj.potentialMatches objectAtIndex:0] == [NSNull null]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"You're Out!" message: @"There are no more users near you."
                                                                                     delegate:self
                                                                            cancelButtonTitle:@"Cancel"
                                                                            otherButtonTitles:@"Try Again", @"Leave App", nil];
        [alert show];

    }
    else {
        NSLog(@"Next Match");
        currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
    _videoUrl =[NSURL URLWithString:[currentPotentialMatch objectForKey:@"videoUri"]];
    //NSString *name =[currentPotentialMatch objectForKey:@"firstName"];
    _nameLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
    _meetLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
    
    //play current Match Video
    [self playVideo];
    [self setProfilePic];
    }

}
//Alert showing there are no more users or a server error has occured.
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"login in again hoping for more matches. button index = %d",buttonIndex);
    
    if (buttonIndex == 1){
    [self nextMatch];
    }
    if (buttonIndex ==2){
        exit(0);
    }
}


- (void)firstMatch{
    PotentialMatches *obj =[PotentialMatches getInstance];
    NSLog(@"@%@",obj.potentialMatches);

    if ([obj.potentialMatches count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"You're Out!" message: @"There are no more users near you."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Try Again", nil];
        [alert show];
        
    }
    else {
    
        currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
    _videoUrl =[NSURL URLWithString:[currentPotentialMatch objectForKey:@"videoUri"]];
    //NSString *name =[currentPotentialMatch objectForKey:@"firstName"];
    _nameLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
    _meetLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
    
    //play current Match Video
    [self playVideo];
        NSLog(@"first Match");
    [self setProfilePic];
    }
    
}
-(void)buttonCheck{
    //Check for Twitter Account
    if ((NSNull *)[user objectForKey: @"twitter_username"] == [NSNull null]){
        self.twitterDeselect.hidden = FALSE;
        self.twitterSelect.enabled = false;
        self.twitterDeselect.enabled=TRUE;
        NSLog(@"Twitter username blank");
    }
    else{
        self.twitterDeselect.hidden = TRUE;
        self.twitterSelect.enabled = TRUE;
        self.twitterDeselect.enabled=false;
        self.twitterSelect.hidden =false;
    }
    //Check for Instagram Account
    if ([user objectForKey: @"instagram_username"]){
        self.instagramDeselect.hidden = TRUE;
        self.instagramSelect.enabled = TRUE;
        self.instagramDeselect.enabled=false;
        self.instagramSelect.hidden =false;
        
    }
    else{
        self.instagramDeselect.hidden = FALSE;
        self.instagramSelect.enabled = false;
        self.instagramDeselect.enabled=TRUE;
        self.instagramSelect.hidden =TRUE;
     
    }
    //Check for Phone Number
    if ([user objectForKey: @"phone_number"]){
        self.phoneDeselect.hidden = TRUE;
        self.phoneSelect.enabled = TRUE;
        self.phoneDeselect.enabled=false;
        self.phoneSelect.hidden =false;
        
    }
    else{
        self.phoneDeselect.hidden = FALSE;
        self.phoneSelect.enabled = false;
        self.phoneDeselect.enabled=TRUE;
        self.phoneSelect.hidden =TRUE;
        
    }
    //Check for Snapchat Account
    if ([user objectForKey: @"snapchat_username"]){
        self.snapchatDeselect.hidden = TRUE;
        self.snapchatSelect.enabled = TRUE;
        self.snapchatDeselect.enabled=false;
        self.snapchatSelect.hidden =false;
        
    }
    else{
        self.snapchatDeselect.hidden = FALSE;
        self.snapchatSelect.enabled = false;
        self.snapchatDeselect.enabled=TRUE;
        self.snapchatSelect.hidden =TRUE;
        
    }

    //Facebook is alwayas available
    self.facebookSelect.hidden=FALSE;
    self.facebookDeselect.enabled =FALSE;
    
    
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    //Set menu open to false
    menuOpen = false;
    //Pull in user object and check buttons.
    User *obj = [User getInstance];
    user = obj.user;
    [self buttonCheck];
    //change countdown timer to circle.
    self.timer.layer.cornerRadius = 19;
    countdownTimer = [[CountdownTimer alloc]init];
    [countdownTimer changePercentage:100];
    [self.view addSubview:countdownTimer];
    //make countdown timer transparent.
    self.timer.alpha = .7;
    //get Next Match
    NSLog(@"ViewDidLoad");
    [self firstMatch];
    
    
    

}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)VideoTimer:(NSTimer *)timer{
    //Initialize CountdownTimer
    NSTimeInterval timeRemaining =(1 -(self.moviePlayer.currentPlaybackTime / self.moviePlayer.duration))*100;
    NSNumber *time = [NSNumber numberWithDouble:timeRemaining];
    //countdownTimer = [[CountdownTimer alloc]init];
    [countdownTimer changePercentage:timeRemaining];
    //[self.view addSubview:countdownTimer];

    
    //Get time remaining of users profile
    
    //Set label to time remaining
//    NSNumber *time = [NSNumber numberWithFloat:self.moviePlayer.currentPlaybackTime/6.1f];
//    [self performSelector:@selector(setProgress:) withObject:time afterDelay:0.0];
    
    
    
    
    
    
    
    //    if (timeRemaining < 2){
//        _countdownLabel.backgroundColor = [UIColor colorWithRed:(247/255.0) green:(104/255.0) blue:(68/255.0) alpha:1];
//    }
//    else{
//        _countdownLabel.backgroundColor = [UIColor colorWithRed:(74/255.0) green:(74/255.0) blue:(74/255.0) alpha:1];
//    }
    
}
- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if ((self.moviePlayer.loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable)
    {
        if(_playButtonHeld == TRUE){
            [self.moviePlayer play];
            NSLog(@"New movie played");
        }
        NSLog(@"content play length is %g seconds", self.moviePlayer.duration);
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: .05
                                                      target: self
                                                    selector:@selector(VideoTimer:)
                                                    userInfo: nil repeats:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)enableInstagram:(id)sender {
    self.instagramSelect.hidden = FALSE;
    self.instagramSelect.enabled=TRUE;
    self.instagramDeselect.hidden=TRUE;
}

- (IBAction)enableTwitter:(id)sender {
    self.twitterSelect.hidden=FALSE;
    self.twitterSelect.enabled=TRUE;
    self.twitterDeselect.hidden=TRUE;
}

- (IBAction)enableSnapChat:(id)sender {
    self.snapchatSelect.hidden=FALSE;
    self.snapchatSelect.enabled=TRUE;
    self.snapchatDeselect.hidden=TRUE;
}

- (IBAction)enableFacebook:(id)sender {
    self.facebookSelect.hidden=FALSE;
    self.facebookSelect.enabled=TRUE;
    self.facebookDeselect.hidden=TRUE;
}

- (IBAction)enablePhone:(id)sender {
    self.phoneSelect.hidden=FALSE;
    self.phoneSelect.enabled=TRUE;
    self.phoneDeselect.hidden=TRUE;
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
    [self nextMatch];
}

- (IBAction)Pass:(id)sender {
    [self userPass];
}


@end
