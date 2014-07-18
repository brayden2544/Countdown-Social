//
//  WaitingAnimation.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/15/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WaitingAnimation : UIView
{
    CAShapeLayer *shapeLayer;
    UIColor *pieColor;
}
@property CGFloat radius;
@property CGFloat stroke;
@property bool color;

- (void)changePercentage:(CGFloat)percentage;

@end
