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

@interface InstagramViewController ()
@property(nonatomic, strong) UIWebView *instagramWebView;

@end

@implementation InstagramViewController

@synthesize instagram_token;
@synthesize instagram_username;
@synthesize instagram_code;

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
                self.instagramWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,65,320,506)];

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
    UIWebView* instagramWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,65,320,506)];
    self.instagramWebView.scalesPageToFit = YES;
    
    NSString *stringURL = @"http://www.instagram.com/oauth/authorize/?client_id=932befca29884b378bfa33415fe71da6&redirect_uri=http://localhost:8888/MAMP/&response_type=code";
    //NSString *stringURl = [stringURL stringByAppendingString:twitterUsername];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [instagramWebView loadRequest:request];
    instagramWebView.delegate = self;
    [self.view addSubview:instagramWebView];
    //}
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnToPotentialMatches:(id)sender {
    NSLog(@"present matching view controller here");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
    [self presentViewController:menuViewController animated:YES completion:nil];
}

-(void)instagramUsernameUpload
{
    NSString *urlAsString =@"http://api-dev.countdownsocial.com/user";
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPBody:[[NSString stringWithFormat:@"instagram_username=%@&instagram_token=%@",instagram_username, instagram_token] dataUsingEncoding:NSUTF8StringEncoding]];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    
    NSString *FbToken = [session accessTokenData].accessToken;
    
    // NSLog(@"Token is %@", FbToken);
    
    [urlRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSOperationQueue *queque = [[NSOperationQueue alloc] init];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        
        
        [NSURLConnection
         sendAsynchronousRequest:urlRequest
         queue:queque
         completionHandler:^(NSURLResponse *response,
                             NSData *data,
                             NSError *error){
             if ([data length] >0 && error == nil){
                 NSString *html =
                 [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
                 NSLog(html);
                 
                 id UserJson = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:NSJSONReadingAllowFragments
                                error:&error];
                 //  user = UserJson;
                 User *Userobj =  [User getInstance];
                 Userobj.user= UserJson;
                 
                 NSLog(@"Instagram Username, Token and User Singleton Updated");
                 
                 
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"POST Nothing was downloaded.");
             }
             else if (error !=nil){
                 NSLog(@"Error happened = %@", error);
                 NSLog(@"POST BROKEN");
#warning TODO: Create alert and restart app in case of bad server connection.
             }
         }];
    });
    
}

-(void)RequestInstagramInfo
{
    NSString *urlAsString =@"https://api.instagram.com/oauth/access_token";
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPBody:[[NSString stringWithFormat:@"client_id=932befca29884b378bfa33415fe71da6&client_secret=04b3374e51ca416e89d108c177de4e5c&grant_type=authorization_code&redirect_uri=http://localhost:8888/MAMP/&code=%@", instagram_code] dataUsingEncoding:NSUTF8StringEncoding]];

    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSOperationQueue *queque = [[NSOperationQueue alloc] init];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        
        
        [NSURLConnection
         sendAsynchronousRequest:urlRequest
         queue:queque
         completionHandler:^(NSURLResponse *response,
                             NSData *data,
                             NSError *error){
             if ([data length] >0 && error == nil){
        
                 id UserJson = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:NSJSONReadingAllowFragments
                                error:&error];
                 NSDictionary *instagram = [UserJson objectForKey:@"user"];
              
                 
                 NSLog(@"instagram info retrieved %@",instagram);
                 
                 //Set values for token and username based on info received from Instagram
                 instagram_token = [UserJson objectForKey:@"access_token"];
                 instagram_username = [instagram objectForKey:@"username"];
                 
                 //Upload new token and username to instagram.
                 [self instagramUsernameUpload];
                 
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"POST Nothing was downloaded.");
             }
             else if (error !=nil){
                 NSLog(@"Error happened = %@", error);
                 NSLog(@"POST BROKEN");
#warning TODO: Create alert and restart app in case of bad server connection.
             }
         }];
    });
    
}


- (IBAction)returnToSocial:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SocialAccountsViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}
@end
