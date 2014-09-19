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

@property (strong, nonatomic) IBOutlet UIImageView *pageImage;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property NSUInteger pageIndex;
@property NSString *imageFile;

- (IBAction)buttonTouched:(id)sender;


@end
