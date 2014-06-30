//
//  PotentialMatchesViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 5/19/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "PotentialMatchesViewController.h"
#import "PotentialMatches.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+ImageEffects.h"

@interface PotentialMatchesViewController ()

@property (strong, nonatomic) IBOutlet UILabel *timer;
@property (retain) UIView *blur;
@property (retain) UIView *darken;
@property (strong, nonatomic) IBOutlet UIView *createMatch;

@property (strong, nonatomic) UIImage *videoImage;

@end

@implementation PotentialMatchesViewController

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
}

-(void)PresentMatchingOptions{
    
}

/*Blurs and Presents Screenshot of Currenet Matching Video*/
-(void)BlurImage{
    // Snapshot scene into a UIImage.
    dispatch_async(dispatch_get_main_queue(), ^{

      
    //Blur Video Screenshot and add it infront of video
    self.blur=[[UIImageView alloc] initWithImage:_videoImage];
    self.blur.userInteractionEnabled = YES;
    self.blur.frame = self.moviePlayer.view.frame;
    [self.view addSubview:self.blur];
        
//    //Add dark image in front of blurred screenshot video
//    self.darken=[[UIView alloc]initWithFrame:CGRectMake(0, 115, 320, 320)];
//    [self.darken setBackgroundColor:[UIColor blackColor]];
//    self.darken.alpha=0.5;
//    [self.view addSubview:self.darken];
        self.createMatch.hidden = false;
        [self.view insertSubview:self.createMatch aboveSubview:self.blur];
        
#warning do real checks to see if user has these disabled or not;
        self.twitterSelect.hidden = FALSE;
        self.phoneSelect.hidden=FALSE;
        self.instagramSelect.hidden=FALSE;
        self.snapchatSelect.hidden=FALSE;
        self.facebookSelect.hidden=FALSE;
        
        self.twitterDeselect.enabled =FALSE;
        self.phoneDeselect.enabled =FALSE;
        self.instagramDeselect.enabled =FALSE;
        self.snapchatDeselect.enabled =FALSE;
        self.facebookDeselect.enabled =FALSE;


        
        
    });
   
}
/*Captures Screenshot of Currenet Matching Video*/
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

- (IBAction)ReleasePlay:(id)sender {
    [self.moviePlayer pause];
    [self CaptureSnapshot];

}


-(void) playVideo{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoHasFinishedPlaying:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
    //remove blur view on play
    //NSBundle *mainBundle = [NSBundle mainBundle];
    //NSURL *url = [mainBundle URLForResource:_videoUrl withExtension:@"mov"];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:_videoUrl];
    //self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://km.support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1211/sample_iTunes.mov"]];
    self.moviePlayer.shouldAutoplay = NO;
    self.moviePlayer.controlStyle =MPMovieControlStyleNone;
    [self.moviePlayer.view setFrame:CGRectMake (0, 115, 320, 320)];
    [self.view addSubview:self.moviePlayer.view];
    
    //self.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    [self.moviePlayer setFullscreen:NO
                           animated:NO];
    NSLog(@"Video Playing");
    
    

}

- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification{
    PotentialMatches *obj =[PotentialMatches nextMatch];
    NSDictionary *currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
    
    _videoUrl =[NSURL URLWithString:[currentPotentialMatch objectForKey:@"videoUri"]];
    NSString *name =[currentPotentialMatch objectForKey:@"firstName"];
    _nameLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
    _meetLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
    
    //play current Match Video
    [self playVideo];

    
}

- (void)nextMatch{
    PotentialMatches *obj =[PotentialMatches nextMatch];
    NSDictionary *currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
    
    _videoUrl =[NSURL URLWithString:[currentPotentialMatch objectForKey:@"videoUri"]];
    NSString *name =[currentPotentialMatch objectForKey:@"firstName"];
    _nameLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
    _meetLabel.text = [currentPotentialMatch objectForKey:@"firstName"];
    
    //play current Match Video
    [self playVideo];


}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    //change countdown timer to circle.
    self.timer.layer.cornerRadius = 19;
    //make countdown timer transparent.
    self.timer.alpha = .7;
    //get Next Match
    [self nextMatch];
    
    
    

}
- (void)VideoTimer:(NSTimer *)timer{
    NSTimeInterval timeRemaining = self.moviePlayer.duration - self.moviePlayer.currentPlaybackTime;
    _countdownLabel.text = [NSString stringWithFormat:@"%.0f", timeRemaining];
    if (timeRemaining < 2){
        _countdownLabel.backgroundColor = [UIColor colorWithRed:(247/255.0) green:(104/255.0) blue:(68/255.0) alpha:1];
    }
    else{
        _countdownLabel.backgroundColor = [UIColor colorWithRed:(74/255.0) green:(74/255.0) blue:(74/255.0) alpha:1];
    }
    
}
- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if ((self.moviePlayer.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"content play length is %g seconds", self.moviePlayer.duration);
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: .2
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
@end
