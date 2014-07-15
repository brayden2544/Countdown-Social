//
//  WaitingAnimation.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/15/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "WaitingAnimation.h"

@implementation WaitingAnimation

@synthesize radius;
@synthesize stroke;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        radius = 50;
        stroke = 2;
        self.frame = CGRectMake(111 ,120,2*radius,2*radius);
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = true;
        
        pieColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1];
        
                
    }
    return self;
}



//Code to make a border around the countdown circle

//- (void)drawRect:(CGRect)rect
//{
//
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(contextRef, 1.0);
//    CGContextSetStrokeColorWithColor(contextRef, [UIColor colorWithRed:142.0/255 green:226.0/255 blue:194.0/255 alpha:1.0].CGColor
//);
//    CGRect circlePoint = (CGRectMake(0, 0, 2*radius, 2*radius));
//
//    CGContextStrokeEllipseInRect(contextRef, circlePoint);
//}

- (void)changePercentage:(CGFloat)percentage
{
    //bring percentage in range 0 to 100
    if(percentage < 0)
    {
        percentage = 0.0;
    }
    if(percentage <25){
        //pieColor = [UIColor colorWithRed:180.0/255 green:60.0/255 blue:75.0/255 alpha:1];
    }
    else{
        //pieColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1];
        
    }
    
    if(percentage > 100)
    {
        percentage = 100;
    }
    
    
    //calls draw rect - if radius cahnged or if u want to change color etc.
    [self setNeedsLayout];
    
    
    CGFloat angle = (percentage * 2*M_PI)/100;
    
    //remove prevoius shape layer
    [shapeLayer removeFromSuperlayer];
    
    //create and add new shape layer drwan according to percentage
    shapeLayer = [self createPieSliceForRadian:angle];
    [self.layer addSublayer:shapeLayer];
}

- (CAShapeLayer *)createPieSliceForRadian:(CGFloat)angle
{
    
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.fillColor = pieColor.CGColor;
    slice.strokeColor = [UIColor clearColor].CGColor;
    slice.lineWidth = 1.0;
    
    CGFloat startAngle = -M_PI_2;
    CGPoint center = CGPointMake(radius,radius);
    
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center];
    
    [piePath addLineToPoint:CGPointMake(center.x + radius * cosf(startAngle), center.y + radius * sinf(startAngle))];
    
    [piePath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:(angle - M_PI_2) clockwise:YES];
    
    [piePath closePath]; // this will automatically add a straight line to the center
    slice.path = piePath.CGPath;
    
    return slice;
}


@end
