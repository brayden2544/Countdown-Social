//
//  UserScoreViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/16/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "UserScoreViewController.h"

#import <StoreKit/StoreKit.h>
#import "RESideMenu.h"
#import "User.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Constants.h"


@interface UserScoreViewController ()

@end

NSString* buy_restore;
@implementation UserScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    User *obj = [User getInstance];
    _user = obj.user;
    if ([[_user objectForKey:@"in_app_purchase"]boolValue]==TRUE) {
        self.unpurchasedView.hidden = TRUE;
        self.purchasedView.hidden = false;
        [self getScore];
    }else{
        self.unpurchasedView.hidden = false;
        self.purchasedView.hidden = TRUE;
    }
    
}

-(void)getScore{
    NSString *scoreURL = kBaseURL;
    scoreURL = [scoreURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/stats", [_user objectForKey:@"uid"]]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    [manager POST:scoreURL parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"score object %@",responseObject);
        [self populateScore:responseObject];
            
        }
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Photo failed to load%@",error);
    }];

}
-(void)populateScore:(NSDictionary *)score{
    if ([score objectForKey:@"video_details"]!=[NSNull null]){
    double video_view_count;
    if ([[score objectForKey:@"video_details"]objectForKey:@"likeCount"]!=[NSNull null]){
        video_view_count = [[[score objectForKey:@"video_details" ]objectForKey:@"likeCount"]doubleValue];
    }else{
        video_view_count =0;
    }

    if ([score objectForKey:@"facebook_view_count"]!= [NSNull null]) {
        self.facebookClicksLabel.text = [NSString stringWithFormat:@"%@",[score objectForKey:@"facebook_view_count"]];
    }else{
        self.facebookClicksLabel.text = @"0";

    }
    
    if ([score objectForKey:@"facebook_share_count"] != [NSNull null]) {
        double facebookShareCount =[[score objectForKey:@"facebook_share_count"]doubleValue];
        self.facebookRequestLabel.text = [NSString stringWithFormat:@"%.0f%% of people requested your FB.",facebookShareCount/video_view_count *100];

    }else{
        self.facebookRequestLabel.text = @"0% of people requested your FB";
    }
    
    if ([score objectForKey:@"instagram_view_count"] != [NSNull null]) {
        self.instagramClicksLabel.text = [NSString stringWithFormat:@"%@",[score objectForKey:@"instagram_view_count"]];
    }else{
        self.instagramClicksLabel.text = @"0";

    }
    
    if ([score objectForKey:@"instagram_share_count"] != [NSNull null]) {
        double instagramShareCount =[[score objectForKey:@"instagram_share_count"]doubleValue];
        self.instagramRequestLabel.text = [NSString stringWithFormat:@"%.0f%% of people requested your Insta.",instagramShareCount/video_view_count *100];
    }else{
        self.instagramRequestLabel.text = @"0% of people requested your Insta";
    }
    
    if ([score objectForKey:@"phone_view_count"] != [NSNull null]) {
        self.phoneClicksLabel.text = [NSString stringWithFormat:@"%@",[score objectForKey:@"phone_view_count"]];
    }else{
        self.phoneClicksLabel.text = @"0";
    }
    
    if ([score objectForKey:@"phone_share_count"] != [NSNull null]) {
        double phoneShareCount =[[score objectForKey:@"phone_share_count"]doubleValue];
        self.phoneRequestLabel.text = [NSString stringWithFormat:@"%.0f%% of people requested your #.",phoneShareCount/video_view_count*100];
    }else{
        self.phoneRequestLabel.text = @"0% of people wanted your #";
    }
    
    if ([score objectForKey:@"snapchat_view_count"] != [NSNull null]) {
        self.snapchatClicksLabel.text= [NSString stringWithFormat:@"%@",[score objectForKey:@"snapchat_view_count"]];
    }else{
        self.snapchatClicksLabel.text= @"0";
    }
    if ([score objectForKey:@"snapchat_share_count"] != [NSNull null]) {
        double snapchatShareCount =[[score objectForKey:@"snapchat_share_count"]doubleValue];
        self.snapchatRequestLabel.text = [NSString stringWithFormat:@"%.0f%% of people requested your Snap.",snapchatShareCount/video_view_count *100];
    }else{
        self.snapchatRequestLabel.text = @"0% of people requested your Snap.";
    }
    if ([score objectForKey:@"twitter_view_count"] != [NSNull null]) {
        self.twitterClicksLabel.text = [NSString stringWithFormat:@"%@",[score objectForKey:@"twitter_view_count"]];
    }else{
        self.twitterClicksLabel.text = @"0";
    }
    if ([score objectForKey:@"twitter_share_count"] != [NSNull null]) {
        double twitterShareCount =[[score objectForKey:@"twitter_share_count"]doubleValue];
        self.twitterRequestLabel.text = [NSString stringWithFormat:@"%.0f%% of people requested your Twitter.",twitterShareCount/video_view_count*100];
    }else{
        self.twitterRequestLabel.text = @"0% of people requested your Twitter";
    }
    
    
    //self.averageScoreLabel.text = [score objectForKey:<#(id)#>]
    if ([score objectForKey:@"video_details"] != [NSNull null]) {
        double likeCount = [[[score objectForKey:@"video_details"] objectForKey:@"likeCount"]doubleValue];
        double passCount = [[[score objectForKey:@"video_details"] objectForKey:@"passCount"]doubleValue];
        double videoRating = (likeCount /(likeCount + passCount)*5)+5;
        
        if ([[NSString stringWithFormat:@"%f",videoRating] isEqualToString:@"nan"]) {
            self.currentVideoScoreLabel.text =[NSString stringWithFormat:@"5"];

        }else{
            if (videoRating == 10) {
                self.currentVideoScoreLabel.text =[NSString stringWithFormat:@"10"];

            }else{
            self.currentVideoScoreLabel.text =[NSString stringWithFormat:@"%.1f",videoRating];
            }
        }
    }
    if ([score objectForKey:@"passCount"] != [NSNull null] && [score objectForKey:@"likeCount"] !=[NSNull null]) {
        double totalLikeCount = [[score  objectForKey:@"likeCount"]doubleValue];
        double totalPassCount = [[score  objectForKey:@"passCount"]doubleValue];
        double totalvideoRating = (totalLikeCount /(totalLikeCount + totalPassCount)*5)+5;
        
        if ([[NSString stringWithFormat:@"%f",totalvideoRating] isEqualToString:@"nan"]) {
            self.averageScoreLabel.text =[NSString stringWithFormat:@"5"];
            
        }else{
            if (totalvideoRating == 10) {
                self.averageScoreLabel.text =[NSString stringWithFormat:@"10"];
                
            }else{
                self.averageScoreLabel.text =[NSString stringWithFormat:@"%.1f",totalvideoRating];
            }
        }
    }
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSArray *myProduct = response.products;
    NSLog(@"%@",[[myProduct objectAtIndex:0] productIdentifier]);
    
    //Since only one product, we do not need to choose from the array. Proceed directly to payment.
    if ([buy_restore isEqualToString:@"buy"]){
    SKPayment *newPayment = [SKPayment paymentWithProduct:[myProduct objectAtIndex:0]];
    [[SKPaymentQueue defaultQueue] addPayment:newPayment];
    }
    else{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Completed");
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    NSString *urlAsString =kBaseURL;
    urlAsString = [urlAsString stringByAppendingString: @"user/"];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc]init];
    manager.operationQueue = backgroundQueue;
    NSDictionary *params = @{@"in_app_purchase":@"true"};
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _user = responseObject;
        User *obj = [User getInstance];
        obj.user = _user;
        NSLog(@"show stats view");
        self.unpurchasedView.hidden = TRUE;
        self.purchasedView.hidden = false;
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Unsuccessful!!"
                                                         message:@"Please try again!"
                                                        delegate:self
                                               cancelButtonTitle:@"Okay"
                                               otherButtonTitles:nil];
         [alert show];
         
     }];

    
    // You should make the update to your app based on what was purchased and inform user.
    // [self provideContent: transaction.payment.productIdentifier];
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Restored");
    // You can create a method to record the transaction.
    NSString *urlAsString =kBaseURL;
    urlAsString = [urlAsString stringByAppendingString: @"user/"];
    urlAsString = [urlAsString stringByAppendingString:[[_user objectForKey:@"uid"] stringValue]];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc]init];
    manager.operationQueue = backgroundQueue;
    NSDictionary *params = @{@"in_app_purchase":@"true"};
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _user = responseObject;
        User *obj = [User getInstance];
        obj.user = _user;
        NSLog(@"show stats view");
        self.unpurchasedView.hidden = TRUE;
        self.purchasedView.hidden = false;

    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Unsuccessful!!"
                                                         message:@"Please try again!"
                                                        delegate:self
                                               cancelButtonTitle:@"Okay"
                                               otherButtonTitles:nil];
         [alert show];
         
     }];
    
    // You should make the update to your app based on what was purchased and inform user.
    // [self provideContent: transaction.payment.productIdentifier];
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    //[activityIndicator stopAnimating];
    
        // Display an error here.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Unsuccessful"
                                                        message:@"Your Restore failed. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    //[activityIndicator stopAnimating];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Display an error here.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                                        message:@"Your purchase failed. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (IBAction)presentMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];

}

- (IBAction)ButtonPressed:(id)sender{
    buy_restore = @"buy";
    SKProductsRequest *request= [[SKProductsRequest alloc]
                                 initWithProductIdentifiers: [NSSet setWithObject: @"userScoreInAppPurchase"]];
    request.delegate = self;
    [request start];
    
}

- (IBAction)restore:(id)sender {
    buy_restore = @"restore";
    SKProductsRequest *request= [[SKProductsRequest alloc]initWithProductIdentifiers: [NSSet setWithObject: @"userScoreInAppPurchase"]];
    request.delegate = self;
    [request start];
}
@end
