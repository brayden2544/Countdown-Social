//
//  LoginLoadViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 5/6/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LoginLoadViewController : ViewController <CLLocationManagerDelegate> {
    NSDictionary *user;
    NSMutableArray *potentialMatches;
}
@property (nonatomic,strong) CLLocationManager *currentLocationManager;
@property (nonatomic) NSString *uid;
@property (nonatomic, retain) NSDictionary *user;
@property (nonatomic, retain) NSMutableArray *potentialMatches;

+(LoginLoadViewController*)getInstance;


@end
