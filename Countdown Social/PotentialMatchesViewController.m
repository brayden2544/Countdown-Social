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
#import "Connection.h"
#import "ConnectionsList.h"

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

@property NSTimer *potentialMatchesTimer;

@property NSTimer *loadingTimer;

@end

@implementation PotentialMatchesViewController

@synthesize currentPotentialMatch;
@synthesize currentMatch;
@synthesize user;
@synthesize moviePlayer;
@synthesize playButton;



- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoHasFinishedPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.moviePlayerView.player];
    
    [self.potentialMatchesTimer invalidate];
    self.navigationController.navigationBarHidden = YES;
    //Pull in user object and check buttons.
    User *obj = [User getInstance];
    user = obj.user;
    
    _backgroundQueue = [[NSOperationQueue alloc]init];
    
    //change countdown timer to circle.
    self.timer.layer.cornerRadius = 19;
    countdownTimer = [[CountdownTimer alloc]init];
    [countdownTimer changePercentage:100];
    [self.view addSubview:countdownTimer];
    
    
    
    
    self.potentialMatchesLoadingView = [[PotentialMatchesLoadingView alloc]initWithFrame:CGRectMake(0, 57, 320, 363)];
    
    self.moviePlayerView = [[PlayerView alloc]initWithFrame:CGRectMake (0, 100, 320, 320)];
    self.moviePlayerView.player = [[AVPlayer alloc]init];
    
    self.loadingTimer =[NSTimer scheduledTimerWithTimeInterval: .05
                                                        target: self
                                                      selector:@selector(VideoTimer:)
                                                      userInfo: nil repeats:YES];

    
    self.blur=[[UIImageView alloc] initWithFrame:CGRectMake (0, 100, 320, 320)];
    
    
    
    //make countdown timer transparent.
    self.timer.alpha = .7;
    
    NSLog(@"ViewDidLoad");
    
    //Create Seven Switches
    CGRect switchRect = CGRectMake(0, 0, 50 , 80);
    
    self.facebookSwitch = [[SevenSwitch alloc]initWithFrame:switchRect];
    self.instagramSwitch =[[SevenSwitch alloc]initWithFrame:switchRect];
    self.phoneSwitch = [[SevenSwitch alloc]initWithFrame:switchRect];
    self.twitterSwitch = [[SevenSwitch alloc]initWithFrame:switchRect];
    self.snapchatSwitch = [[SevenSwitch alloc]initWithFrame:switchRect];
    
    self.facebookSwitch.thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"facebookThumb"]];
    self.facebookSwitch.onTintColor = [UIColor colorWithRed:74/255.0 green:110/255.0 blue:169/255.0 alpha:1];
    self.facebookSwitch.center = CGPointMake(40, 210);
    self.facebookSwitch.shadowColor = [UIColor blackColor];
    self.facebookSwitch.borderColor = [UIColor whiteColor];
    [self.facebookSwitch addTarget:self action:@selector(facebook) forControlEvents:UIControlEventValueChanged];
    
    self.phoneSwitch.thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"phoneThumb"]];
    self.phoneSwitch.onTintColor = [UIColor colorWithRed:103/255.0 green:190/255.0 blue:8/255.0 alpha:1];
    self.phoneSwitch.center = CGPointMake(100, 210);
    self.phoneSwitch.shadowColor = [UIColor blackColor];
    self.phoneSwitch.borderColor = [UIColor whiteColor];
    [self.phoneSwitch addTarget:self action:@selector(phone) forControlEvents:UIControlEventValueChanged];
    
    self.snapchatSwitch.thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"snapchatThumb"]];
    self.snapchatSwitch.onTintColor = [UIColor colorWithRed:248/255.0 green:231/255.0 blue:28/255.0 alpha:1];
    self.snapchatSwitch.center = CGPointMake(160, 210);
    self.snapchatSwitch.shadowColor = [UIColor blackColor];
    self.snapchatSwitch.borderColor = [UIColor whiteColor];
    [self.snapchatSwitch addTarget:self action:@selector(snapchat) forControlEvents:UIControlEventValueChanged];

    self.twitterSwitch.thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"twitterThumb"]];
    self.twitterSwitch.onTintColor = [UIColor colorWithRed:64/255.0 green:153/255.0 blue:255/255.0 alpha:1];
    self.twitterSwitch.center = CGPointMake(220, 210);
    self.twitterSwitch.shadowColor = [UIColor blackColor];
    self.twitterSwitch.borderColor = [UIColor whiteColor];
    [self.twitterSwitch addTarget:self action:@selector(twitter) forControlEvents:UIControlEventValueChanged];

    
    self.instagramSwitch.thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"instagramThumb"]];
    self.instagramSwitch.onTintColor = [UIColor colorWithRed:69/255.0 green:131/255.0 blue:177/255.0 alpha:1];
    self.instagramSwitch.center = CGPointMake(280, 210);
    self.instagramSwitch.shadowColor = [UIColor blackColor];
    self.instagramSwitch.borderColor = [UIColor whiteColor];
    [self.instagramSwitch addTarget:self action:@selector(instagram) forControlEvents:UIControlEventValueChanged];

