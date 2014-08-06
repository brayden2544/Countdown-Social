//
//  PotentialMatchesLoadingView.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/15/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "PotentialMatchesLoadingView.h"
#import "WaitingAnimation.h"

@implementation PotentialMatchesLoadingView

@synthesize  watchTimer;
@synthesize watchButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:74/240.0 green:72/240.0 blue:74/240.0 alpha:1.0];
        waitingAnimation = [[WaitingAnimation alloc]init];
        [waitingAnimation changePercentage:100];
        [self addSubview:waitingAnimation];
        
        UIImageView *watch = [[UIImageView alloc]initWithFrame:CGRectMake(52, 70, 217, 167)];
        [watch setImage:[UIImage imageNamed:@"watch button in"]];
        watch.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:watch];
        
        watchButton = [[UIImageView alloc]initWithFrame:CGRectMake(202, 98, 23, 18)];
        [watchButton setImage:[UIImage imageNamed:@"watch button out"]];
        watchButton.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:watchButton];
        
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 170, 40)];
        topLabel.text = @"Hang Tight!";
        topLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:31];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:topLabel];
        
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(22 , 260 , 276, 72)];
        bottomLabel.text = @"We're searching for people around you.";
        bottomLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:23];
        bottomLabel.textColor = [UIColor whiteColor];
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.numberOfLines = 2;
        [self addSubview:bottomLabel];
        
        
        
        watchTimer = 0;
        [NSTimer scheduledTimerWithTimeInterval: .01
                                         target: self
                                       selector:@selector(WaitingAnimationTimer:)
                                       userInfo: nil repeats:YES];
        

                              
        

    }
    return self;
}

- (void)WaitingAnimationTimer:(NSTimer *)timer{
    //Initialize CountdownTimer
    if (watchTimer >= 100) {
        watchTimer = 0;
    }
    if (watchTimer ==0){
        watchButton.hidden = TRUE;
    }
    if (watchTimer ==10){
        watchButton.hidden = FALSE;
    }

    watchTimer += .5;
    [waitingAnimation changePercentage:watchTimer];
   }


@end
