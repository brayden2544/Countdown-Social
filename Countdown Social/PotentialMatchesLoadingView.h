//
//  PotentialMatchesLoadingView.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/15/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingAnimation.h"

@interface PotentialMatchesLoadingView : UIView
{
    WaitingAnimation *waitingAnimation;
}
@property float watchTimer;
@property UIImageView *watchButton;

@end
