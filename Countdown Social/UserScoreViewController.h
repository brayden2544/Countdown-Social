//
//  UserScoreViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/16/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface UserScoreViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    
}
- (IBAction)presentMenu:(id)sender;
-(IBAction)ButtonPressed:(id)sender;


- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;

@end
