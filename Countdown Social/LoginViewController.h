//
//  LoginViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 4/27/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface LoginViewController : ViewController

- (IBAction)buttonTouched:(id)sender;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;


@end
