//
//  UserProfileViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/29/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Connection.h"
#import  "User.h"
#import "AppDelegate.h"
#import "AFNetworking/AFOAuth1Client.h"
#import "MessagesViewController.h"
#import "ResideMenu.h"
@interface UserProfileViewController ()
@property NSDictionary *user;
@property NSDictionary *connection;
@property AFHTTPRequestOperationManager *manager;
@property UIWebView *socialMediaWebView;
@property UIButton *closeButton;

@end

@implementation UserProfileViewController
@synthesize connection;
@synthesize manager;
@synthesize user;
@synthesize socialMediaWebView;
@synthesize closeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(80, 210, 160, 40);
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    socialMediaWebView= [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width , self.view.frame.size.height - 20.0)];
    socialMediaWebView.layer.cornerRadius = 15.0;
    socialMediaWebView.layer.masksToBounds = YES;
    
    self.navigationController.navigationBarHidden = YES;
    Connection *obj = [Connection getInstance];
    connection = [obj.connection objectForKey:@"liked_user"];
    
    User *userObj = [User getInstance];
    user = userObj.user;
    self.nameLabel.text = [connection objectForKey:@"firstName"];
    manager = [AFHTTPRequestOperationManager manager];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    [self getImages];
    [self checkSocial];
    
}

- (void)getImages{
    
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];

    NSString *picURL = [NSString stringWithFormat:@"http://api-dev.countdownsocial.com/user/%@/photo", [connection objectForKey:@"uid"]];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:picURL parameters:@{@"height":@300,
                                     @"width": @300} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         self.profilePic.image = responseObject;
                                         self.backgroundProfilePic.image = responseObject;
                                         self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height/2;
                                         self.profilePic.layer.masksToBounds =YES;
                                         NSLog(@"resonse Object %@",responseObject);
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Photo failed to load%@",error);
                                     }];

}

- (void)checkSocial{
    if ([[connection objectForKey:@"facebook_uid"]isKindOfClass:[NSNull class]]) {
        //Facebook not shared
        self.facebookProfile.enabled = FALSE;
        self.facebookProfile.hidden = TRUE;
        self.facebokAdded.enabled = FALSE;
        self.facebokAdded.hidden = TRUE;
        self.facebookAdd.enabled = FALSE;
        self.facebookAdd.hidden =TRUE;
        self.facebookCircle.hidden = TRUE;
    }else{
        [self facebookCheck];
        
    }
    if ([[connection objectForKey:@"instagram_username"]isKindOfClass:[NSNull class]]) {
        //Instagram not shared
        self.instagramProfile.enabled = FALSE;
        self.instagramProfile.hidden = TRUE;
        self.instagramAdded.enabled = FALSE;
        self.instagramAdded.hidden = TRUE;
        self.instagramAdd.enabled = FALSE;
        self.instagramAdd.hidden =TRUE;
        self.instagramCircle.hidden = TRUE;
    }else{
        [self instagramCheck];
        
    }
    if ([[connection objectForKey:@"phone_number"]isKindOfClass:[NSNull class]]) {
        //Phone Number not shared
        self.phoneProfile.enabled = FALSE;
        self.phoneProfile.hidden = TRUE;
        self.phoneAdded.enabled = FALSE;
        self.phoneAdded.hidden = TRUE;
        self.phoneAdd.enabled = FALSE;
        self.phoneAdd.hidden =TRUE;
        self.phoneCircle.hidden = TRUE;
    }else{
        
    }
    if ([[connection objectForKey:@"snapchat_username"]isKindOfClass:[NSNull class]]) {
        //Facebook not shared
        self.snapchatProfile.enabled = FALSE;
        self.snapchatProfile.hidden = TRUE;
        self.snapchatAdded.enabled = FALSE;
        self.snapchatAdded.hidden = TRUE;
        self.snapchatAdd.enabled = FALSE;
        self.snapchatAdd.hidden =TRUE;
        self.snapchatCircle.hidden = TRUE;
    }else{
        
    }
    if ([[connection objectForKey:@"twitter_username"]isKindOfClass:[NSNull class]]) {
        //Facebook not shared
        self.twitterProfile.enabled = FALSE;
        self.twitterProfile.hidden = TRUE;
        self.twitterAdded.enabled = FALSE;
        self.twitterAdded.hidden = TRUE;
        self.twitterAdd.enabled = FALSE;
        self.twitterAdd.hidden =TRUE;
        self.twitterCircle.hidden = TRUE;
    }else{
        [self twitterCheck];
    }
}

