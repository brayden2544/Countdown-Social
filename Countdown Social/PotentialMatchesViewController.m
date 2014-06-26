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
    [self.moviePlayer play];
}

-(void)BlurImage{
    // Snapshot scene into a UIImage.
    dispatch_async(dispatch_get_main_queue(), ^{

      
    
//    self.blur=[[UIImageView alloc] initWithImage:returnImage];
//    self.blur.userInteractionEnabled = YES;
//    self.blur.frame = self.moviePlayer.view.frame;
//    [self.view addSubview:self.blur];
    });
   
}
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
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.

}

- (IBAction)ReleasePlay:(id)sender {
    [self.moviePlayer pause];
    [self BlurImage];

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
    PotentialMatches *obj =[PotentialMatches getInstance];
    //[obj.PotentialMatches
}

- (void)nextMatch{
    PotentialMatches *obj =[PotentialMatches getInstance];
    NSDictionary *currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
    _videoUrl =[NSURL URLWithString:[currentPotentialMatch objectForKey:@"videoUri"]];
    _nameLabel.text = [currentPotentialMatch objectForKey:@"firstName"];

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
    
    //play current Match Video
    [self playVideo];
    
    

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
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: .5
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
}

- (IBAction)enableTwitter:(id)sender {
}

- (IBAction)enableSnapChat:(id)sender {
}

- (IBAction)enableFacebook:(id)sender {
}

- (IBAction)enablePhone:(id)sender {
}

- (IBAction)disableInstagram:(id)sender {
}

- (IBAction)disableTwitter:(id)sender {
}

- (IBAction)disableSnapChat:(id)sender {
}

- (IBAction)disableFacebook:(id)sender {
}

- (IBAction)disablePhone:(id)sender {
}
@end
