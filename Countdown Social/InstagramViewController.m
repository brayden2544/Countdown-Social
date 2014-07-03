//
//  InstagramViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/18/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "InstagramViewController.h"

@interface InstagramViewController ()
@property(nonatomic, strong) UIWebView *instagramWebView;

@end

@implementation InstagramViewController

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
    // do any of the following here
    if ([[UrlParts objectAtIndex:(1)] isEqualToString:@"MAMP"]) {
        //if ([urlString hasPrefix: @"localhost"]) {
        NSRange tokenParam = [urlString rangeOfString: @"access_token="];
        if (tokenParam.location != NSNotFound) {
            NSString* token = [urlString substringFromIndex: NSMaxRange(tokenParam)];
            
            // If there are more args, don't include them in the token:
            NSRange endRange = [token rangeOfString: @"&"];
            if (endRange.location != NSNotFound)
                token = [token substringToIndex: endRange.location];
            
            NSLog(@"access token %@", token);
            if ([token length] > 0 ) {
                // display the photos here
               // instagramTableViewController *iController = [[instagramPhotosTableViewController alloc] initWithStyle:UITableViewStylePlain];
                NSString* redirectUrl = [[NSString alloc] initWithFormat:@"https://instagram.com/lpaulich"];
                NSURL *url = [NSURL URLWithString:redirectUrl];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                self.instagramWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,60,320,506)];

                [self.instagramWebView loadRequest:request];
                [self.view addSubview:self.instagramWebView];
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
    // Do any additional setup after loading the view.
    UIWebView* instagramWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,60,320,506)];
    self.instagramWebView.scalesPageToFit = YES;
    
    NSString *stringURL = @"http://www.instagram.com/oauth/authorize/?client_id=932befca29884b378bfa33415fe71da6&redirect_uri=http://localhost:8888/MAMP/&response_type=token";
    //NSString *stringURl = [stringURL stringByAppendingString:twitterUsername];
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
- (IBAction)returnToPotentialMatches:(id)sender {
    NSLog(@"present matching view controller here");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
    [self presentViewController:menuViewController animated:YES completion:nil];
}

@end