- (void)facebookCheck{
    self.facebookCircle.hidden = FALSE;
    self.facebookProfile.hidden = FALSE;
    self.facebookProfile.enabled = TRUE;
    /* make the API call */
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/friends/%@", [[user objectForKey:@"facebook_uid"]stringValue], [[connection objectForKey:@"facebook_uid"]stringValue]]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              NSArray *friendInfo = (NSArray *) [result objectForKey:@"data"];
                              NSLog(@"%@",result);
                              if ([friendInfo count]>0) {
                                  self.facebokAdded.hidden = FALSE;
                                  self.facebokAdded.enabled = TRUE;
                                  self.facebookAdd.hidden = TRUE;
                                  self.facebookAdd.enabled = FALSE;
                              }else{
                                  NSLog(@"showing up as false");
                                  self.facebokAdded.hidden = TRUE;
                                  self.facebokAdded.enabled = FALSE;
                                  self.facebookAdd.hidden = FALSE;
                                  self.facebookAdd.enabled = TRUE;
                              }
                          }];}

- (void)twitterCheck{
    
//    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//    int length = 42;
//    NSMutableString *nonce = [NSMutableString stringWithCapacity: length];
//    for (int i = 0; i < length; i++) {
//        [nonce appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
//    }
//    NSString *oauth_consumer_key = @"heFPQutLw9Tppu3jFSeggTzhc";
//    NSString *oauth_nonce = [nonce copy];
//    NSString *oauth_consumer_secret = @"RNeVuQbB9jZdJhgb2sirw3Zj2vtNVgxyWHhqGJpFPtJofFctMu";
//    NSString *oauth_signature_method = @"HMAC-SHA1";
//    NSInteger numberOfSecs = round([[NSDate date]timeIntervalSince1970]);
//    NSString *oauth_timestamp = [NSString stringWithFormat:@"%i",numberOfSecs];
//    NSString *oauth_token = [NSString stringWithFormat:@"%@",[user objectForKey:@"twitter_token"]];
//
//    self.twitterCircle.hidden = FALSE;
//    self.twitterProfile.hidden = FALSE;
//    self.twitterProfile.enabled = TRUE;
    }

- (void) instagramCheck{
    self.instagramCircle.hidden = FALSE;
    self.instagramProfile.hidden = FALSE;
    self.instagramProfile.enabled = TRUE;
    NSString *instaUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship?/access_token=%@", [connection objectForKey:@"instagram_uid"], [user objectForKey:@"instagram_token"]];
//    [manager GET:instaUrl parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                         NSLog(@"resonse Object %@",responseObject);
//                                         
//                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         NSLog(@"Photo failed to load%@",error);
//                                     }];

}

- (IBAction)backToConnections:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PotentialMatchesViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    [self.sideMenuViewController presentRightMenuViewController];
}

- (IBAction)goToMessaging:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];}

- (IBAction)goToUserVideo:(id)sender {
}

- (IBAction)addFacebookFriend:(id)sender {
    NSString *fullURL = [NSString stringWithFormat:@"http://www.facebook.com/addfriend.php?id=%@",[connection objectForKey:@"facebook_uid"] ];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [socialMediaWebView loadRequest:requestObj];
    [self.view addSubview:socialMediaWebView];

}

@end
