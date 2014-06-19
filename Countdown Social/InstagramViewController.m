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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.instagramWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,60,320,506)];
    self.instagramWebView.scalesPageToFit = YES;
    [self.view addSubview:self.instagramWebView];
    
    NSString *stringURL = @"http://www.instagram.com/";
    //NSString *stringURl = [stringURL stringByAppendingString:twitterUsername];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.instagramWebView loadRequest:request];
    
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
