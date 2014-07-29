//
//  RightMenuViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/25/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "RightMenuViewController.h"
#import "ConnectionsList.h"
#import "ConnectionsCellTableViewCell.h"
#import "AppDelegate.h"
#import "Connection.h"

@interface RightMenuViewController ()

@end

@implementation RightMenuViewController
@synthesize connections;
@synthesize connection;

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
    ConnectionsList *obj = [ConnectionsList getInstance];
    connections = obj.connections;
//    self.ConnectionsTableView.dataSource = self;
//    self.ConnectionsTableView.delegate = self;
    // Do any additional setup after loading the view.
    //[self.ConnectionsTableView registerClass:[ConnectionsCellTableViewCell class] forCellReuseIdentifier:@"connectionCell"];
    self.ConnectionsTableView.layer.cornerRadius = 5;
    self.ConnectionsTableView.layer.masksToBounds = YES;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell should be populating");
    static NSString *CellIdentifier = @"connectionCell";

    ConnectionsCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ConnectionsCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    connection = [[connections objectAtIndex:indexPath.row]objectForKey:@"liked_user"];
    
    if ([connection objectForKey:@"instagram_username"]) {
        //show insta button
        cell.instagramImage.hidden = false;
    }
    if ([connection objectForKey:@"snapchat_username"]) {
        //show snap button
        cell.snapchatImage.hidden = false;
    }
    if ([connection objectForKey:@"twitter_username"]) {
        //show twitter button
        cell.twitterImage.hidden = false;
    }
    if ([connection objectForKey:@"phone_number"]) {
        //show phone button
        cell.phoneImage.hidden = false;
    }
    if ([connection objectForKey:@"facebook_uid"]) {
        //show insta button
        cell.facebookImage.hidden = false;
    }
    NSString *picURL = [NSString stringWithFormat:@"http://api-dev.countdownsocial.com/user/%@/photo", [connection objectForKey:@"uid"]];
    
    NSLog(@"setProfilePicURL:%@",picURL);
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    
    NSString *FbToken = [session accessTokenData].accessToken;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:picURL parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         cell.profilePic.image = responseObject;
                                         cell.profilePic.layer.cornerRadius = cell.profilePic.layer.frame.size.height/2;
                                         cell.profilePic.layer.masksToBounds = YES;
                                         //NSLog(@"resonse Object %@",responseObject);
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Photo failed to load%@",error);
                                     }];
    cell.nameLabel.text = [connection objectForKey:@"firstName"];
    
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [connections count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Connection *obj = [Connection getInstance];
    connection = [connections objectAtIndex:indexPath.row];
    obj.connection = connection;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *profileVC = (UIViewController*)[storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    // present
    [self presentViewController:profileVC animated:YES completion:nil];

}

@end
