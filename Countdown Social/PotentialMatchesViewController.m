//
//  PotentialMatchesViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 5/19/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "PotentialMatchesViewController.h"
#import "PotentialMatches.h"
@interface PotentialMatchesViewController ()


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
    [self.moviePlayer play];
}
- (IBAction)ReleasePlay:(id)sender {
    [self.moviePlayer pause];
    //Get a UIImage from the UIView
    NSLog(@"blur capture");
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Blur the UIImage
    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 10] forKey: @"inputRadius"]; //change number to increase/decrease blur
    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
    
    //create UIImage from filtered image
    UIImage *blurrredImage = [[UIImage alloc] initWithCIImage:resultImage];
    
    //Place the UIImage in a UIImageView
    UIImageView *newView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    newView.image = blurrredImage;
    
    //insert blur UIImageView below transparent view inside the blur image container
    //[blurContainerView insertSubview:newView belowSubview:transparentView];

}


-(void) playVideo{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoHasFinishedPlaying:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
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

@end
