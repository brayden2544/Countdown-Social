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
    //_block NSString *twitterUsername = nil;
    //Request Twitter Information
    
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
[store requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
    
        if(granted ==YES) {
            NSArray *arrayOfAccounts = [store
                                        accountsWithAccountType:twitterType];
            
            //NSString *twitterUsername =[arrayOfAccounts objectAtIndex:0];
            NSLog(@"Granted");
            
         

            // Access has been granted, now we can access the accounts
            NSLog(@"%@",arrayOfAccounts);
            
        }
        // Handle any error state here as you wish
    }];
    self.twitterWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,60,320,506)];
    self.twitterWebView.scalesPageToFit = YES;
    [self.view addSubview:self.twitterWebView];
    
    NSString *stringURL = @"http://www.twitter.com/";
    //NSString *stringURl = [stringURL stringByAppendingString:twitterUsername];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.twitterWebView loadRequest:request];
    
    //Post twitter handle if we don't already have it.
    NSDictionary *user = nil;
    
    User *Userobj =  [User getInstance];
    user = Userobj.user;

#warning TODO: Make this if/then statement work correctly.
    //if ((NSNull *)[user objectForKey: @"twitter_username"] == [NSNull null]){
[self twitterUsernameUpload];
        NSLog(@"Twitter username blank");
    //}
}

-(void)twitterUsernameUpload
{
    NSString *urlAsString =@"http://api-dev.countdownsocial.com/user";
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url];
    NSString *twitterUsername = @"Dude";
    [urlRequest setHTTPBody:[[NSString stringWithFormat:@"twitter_username=%@",twitterUsername] dataUsingEncoding:NSUTF8StringEncoding]];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    //Get singleton from LoginLoadView Controller
    
    
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
                 
                 NSLog(@"Twitter Username and User Singleton Updated");
                 
                 
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
