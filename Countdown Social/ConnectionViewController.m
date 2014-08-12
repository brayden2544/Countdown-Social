//
//  ConnectionViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/28/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ConnectionViewController.h"
#import "JSQMessagesViewController.h"
#import "Connection.h"
#import "AppDelegate.h"
#import "User.h"
#import "RESideMenu.h"
#import "Constants.h"

@interface ConnectionViewController ()
@property (nonatomic, strong) NSDictionary *currentMatch;
@property (nonatomic , strong) NSDictionary *user;

@end

@implementation ConnectionViewController

@synthesize currentMatch;
@synthesize user;



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    Connection *obj = [Connection getInstance];
    currentMatch = [obj.connection objectForKey:@"liked_user"];
    User *userObj = [User getInstance];
    user = userObj.user;
    
    [self showConnection];
}

-(void)showConnection{
    //Set Connection Message
    self.connectionLabel.text = [NSString stringWithFormat:@"New Connection with %@" ,[currentMatch objectForKey:@"firstName"]];
    [self.viewProfileButton setTitle:[NSString stringWithFormat:@"%@'s Profile",[currentMatch objectForKeyedSubscript:@"firstName"]] forState:UIControlStateNormal];
    //Check sex to display message
    if ([[currentMatch objectForKey:@"gender"] isEqualToString:@"M"]) {
        self.checkOutLabel.text = @"See what he's up to!";
    }
    else{
        self.checkOutLabel.text = @"See what she's up to!";
    }
    
    //Set Match Image
    self.matchProfilePic.layer.cornerRadius = self.matchProfilePic.frame.size.height/2;
    self.matchProfilePic.layer.masksToBounds = YES;
    NSString *picURL =kBaseURL;
    picURL = [picURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/photo", [currentMatch objectForKey:@"uid"]]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:picURL parameters:@{@"height":@300,
                                     @"width": @300} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         self.matchProfilePic.image = responseObject;
                                         NSLog(@"resonse Object %@",responseObject);
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Photo failed to load%@",error);
                                     }];
    
        
}

- (IBAction)keepPlayingAction:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PotentialMatchesViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (IBAction)viewProfileAction:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
@end