//    self.instagramSwitch.alpha = 0.8;
//    self.facebookSwitch.alpha = 0.8;
//    self.phoneSwitch.alpha = 0.8;
//    self.twitterSwitch.alpha = 0.8;
//    self.snapchatSwitch.alpha = 0.8;

    
    [self.createMatch addSubview:self.instagramSwitch];
    [self.createMatch addSubview:self.facebookSwitch];
    [self.createMatch addSubview:self.phoneSwitch];
    [self.createMatch addSubview:self.twitterSwitch];
    [self.createMatch addSubview:self.snapchatSwitch];

    //Perform Button Check after switch creation
    [self buttonCheck];

    
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
    if (_checkVideoCount<100) {
        
        
        NSLog(@"check for video");
        //Get current potential match
        PotentialMatches *obj =[PotentialMatches getInstance];
        currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
        if ([currentPotentialMatch objectForKey:@"fileURL"]) {
            _loading = FALSE;
            _likeCurrentUser = FALSE;
            
            //Set text for name label
            _nameLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
            [self.potentialMatchesLoadingView removeFromSuperview];
            
            //Load initial instance of self.movieplayer with fileurl of current match
            _videoUrl =[currentPotentialMatch objectForKey:@"fileURL"];
            self.currentVideo = [AVAsset assetWithURL:_videoUrl];
            self.currentVideoItem = [AVPlayerItem playerItemWithAsset:self.currentVideo];
            [self.moviePlayerView.player replaceCurrentItemWithPlayerItem:self.currentVideoItem];
            self.moviePlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayerView.player] ;
            //self.moviePlayerView.backgroundColor = [UIColor redColor];
            [self.moviePlayerView.layer addSublayer:self.moviePlayerLayer];
            [self.view addSubview:self.moviePlayerView];
            if ([currentPotentialMatch objectForKey:@"time_remaining"]){
                CMTime startPoint = [[currentPotentialMatch objectForKey:@"time_remaining"]CMTimeValue];
                [self.moviePlayerView.player seekToTime:startPoint];
                
            }
            
            //Set Profile Pic for current potential match
            [self setProfilePic];
        }
        else{
            [self.view addSubview:self.potentialMatchesLoadingView];
            _likeCurrentUser = FALSE;
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
    NSString *picURL = [NSString stringWithFormat:@"http://api-dev.countdownsocial.com/user/%@/photo", [currentPotentialMatch objectForKey:@"uid"]];
    
    NSLog(@"setProfilePicURL:%@",picURL);
    NSURL *url = [NSURL URLWithString:picURL];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    
    NSString *FbToken = [session accessTokenData].accessToken;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    manager.operationQueue = _backgroundQueue;
    [manager GET:picURL parameters:@{@"height":@200,
                                     @"width": @200} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.fbProfilePic.image = responseObject;
        NSLog(@"resonse Object %@",responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Photo failed to load%@",error);
    }];
     
    
    //set size limitations of current potential match
    self.fbProfilePic.layer.cornerRadius = self.fbProfilePic.frame.size.height/2;
    self.fbProfilePic.layer.masksToBounds = YES;
//    self.fbProfilePic.layer.borderColor = [UIColor colorWithRed:248 green:248 blue:248 alpha:0.4].CGColor;
//    self.fbProfilePic.layer.borderWidth = 2.0f;
    
}

/*Captures Screenshot of Current Matching Video*/
- (void)CaptureSnapshot{
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:self.currentVideo];
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:self.moviePlayer.currentTime actualTime:NULL error:NULL];
//    UIImage *thumbnail = [self.moviePlayer thumbnailImageAtTime:self.moviePlayer.currentPlaybackTime
//                                                     timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:thumbnail.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:12.0f] forKey:@"inputRadius"];
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
    self.darken=[[UIView alloc] initWithFrame:self.moviePlayerView.frame];
    self.darken.backgroundColor = [UIColor colorWithRed:34/255.0 green:48/255.0 blue:46/255.0 alpha:1];
    self.darken.alpha = 0.4;
    [self.blur setImage:_videoImage];
    self.blur.userInteractionEnabled = YES;
    self.blur.frame = self.moviePlayerLayer.frame;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:self.blur];
        [self.view insertSubview:self.darken aboveSubview:self.blur];
        self.blur.hidden = false;
        self.createMatch.hidden = false;
        [self.view insertSubview:self.createMatch aboveSubview:self.darken];
        
    });
    
}

- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification{
            //movie finished playing
        if(_likeCurrentUser == FALSE){
         
            [self userPass];
            
        }else{
            [self nextMatch];
            _likeCurrentUser = FALSE;
        }
    
      }



- (IBAction)HoldPlay:(id)sender {
    
    if( _loading ==FALSE & _likeCurrentUser ==FALSE) {
        _playButtonHeld = TRUE;
        self.blur.hidden = TRUE;
        self.createMatch.hidden = TRUE;
        self.darken.hidden = TRUE;
        [self.view bringSubviewToFront:self.moviePlayerView];
        [self.moviePlayerView.player play];
    }
}

- (IBAction)ReleasePlay:(id)sender {
    
    if(_likeCurrentUser ==FALSE & _loading ==FALSE){
        _playButtonHeld = FALSE;
        [self.moviePlayerView.player pause];
        [self CaptureSnapshot];
    }
}


-(void) playVideo{
    //[self.moviePlayer setContentURL:_videoUrl];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:self.moviePlayerView];
        [self.view insertSubview:countdownTimer aboveSubview:self.moviePlayerView];
        
    });
    if(_playButtonHeld == TRUE){
        [self.moviePlayerView.player play];
    }
    else if(playButton.isTouchInside){
        [self.moviePlayerView.player play];
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
    self.darken.hidden = TRUE;
    
    if (self.instagramSwitch.isOn == TRUE) {
        [params setValue:@"true" forKey:@"instagram"];
    }else{
        [params setValue:@"false" forKey:@"instagram"];
    }
    
    if (self.twitterSwitch.isOn == TRUE) {
        [params setValue:@"true" forKey:@"twitter"];
    }else{
        [params setValue:@"false" forKey:@"twitter"];
    }
    
    if (self.snapchatSwitch.isOn == TRUE) {
        [params setValue:@"true" forKey:@"snapchat"];
    }
    else{
        [params setValue:@"false" forKey:@"snapchat"];
    }
    
    if (self.phoneSwitch.isOn == TRUE) {
        [params setValue:@"true" forKey:@"phone"];
    }
    else{
        [params setValue:@"false" forKey:@"phone"];
    }
    
    if (self.facebookSwitch.isOn == TRUE) {
        [params setValue:@"true" forKey:@"facebook"];
    }
    else{
        [params setValue:@"false" forKey:@"facebook"];
    }
    
    
    
    
    
    
    PotentialMatches *obj =[PotentialMatches getInstance];
    [obj.passedUsers addObject:currentPotentialMatch];
    
    
    
    
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
            currentMatch = responseObject;
            [ConnectionsList updateMatches];
            
            //Add timer to show match at end of video
            CMTime time = self.moviePlayerView.player.currentItem.currentTime;
            Float64 time_seconds = CMTimeGetSeconds(time);
            [NSTimer timerWithTimeInterval:6 - time_seconds target:self selector:@selector(showMatch) userInfo:nil repeats:NO];
            
        }else{
        }

    }
          failure:^(AFHTTPRequestOperation *operation,  NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    [self.moviePlayerView.player play];

    
}

-(void)showMatch{
    //Set Connection Message
    Connection *obj = [Connection getInstance];
    obj.connection = currentMatch;
    [self nextMatch];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ConnectionViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
  
}

- (void)nextMatch{
    _likeCurrentUser = FALSE;
    
    PotentialMatches *obj =[PotentialMatches nextMatch];
    //NSLog(@"@%@",obj.potentialMatches);
    if ([obj.potentialMatches count]==0){
        NSLog(@"Potential Matches Empty, wait 15 seconds");
        [self.view addSubview:self.potentialMatchesLoadingView];
        _loading = TRUE;
        [self.potentialMatchesTimer invalidate];
        self.potentialMatchesTimer = [NSTimer    scheduledTimerWithTimeInterval:15.0    target:self    selector:@selector(nextMatch)    userInfo:nil repeats:NO];
        
        
    }
    else {
        NSLog(@"Next Match");
        currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
        if ([currentPotentialMatch objectForKey:@"fileURL"]){
            _loading = FALSE;
            [self.potentialMatchesLoadingView removeFromSuperview];
            _videoUrl =[currentPotentialMatch objectForKey:@"fileURL"];
            self.currentVideo = [AVAsset assetWithURL:_videoUrl];
            self.currentVideoItem = [AVPlayerItem playerItemWithAsset:self.currentVideo];
            [self.moviePlayerView.player replaceCurrentItemWithPlayerItem:self.currentVideoItem];

            
            //Change lables on main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _nameLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
                [self.nameView startCanvasAnimation];
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
        [self.twitterSwitch setOn:FALSE];
    }
    else{
        [self.twitterSwitch setOn:TRUE];
    }
    
    //Check for Instagram Account
    if ([[user objectForKey: @"instagram_username"]isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"instagram_username"]isEqualToString:@""] ||
        [[user objectForKey: @"instagram_username"]isEqualToString:@"<null>"]){
        [self.instagramSwitch setOn:FALSE];
        
    }
    else{
        [self.instagramSwitch setOn:TRUE];
    }
    
    //Check for Phone Number
    if ([[user objectForKey: @"phone_number"]isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"phone_number"]isEqualToString:@""] ||
        [[user objectForKey: @"phone_number"]isEqualToString:@"<null>"]){
        [self.phoneSwitch setOn:FALSE];
        
    }
    else{
        [self.phoneSwitch setOn:TRUE];
    }
    
    //Check for Snapchat Account
    if ([[user objectForKey: @"snapchat_username"]isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@""] ||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@"<null>"]){
        [self.snapchatSwitch setOn:FALSE];
        
    }
    else{
        [self.snapchatSwitch setOn:TRUE];
        
    }
    
    
    
    //Facebook is alwayas available
    [self.facebookSwitch setOn:YES animated:YES];
    
    
}

