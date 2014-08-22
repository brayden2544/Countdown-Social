//
//  OwnProfileViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 8/15/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "OwnProfileViewController.h"
#import "User.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "RESideMenu.h"

@interface OwnProfileViewController ()
@property NSDictionary *user;

@end

@implementation OwnProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = TRUE;
    User *obj = [User getInstance];
    _user = obj.user;
    
    //Name Label
    self.nameLabel.text = [_user objectForKey:@"firstName"];
    
    [self getImage];
    [self buttonCheck];
    
}
-(void)buttonCheck{
    if ([_user objectForKey:@"instagram_username"]!=[NSNull null]) {
        //show insta button
        self.instagram.hidden = false;
    }
    else{
         self.instagram.hidden = TRUE;
    }
    if ([_user objectForKey:@"snapchat_username"]!=[NSNull null]) {
        //show snap button
         self.snapchat.hidden = false;
    } else{
         self.snapchat.hidden = TRUE;
    }
    if ([_user objectForKey:@"twitter_username"] !=[NSNull null]) {
        //show twitter button
         self.twitter.hidden = false;
    } else{
         self.twitter.hidden = TRUE;
    }
    if ([_user objectForKey:@"phone_number"]!=[NSNull null]) {
        //show phone button
         self.phone.hidden = false;
    } else{
         self.phone.hidden = TRUE;
    }
    if ([_user objectForKey:@"facebook_uid"]==[NSNull null]||
        [[[_user objectForKey:@"facebook_uid"]stringValue] isEqualToString:@"0"]) {
        //show insta button
         self.facebook.hidden= true;
    } else{
         self.facebook.hidden = false;
    }

    
}
- (void)getImage{
    NSString *picURL =kBaseURL;
    picURL = [picURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/photo", [_user objectForKey:@"uid"]]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:picURL parameters:@{@"height":@300,
                                     @"width": @300} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         self.profilePic.image = responseObject;
                                         self.backgroundProfilePic.image = responseObject;
                                         self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height/2;
                                         self.profilePic.layer.masksToBounds =YES;
                                         NSLog(@"resonse Object %@",responseObject);
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Photo failed to load%@",error);
                                     }];
    
}



- (IBAction)backAction:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

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

- (IBAction)viewVideoAction:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)changeVideoAction:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PBJViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
@end
