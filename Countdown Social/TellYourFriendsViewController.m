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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)presentMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
@end
