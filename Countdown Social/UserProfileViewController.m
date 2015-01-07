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
#import "ConnectionsList.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "Constants.h"

@interface UserProfileViewController ()
@property NSDictionary *user;
@property NSMutableDictionary *connection;
@property AFHTTPRequestOperationManager *manager;
@property UIWebView *socialMediaWebView;
@property UIButton *closeButton;
@property UIActivityIndicatorView *activityView;
@property UIView *loadingView;
@property NSURL *facebookURL;

@end

@implementation UserProfileViewController
@synthesize connection;
@synthesize manager;
@synthesize user;
@synthesize socialMediaWebView;
@synthesize closeButton;
@synthesize activityView;
@synthesize loadingView;
@synthesize facebookURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    closeButton.frame = CGRectMake(3,14  , 45, 45);
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    //[closeButton setImage:[UIImage imageNamed:@"back button"] forState:UIControlStateNormal];
    closeButton.hidden = YES;
    // Do any additional setup after loading the view.
    socialMediaWebView= [[UIWebView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width , self.view.frame.size.height - 60.0)];
    socialMediaWebView.layer.cornerRadius = 15.0;
    socialMediaWebView.layer.masksToBounds = YES;
    socialMediaWebView.delegate = self;
    [socialMediaWebView setBackgroundColor:[UIColor whiteColor]];
    
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
    [self notificationStatus];
    [self.view addSubview:closeButton];
    
    //create loading view
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, socialMediaWebView.frame.size.width , socialMediaWebView.frame.size.height)];
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    
    activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, loadingView.frame.size.height/2);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    [socialMediaWebView addSubview:loadingView];
    [self fetchFacebookUrl];
    if ([[connection objectForKey:@"video_filename"]isKindOfClass:[NSNull class]]) {
        self.viewVideoButton.hidden = true;
    }else{
        self.viewVideoButton.hidden = false;
    }


}

-(void)fetchFacebookUrl{
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@", [connection objectForKey:@"facebook_uid"]] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error == nil) {
            facebookURL = [NSURL URLWithString:[result objectForKey:@"link"]];
            NSLog(@"Facebook url is %@",facebookURL);
        }else{
            NSLog(@"error:%@",error);
            NSLog(@"Facebook url is %@",facebookURL);

        }

    }];
}
- (void)notificationStatus{
    Connection *obj = [Connection getInstance];
    if ([[obj.connection objectForKey:@"is_new"]boolValue] ==1 ) {
        NSMutableDictionary *viewedConnection = [[NSMutableDictionary alloc]initWithDictionary: connection];
        [viewedConnection setValue:@false forKeyPath:@"is_new"];
        
        NSString *urlAsString =kBaseURL;
        urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"user/%@/like/viewed", [connection objectForKey:@"uid"]]];
        
        
        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        
        NSString *FbToken = [session accessTokenData].accessToken;
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSDictionary *params = @{};
        [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"User shown as seen%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"User not shown as seen because of errror%@", error);
            //Run notification status again if first attempt is not successful.
            [self notificationStatus];
        }];

    }
} 
- (IBAction)close:(id)sender{
    [socialMediaWebView loadHTMLString:@"" baseURL:nil];
    [socialMediaWebView removeFromSuperview];
    closeButton.hidden = TRUE;
}


