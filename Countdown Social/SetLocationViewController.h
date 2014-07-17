//
//  SetLocationViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 4/27/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ViewController.h"

#import <MapKit/MapKit.h>
#import "User.h"

@interface SetLocationViewController : ViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *travelModeSwitch;
@property (strong, nonatomic) IBOutlet MKMapView *setLocationMapView;
@property (strong, nonatomic) MKPointAnnotation *travelModeAnnotation;
@property (strong, nonatomic) User *user;
@property (strong ,nonatomic) UIImage* fbProfilePic;
@property (strong, nonatomic) IBOutlet UISwitch *setLocationButton;

- (IBAction)setLocationButton:(id)sender;
- (IBAction)travelModeSwitch:(id)sender;


@end
