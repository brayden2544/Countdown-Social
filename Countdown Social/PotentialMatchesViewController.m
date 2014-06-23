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

-(void) playVideo{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [mainBundle URLForResource:_videoUrl withExtension:@"mov"];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    
    [self.view addSubview:self.moviePlayer.view];
    
    [self.moviePlayer setFullscreen:YES
                           animated:NO];
    NSLog(@"movie playing");
    
    [self.moviePlayer play];
}

- (void)viewDidLoad
{
    PotentialMatches *obj =[PotentialMatches getInstance];
   NSDictionary *currentPotentialMatch =[obj.potentialMatches objectAtIndex:0];
    _videoUrl =[currentPotentialMatch objectForKey:@"videoUri"];
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
