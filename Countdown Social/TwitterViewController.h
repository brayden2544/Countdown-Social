//
//  TwitterViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 6/12/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "AppDelegate.h"

@interface TwitterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *returnToPotentialMatches;

@property(nonatomic, strong) UIWebView *twitterWebView;
@property(nonatomic, strong) NSString *twitter_username;
@property(nonatomic, strong) NSString *twitter_id;
@property(nonatomic, strong) NSString *oauth_consumer_key;
@property(nonatomic, strong) NSString *oauth_consumer_secret;
@property(nonatomic, strong) NSString *twitter_access_token;


@end
