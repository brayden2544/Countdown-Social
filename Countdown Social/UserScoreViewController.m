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
    }else{
        self.unpurchasedView.hidden = false;
        self.purchasedView.hidden = TRUE;
    }
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSArray *myProduct = response.products;
    NSLog(@"%@",[[myProduct objectAtIndex:0] productIdentifier]);
    
    //Since only one product, we do not need to choose from the array. Proceed directly to payment.
    
    SKPayment *newPayment = [SKPayment paymentWithProduct:[myProduct objectAtIndex:0]];
    [[SKPaymentQueue defaultQueue] addPayment:newPayment];
    
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
    SKProductsRequest *request= [[SKProductsRequest alloc]
                                 initWithProductIdentifiers: [NSSet setWithObject: @"userScoreInAppPurchase"]];
    request.delegate = self;
    [request start];
    
}
@end
