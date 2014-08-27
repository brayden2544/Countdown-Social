//
//  InstagramViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/18/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "InstagramViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "RESideMenu/RESideMenu.h"
#import "Constants.h"

@interface InstagramViewController ()
@property(nonatomic, strong) UIWebView *instagramWebView;

@end

@implementation InstagramViewController

@synthesize instagram_token;
@synthesize instagram_username;
@synthesize instagram_code;
@synthesize instagram_uid;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)webView:(UIWebView *)instagramWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString* urlString = [[request URL] absoluteString];
    NSURL *Url = [request URL];
    NSArray *UrlParts = [Url pathComponents];
    NSLog(@"Instagram Info = %@",Url);
    // do any of the following here
    if ([[UrlParts objectAtIndex:(1)] isEqualToString:@"MAMP"]) {
        //if ([urlString hasPrefix: @"localhost"]) {
        NSRange tokenParam = [urlString rangeOfString: @"code="];
        if (tokenParam.location != NSNotFound) {
           instagram_code = [urlString substringFromIndex: NSMaxRange(tokenParam)];
            
            // If there are more args, don't include them in the token:
            NSRange endRange = [instagram_code rangeOfString: @"&"];
            if (endRange.location != NSNotFound)
                instagram_code = [instagram_code substringToIndex: endRange.location];
            
            NSLog(@"access token %@", instagram_token);
            if ([instagram_code length] > 0 ) {
                NSString* redirectUrl = [[NSString alloc] initWithFormat:@"https://instagram.com/"];
                NSURL *url = [NSURL URLWithString:redirectUrl];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                self.instagramWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,57,self.view.frame.size.width,self.view.frame.size.height - 57)];

                [self.instagramWebView loadRequest:request];
                [self.view addSubview:self.instagramWebView];
                [self RequestInstagramInfo];
            }
            // use delegate if you want
            //[self.delegate instagramLoginSucceededWithToken: token];
            
            
        }
        else {
            // Handle the access rejected case here.
            NSLog(@"rejected case, user denied request");
        }
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    User *obj = [User getInstance];
    NSDictionary *user = obj.user;
    
    // Do any additional setup after loading the view.
    //if ([[user objectForKey:@"instagram_token"]isKindOfClass:[NSNull class]]){
    UIWebView* instagramWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,57,self.view.frame.size.width,self.view.frame.size.height - 57)];
    self.instagramWebView.scalesPageToFit = YES;
    
    NSString *stringURL = @"http://www.instagram.com/oauth/authorize/?client_id=932befca29884b378bfa33415fe71da6&redirect_uri=http://localhost:8888/MAMP/&response_type=code";
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [instagramWebView loadRequest:request];
    instagramWebView.delegate = self;
    [self.view addSubview:instagramWebView];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)instagramUsernameUpload
{
    NSString *urlAsString = kBaseURL;
    urlAsString = [urlAsString stringByAppendingString:@"user/"];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSDictionary *params=@{@"instagram_username":instagram_username,
                           @"instagram_token": instagram_token,
                           @"instagram_uid":instagram_uid};    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        User *Userobj =  [User getInstance];
        Userobj.user = responseObject;
                               
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Instagram Linked!!"
                                                                               message:@"Your profile is linked with Instagram!"
                                                                              delegate:self
                                                                     cancelButtonTitle:nil
                                                                     otherButtonTitles:@"Okay", nil];
                               [alert show];
                               

        
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];

    
    
}

-(void)RequestInstagramInfo
{
    NSString *client_id = @"932befca29884b378bfa33415fe71da6";
    NSString *client_secret = @"04b3374e51ca416e89d108c177de4e5c";
    NSString *grant_type = @"authorization_code";
    NSString *redirect_uri  =@"http://localhost:8888/MAMP/";
    
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSDictionary *params=@{@"client_id":client_id,
                           @"client_secret": client_secret,
                           @"grant_type": grant_type,
                           @"redirect_uri": redirect_uri,
                           @"code":instagram_code};
    [manager POST:@"https://api.instagram.com/oauth/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               NSLog(@"JSON: %@", responseObject);
  
        
        instagram_token = [responseObject objectForKey:@"access_token"];
        instagram_username = [[responseObject objectForKey:@"user"] objectForKey:@"username"];
        instagram_uid = [[responseObject objectForKey:@"user"]objectForKey:@"id"];
        
        //Upload new token and username to instagram.
        [self instagramUsernameUpload];

        
        
                           }
                                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                                                     {
                                                                         NSLog(@"Error: %@", error);
                                                                     }];
    
}


- (IBAction)returnToSocial:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SocialAccountsViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}
@end
