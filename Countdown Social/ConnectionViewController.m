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


@interface ConnectionViewController ()
@property (nonatomic, strong) NSDictionary *currentMatch;
@property (nonatomic , strong) NSDictionary *user;

@end

@implementation ConnectionViewController

@synthesize currentMatch;
@synthesize user;

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
    Connection *obj = [Connection getInstance];
    currentMatch = obj.connection;
    User *userObj = [User getInstance];
    user = userObj.user;
    
    [self showConnection];
}

-(void)showConnection{
    //Set Connection Message
    self.connectionLabel.text = [NSString stringWithFormat:@"It's your lucky day, you've connected with %@" ,[currentMatch objectForKey:@"firstName"]];
    
    //Check sex to display message
    if ([[currentMatch objectForKey:@"gender"] isEqualToString:@"M"]) {
        self.checkOutLabel.text = @"Check him out!";
    }
    else{
        self.checkOutLabel.text = @"Check her out!";
    }
    
    //Set Match Image
    self.matchProfilePic.layer.cornerRadius = self.matchProfilePic.frame.size.height/2;
    self.matchProfilePic.layer.masksToBounds = YES;
    NSString *picURL = [NSString stringWithFormat:@"http://api-dev.countdownsocial.com/user/%@/photo", [currentMatch objectForKey:@"uid"]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:picURL parameters:@{@"height":@200,
                                     @"width": @200} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         self.matchProfilePic.image = responseObject;
                                         NSLog(@"resonse Object %@",responseObject);
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Photo failed to load%@",error);
                                     }];
    
    //Set User Image
    //Set Match Image
    self.userProfilePic.layer.cornerRadius = self.userProfilePic.frame.size.height/2;
    self.userProfilePic.layer.masksToBounds = YES;
    picURL = [NSString stringWithFormat:@"http://api-dev.countdownsocial.com/user/%@/photo", [user objectForKey:@"uid"]];
    [manager GET:picURL parameters:@{@"height":@200,
                                     @"width": @200} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         self.userProfilePic.image = responseObject;
                                         NSLog(@"resonse Object %@",responseObject);
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Photo failed to load%@",error);
                                     }];
    
    
    //set size limitations of current potential match

    
    
    //button matches
    if ([currentMatch objectForKey:@"instagram_username"]) {
        //show insta button
        self.instagrambutton.enabled = TRUE;
        self.instagrambutton.hidden = FALSE;
    }
    if ([currentMatch objectForKey:@"snapchat_username"]) {
        //show snap button
        self.snapchatButton.enabled = TRUE;
        self.snapchatButton.hidden= FALSE;
    }
    if ([currentMatch objectForKey:@"twitter_username"]) {
        //show twitter button
        self.twitterButton.enabled = TRUE;
        self.twitterButton.hidden=FALSE;
    }
    if ([currentMatch objectForKey:@"phone_number"]) {
        //show phone button
        self.phoneButton.enabled = TRUE;
        self.phoneButton.hidden=FALSE;
    }
    if ([currentMatch objectForKey:@"facebook_uid"]) {
        //show insta button
        self.facebookButton.enabled = TRUE;
        self.facebookButton.hidden=FALSE;
    }
}
//Message Icon always shows

- (IBAction)facebookAction:(id)sender {
}

- (IBAction)phoneAction:(id)sender {
}

- (IBAction)snapchatAction:(id)sender {
}

- (IBAction)twitterAction:(id)sender {
}

- (IBAction)instagramAction:(id)sender {
}

- (IBAction)messageAction:(id)sender {
    JSQMessagesViewController *messages = [[JSQMessagesViewController alloc]init];
    [self presentViewController:messages animated:YES completion:nil];
}

- (IBAction)keepPlayingAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"View controller dismissed");
    }];
    
}
@end