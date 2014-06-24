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
    
}


-(void) playVideo{
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
    NSLog(@"%@", _videoUrl);
    
}

- (void)viewDidLoad
{
    PotentialMatches *obj =[PotentialMatches getInstance];
   NSDictionary *currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
    _videoUrl =[NSURL URLWithString:[currentPotentialMatch objectForKey:@"videoUri"]];
    //[NSLog(@"WORK");
     [self playVideo];
    

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
