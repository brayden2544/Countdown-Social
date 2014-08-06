//
//  UserScoreViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/16/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "Canvas.h"

@interface UserScoreViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    
}
- (IBAction)presentMenu:(id)sender;
-(IBAction)ButtonPressed:(id)sender;

@property (nonatomic,strong) NSDictionary *user;

//Click Images
@property (strong, nonatomic) IBOutlet CSAnimationView *facebookClicks;
@property (strong, nonatomic) IBOutlet CSAnimationView *phoneClicks;
@property (strong, nonatomic) IBOutlet CSAnimationView *snapchatClicks;
@property (strong, nonatomic) IBOutlet CSAnimationView *twitterClicks;
@property (strong, nonatomic) IBOutlet CSAnimationView *instagramClicks;

//Click Labels
@property (strong, nonatomic) IBOutlet UILabel *facebookClicksLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneClicksLabel;
@property (strong, nonatomic) IBOutlet UILabel *instagramClicksLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterClicksLabel;
@property (strong, nonatomic) IBOutlet UILabel *snapchatClicksLabel;


//Scores
@property (strong, nonatomic) IBOutlet CSAnimationView *averageScore;
@property (strong, nonatomic) IBOutlet CSAnimationView *currentVideoScore;

//Score Labels
@property (strong, nonatomic) IBOutlet UILabel *averageScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentVideoScoreLabel;

//Request Percentages
@property (strong, nonatomic) IBOutlet CSAnimationView *phoneRequests;
@property (strong, nonatomic) IBOutlet CSAnimationView *facebookRequests;
@property (strong, nonatomic) IBOutlet CSAnimationView *snapchatRequests;
@property (strong, nonatomic) IBOutlet CSAnimationView *instagramRequests;
@property (strong, nonatomic) IBOutlet CSAnimationView *twitterRequests;

//Request Labels
@property (strong, nonatomic) IBOutlet UILabel *isntagramRequestLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterRequestLabel;
@property (strong, nonatomic) IBOutlet UILabel *snapchatRequestLabel;
@property (strong, nonatomic) IBOutlet UILabel *facebookRequestLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneRequestLabel;


- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;

@end
