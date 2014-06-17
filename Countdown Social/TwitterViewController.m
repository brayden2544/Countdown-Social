//
//  TwitterViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/12/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "TwitterViewController.h"

@interface TwitterViewController ()
@property(nonatomic, strong) UIWebView *twitterWebView;
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
    __block NSString *twitterUsername = nil;
    //Request Twitter Information
    
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSDictionary *twitterDictionary = @{};
[store requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
    
        if(granted ==YES) {
            NSArray *arrayOfAccounts = [store
                                        accountsWithAccountType:twitterType];
            
            twitterUsername =[arrayOfAccounts objectAtIndex:0];
            NSLog(@"Granted");
            
         

            // Access has been granted, now we can access the accounts
                   }
        // Handle any error state here as you wish
    }];
    self.twitterWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,60,320,506)];
    self.twitterWebView.scalesPageToFit = YES;
    [self.view addSubview:self.twitterWebView];
    
    NSString *stringURL = @"http://www.twitter.com/";
    NSString *stringURl = [stringURL stringByAppendingString:twitterUsername];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.twitterWebView loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