- (void)getImages{
    
    

    NSString *picURL =kBaseURL;
    picURL = [picURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/photo", [connection objectForKey:@"uid"]]];
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
    if ([[connection objectForKey:@"facebook_uid"]isKindOfClass:[NSNull class]]||
        [[[connection objectForKey:@"facebook_uid"]stringValue] isEqualToString:@"0"] ) {
        //Facebook not shared
        self.facebookAdded.enabled = FALSE;
        self.facebookAdded.hidden = TRUE;
        self.facebookViewProfileSmall.hidden = TRUE;
        self.facebookViewProfileSmall.enabled = FALSE;
        self.facebookButton.enabled = FALSE;
        self.facebookButton.hidden = TRUE;
        self.facebookLabel.hidden = false;
        self.facebookCircle.hidden = TRUE;
    }else{
        [self facebookCheck];
        
    }
    if ([[connection objectForKey:@"instagram_username"]isKindOfClass:[NSNull class]]) {
        //Instagram not shared
        self.instagramAdded.enabled = FALSE;
        self.instagramAdded.hidden = TRUE;
        self.instagramViewProfileSmall.hidden = TRUE;
        self.instagramViewProfileSmall.enabled = FALSE;
        self.instaButton.enabled = FALSE;
        self.instaButton.hidden = TRUE;
        self.instagramLabel.hidden = FALSE;
        self.instagramCircle.hidden = TRUE;
    }else{
        [self instagramCheck];
        
    }
    if ([[connection objectForKey:@"phone_number"]isKindOfClass:[NSNull class]]) {
        //Phone Number not shared

        self.phoneButton.enabled =FALSE;
        self.phoneButton.hidden = TRUE;
        self.phoneLabel.hidden = FALSE;
        self.phoneCircle.hidden = TRUE;
    }else{
        self.phoneButton.enabled =TRUE ;
        self.phoneButton.hidden = FALSE;
    }
    if ([[connection objectForKey:@"snapchat_username"]isKindOfClass:[NSNull class]]) {
        //Facebook not shared
        self.snapButton.enabled =FALSE;
        self.snapButton.hidden = TRUE;
        self.snapchatLabel.hidden = FALSE;
        self.snapchatCircle.hidden = TRUE;
    }else{
        self.snapButton.enabled =TRUE;
        self.snapButton.hidden = FALSE;
        
    }
    if ([[connection objectForKey:@"twitter_username"]isKindOfClass:[NSNull class]]) {
        //Twitter not shared
        self.twitterAdded.enabled = FALSE;
        self.twitterAdded.hidden = TRUE;
        self.twitterViewProfileSmall.hidden = TRUE;
        self.twitterViewProfileSmall.enabled = FALSE;
        self.twitterButton.enabled = FALSE;
        self.twitterButton.hidden = TRUE;
        self.twitterLabel.hidden = FALSE;
        self.twitterCircle.hidden = TRUE;
        
    }else{
        self.twitterLabel.hidden = TRUE;
        [self twitterCheck];
    }
}

- (void)facebookCheck{
    self.facebookCircle.hidden = FALSE;
    /* make the API call */
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/friends/%@/", [[user objectForKey:@"facebook_uid"]stringValue], [[connection objectForKey:@"facebook_uid"]stringValue]]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              NSArray *friendInfo = (NSArray *) [result objectForKey:@"data"];
                              NSLog(@"Facebook Friends Result: %@",result);
                              if ([friendInfo count]>0) {
                                  self.facebookAdded.hidden = FALSE;
                                  self.facebookAdded.enabled = TRUE;
                                  self.facebookViewProfileSmall.enabled = TRUE;
                                  self.facebookViewProfileSmall.hidden = FALSE;
                                  self.facebookLabel.hidden = TRUE;
                                  self.facebookButton.enabled = FALSE;
                                  self.facebookButton.hidden = TRUE;
                                  
        
                              }else{
                                  NSLog(@"showing up as false");
                                  self.facebookAdded.hidden = TRUE;
                                  self.facebookAdded.enabled = FALSE;
                                  self.facebookViewProfileSmall.enabled = FALSE;
                                  self.facebookViewProfileSmall.hidden = TRUE;
                                  self.facebookLabel.hidden = TRUE;
                                  self.facebookButton.enabled = TRUE;
                                  self.facebookButton.hidden = FALSE;
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
    self.twitterAdded.hidden = TRUE;
    self.twitterAdded.enabled = FALSE;
    self.twitterViewProfileSmall.enabled = FALSE;
    self.twitterViewProfileSmall.hidden = TRUE;
    self.twitterLabel.hidden = TRUE;
    self.twitterButton.enabled = TRUE;
    self.twitterButton.hidden = FALSE;

    }

- (void) instagramCheck{
    self.instagramCircle.hidden = FALSE;
    if ([[user objectForKey:@"instagram_token"] isKindOfClass:[NSNull class]]) {
        self.instagramAdded.hidden = TRUE;
        self.instagramAdded.enabled = FALSE;
        self.instagramViewProfileSmall.enabled = FALSE;
        self.instagramViewProfileSmall.hidden = TRUE;
        self.instagramLabel.hidden = TRUE;
        self.instaButton.enabled = TRUE;
        self.instaButton.hidden = FALSE;
        }else if ([[connection objectForKey:@"instagram_uid"]isKindOfClass:[NSNull class]]) {
            self.instagramAdded.hidden = TRUE;
            self.instagramAdded.enabled = FALSE;
            self.instagramViewProfileSmall.enabled = FALSE;
            self.instagramViewProfileSmall.hidden = TRUE;
            self.instagramLabel.hidden = TRUE;
            self.instaButton.enabled = TRUE;
            self.instaButton.hidden = FALSE;
        }else{
            NSString *instaUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship?access_token=%@", [connection objectForKey:@"instagram_uid"], [user objectForKey:@"instagram_token"]];
            NSLog(@"%@",instaUrl);
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager GET:instaUrl parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"resonse Object %@",responseObject);
                if ([[[responseObject objectForKey:@"data"]objectForKey:@"incoming_status"]isEqualToString:@"followed_by"]) {
                    self.instagramAdded.hidden = false;
                    self.instagramViewProfileSmall.enabled = TRUE;
                    self.instagramViewProfileSmall.hidden = FALSE;
                    self.instaButton.enabled = FALSE;
                    self.instaButton.hidden = TRUE;
                }else{
                    self.instagramAdded.hidden = TRUE;
                    self.instagramAdded.enabled = FALSE;
                    self.instagramViewProfileSmall.enabled = FALSE;
                    self.instagramViewProfileSmall.hidden = TRUE;
                    self.instagramLabel.hidden = TRUE;
                    self.instaButton.enabled = TRUE;
                    self.instaButton.hidden = FALSE;

                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Photo failed to load%@",error);
                self.instagramAdded.hidden = TRUE;
                self.instagramAdded.enabled = FALSE;
                self.instagramViewProfileSmall.enabled = FALSE;
                self.instagramViewProfileSmall.hidden = TRUE;
                self.instagramLabel.hidden = TRUE;
                self.instaButton.enabled = TRUE;
                self.instaButton.hidden = FALSE;
            }];

    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            NSLog(@"Message sent successfully");
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showSMS{
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[[NSString stringWithFormat:@"%@",[connection objectForKey:@"phone_number"]]];
   // NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!", file];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    //[messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==0) {
        
        if (buttonIndex == 0) {
            NSLog(@"button index 0 selected");
            NSString *snapchatURL = [NSString stringWithFormat:@"snapchat://?u=%@",[connection objectForKey:@"snapchat_username"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:snapchatURL]];
        } else if (buttonIndex == 1) {
            NSLog(@"button index 1 selected");
        }
    }
    if (actionSheet.tag ==1) {
        if (buttonIndex ==0) {
            NSLog(@"block User");
            NSString *urlAsString =kBaseURL;
            urlAsString = [urlAsString stringByAppendingString: @"user/"];
            urlAsString = [urlAsString stringByAppendingString:[connection objectForKey:@"uid"]];
            urlAsString =[urlAsString stringByAppendingString:@"/block"];
            FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
            NSString *FbToken = [session accessTokenData].accessToken;
            [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            NSDictionary *params = @{};
            [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"User reported: %@", responseObject);
            }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 NSLog(@"Error: %@", error);
             }];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PotentialMatchesViewController"]]animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            [self.sideMenuViewController presentRightMenuViewController];


                   }
        else if (buttonIndex ==1){
            NSLog(@"report user");
            NSString *urlAsString =kBaseURL;
            urlAsString = [urlAsString stringByAppendingString: @"user/"];
            urlAsString = [urlAsString stringByAppendingString:[connection objectForKey:@"uid"]];
            urlAsString =[urlAsString stringByAppendingString:@"/report"];
            FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
            NSString *FbToken = [session accessTokenData].accessToken;
            [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            NSDictionary *params = @{};
            [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                    NSLog(@"User reported: %@", responseObject);
            }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 NSLog(@"Error: %@", error);
             }];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PotentialMatchesViewController"]]animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            [self.sideMenuViewController presentRightMenuViewController];


        }
    }
}
-(void)addToViewCount:(NSString *)socialMediaType{
    NSString *urlAsString =kBaseURL;
    urlAsString = [urlAsString stringByAppendingString: @"user/"];
    urlAsString = [urlAsString stringByAppendingString:[connection objectForKey:@"uid"]];
    urlAsString =[urlAsString stringByAppendingString:@"/viewed"];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = @{@"type":socialMediaType};
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Added to view count: %@", responseObject);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingView setHidden:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [loadingView setHidden:NO];
    
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
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ConnectionVideoViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];}


