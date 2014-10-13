//
//  TellYourFriendsViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/18/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "TellYourFriendsViewController.h"
#import "RESideMenu/RESideMenu.h"

@interface TellYourFriendsViewController ()

@end

@implementation TellYourFriendsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
}


- (IBAction)presentMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)share:(id)sender {
    NSString *string = @"Post a video on Countdown, it's the best way to find and meet new people on Insta, Twitter and Snapchat!";
    NSURL *URL =[NSURL URLWithString: @"https://itunes.apple.com/us/app/countdown-watch-connect-follow/id900670257?ls=1&mt=8"];
    UIImage *image = [UIImage imageNamed:@"teal & grey 2@1x"];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL,image]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                     }];
}
@end
