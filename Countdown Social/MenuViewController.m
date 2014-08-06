//
//  MenuViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 5/21/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "MenuViewController.h"
#import "RESideMenu.h"
#import "PotentialMatchesViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController




-(void)awakeFromNib{
    self.contentViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.rightMenuViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    self.backgroundImage = [UIImage imageNamed:@"gbg"];

    self.delegate =self;
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
   }

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer{
    NSLog(@"gesture recognized");
}



@end