- (IBAction)goToUserFacebook:(id)sender {

    NSLog(@"Facebook opened with url:%@",facebookURL);
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:facebookURL];
    [socialMediaWebView loadRequest:requestObj];
    [self.view addSubview:socialMediaWebView];
    closeButton.hidden =false;
    [self.view bringSubviewToFront:closeButton];
    [self addToViewCount:@"facebook"];

}

- (IBAction)goToUserTwitter:(id)sender {
    NSString *fullURL = [NSString stringWithFormat:@"https://twitter.com/%@",[connection objectForKey:@"twitter_username"] ];
    NSLog(@"Twitter url: %@",fullURL);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [socialMediaWebView loadRequest:requestObj];
    [self.view addSubview:socialMediaWebView];
    closeButton.hidden =false;
    [self.view bringSubviewToFront:closeButton];
    [self addToViewCount:@"twitter"];



}

- (IBAction)goToUserInstagram:(id)sender {
    NSString *fullURL = [NSString stringWithFormat:@"http://instagram.com/%@",[connection objectForKey:@"instagram_username"] ];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [socialMediaWebView loadRequest:requestObj];
    [self.view addSubview:socialMediaWebView];
    closeButton.hidden =false;
    [self.view bringSubviewToFront:closeButton];
    [self addToViewCount:@"instagram"];

}
- (IBAction)goToSMS:(id)sender {
    [self showSMS];
    [self addToViewCount:@"phone"];

}

- (IBAction)goToSnap:(id)sender {
    [self addToViewCount:@"snapchat"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@'s Snapchat username copied!!\n\n\t-Open Snapchat\n\t   -Click Add Friends\n\t -Paste Username", [connection objectForKey:@"firstName"]] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open Snapchat", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
        [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@",[connection objectForKey:@"snapchat_username"]];

}


- (IBAction)reportAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:[NSString stringWithFormat:@"Block %@",[connection objectForKey:@"firstName"]] otherButtonTitles:[NSString stringWithFormat: @"Report %@",[connection objectForKey:@"firstName"]], nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];

}
@end