-(void)facebook{
    //facebook doesn't need to do anything
}

-(void)phone{
    if ([[user objectForKey: @"phone_number"]isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"phone_number"]isEqualToString:@""] ||
        [[user objectForKey: @"phone_number"]isEqualToString:@"<null>"]){
        [self.phoneSwitch setOn:FALSE];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"To be able to use this feature you first need to have your phone number added" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Social Account Settings", nil];
        actionSheet.tag = 0;
        
        
        [actionSheet showInView:self.view];
    }

   
}

-(void)snapchat{
    if ([[user objectForKey:@"snapchat_username"] isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@""] ||
        [[user objectForKey: @"snapchat_username"]isEqualToString:@"<null>"]){
        [self.snapchatSwitch setOn:FALSE];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You can't match with others on Snapchat until you add your Snapchat username" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Social Account Settings", nil];
        actionSheet.tag = 0;
        
        
        [actionSheet showInView:self.view];
    }

}

-(void)twitter{
    if ([[user objectForKey:@"twitter_username"] isKindOfClass:[NSNull class]]||
        [[user objectForKey: @"twitter_username"]isEqualToString:@""] ||
        [[user objectForKey: @"twitte_username"]isEqualToString:@"<null>"]) {
        [self.twitterSwitch setOn:FALSE];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You can't match with others on Twitter until you have your Twitter account linked" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Social Account Settings", nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
    }
    
}

-(void)instagram{
    if([[user objectForKey:@"instagram_username"] isKindOfClass:[NSNull class]]||
       [[user objectForKey: @"instagram_username"]isEqualToString:@""] ||
       [[user objectForKey: @"instagram_username"]isEqualToString:@"<null>"]) {
        [self.instagramSwitch setOn:FALSE];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You can't match with others on Instagram until you have your Instagram account linked" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Social Account Settings", nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    if (_likeCurrentUser ==FALSE) {
        if ([currentPotentialMatch objectForKey:@"fileURL" ]) {
            CMTime time = self.moviePlayerView.player.currentItem.currentTime;
            Float64 time_seconds = CMTimeGetSeconds(time);
            NSNumber *time_remaining = [[NSNumber alloc]initWithDouble:time_seconds];
            [currentPotentialMatch setValue:time_remaining forKey:@"time_remaining"];
        }
    }
    [self.loadingTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"NSNotification Observer Disappeared");
    
    if (_likeCurrentUser == true) {
        [self nextMatch];
    }
}


- (void)VideoTimer:(NSTimer *)timer{
    //Initialize CountdownTimer
    Float64 timeLeft = CMTimeGetSeconds(self.moviePlayerView.player.currentItem.currentTime);
    Float64 duration = CMTimeGetSeconds(self.moviePlayerView.player.currentItem.duration);
    _timeRemaining =(1 -(timeLeft / duration))*100;
    [countdownTimer changePercentage:_timeRemaining];
    if (_timeRemaining ==100) {
        _miniWatchButton.hidden = TRUE;
    }
    else if (_timeRemaining >=15){
        _miniWatchButton.hidden = FALSE;
    }
    
}


- (IBAction)Like:(id)sender {

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

- (IBAction)presentLeftMenu:(id)sender {
    if (_likeCurrentUser == false) {
        [self.moviePlayerView.player pause];
    }
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

- (IBAction)presentRightMenu:(id)sender {
    if (_likeCurrentUser == false) {
        [self.moviePlayerView.player pause];
    }
    [self.sideMenuViewController presentRightMenuViewController];
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
}



@end
