//
//  TwitterViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/12/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "TwitterViewController.h"
#import "LoginLoadViewController.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"
#import "AFOAuth1Client.h"
#import "RESideMenu/RESideMenu.h"
#import "Constants.h"

@interface TwitterViewController ()




@end

@implementation TwitterViewController

//Shows loading animation while Twitter Page is Loading
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

//Stops showing laoding animation while Twitter Page is Loading
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
//Stops showing loading animation while Twitter Page is Loadingif there is an error.
-(void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden =YES;
    self.twitterWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,57,325,506)];
    self.twitterWebView.scalesPageToFit = YES;
    [self.view addSubview:self.twitterWebView];
    [self obtainRequestToken];
    
    NSString *stringURL = @"http://www.twitter.com/";
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSLog(@"%@", accessToken);
    [self.twitterWebView loadRequest:request];
    
    //Post twitter handle if we don't already have it.    
    
    //if ([[user objectForKey: @"twitter_username"]isKindOfClass:[NSNull class]]){
        NSLog(@"Twitter username blank");
    //}
}
-(void)obtainRequestToken{
  
    
    _oauth_consumer_key = @"heFPQutLw9Tppu3jFSeggTzhc";
    _oauth_consumer_secret = @"RNeVuQbB9jZdJhgb2sirw3Zj2vtNVgxyWHhqGJpFPtJofFctMu";
    
    
    // Your application will be sent to the background until the user authenticates, and then the app will be brought back using the callback URL
//    [twitterClient authorizeUsingOAuthWithRequestTokenPath:@"/requesttoken" userAuthorizationPath:@"/authorize" callbackURL:[NSURL URLWithString:@"x-com-YOUR-APP-SCHEME://success"] accessTokenPath:@"/access_token" success:^(AFOAuth1Token *accessToken) {
//        NSLog(@"Success: %@", accessToken);
//    } failure:^(NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    AFOAuth1Client *twitterClient = [[AFOAuth1Client alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/"] key:_oauth_consumer_key secret:_oauth_consumer_secret];
    [twitterClient authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"oauth/authorize" callbackURL:[NSURL URLWithString:@"CountdownSocial://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" scope:nil success:^(AFOAuth1Token *accessToken, id responseObject) {
        NSLog(@"success %@", accessToken.userInfo);
        _twitter_access_token = [NSString stringWithFormat:@"%@", accessToken.key];
        _twitter_username = [accessToken.userInfo objectForKey:@"screen_name"];
        _twitter_id = [accessToken.userInfo objectForKey:@"user_id"];
        [self twitterUsernameUpload];

    } failure:^(NSError *error) {
        NSLog(@"fail %@",error);
    }];
}

-(void)twitterUsernameUpload
{
    
    NSString *urlAsString =kBaseURL;
    urlAsString = [urlAsString stringByAppendingString:@"user"];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSDictionary *params = @{@"twitter_username": _twitter_username,
                             @"twitter_token": _twitter_access_token,
                             @"twitter_uid": _twitter_id};
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        User *Userobj =  [User getInstance];
        Userobj.user = responseObject;

        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)returnToPotentialMatches:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SocialAccountsViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}



@end