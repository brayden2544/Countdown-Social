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
#import "ResideMenu.h"

@interface RightMenuViewController ()

@property (nonatomic, strong) NSTimer *timer;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"newConnections" object:nil];

    ConnectionsList *obj = [ConnectionsList getInstance];
    connections = obj.connections;
    self.ConnectionsTableView.dataSource = self;
    self.ConnectionsTableView.delegate = self;
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
- (void)updateTable{
    ConnectionsList *obj = [ConnectionsList getInstance];
    connections = obj.connections;
    [self.ConnectionsTableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell should be populating");
    static NSString *CellIdentifier = @"connectionCell";

    ConnectionsCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ConnectionsCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    connection = [[connections objectAtIndex:indexPath.row]objectForKey:@"liked_user"];
    if ([[connections objectAtIndex:indexPath.row]objectForKey:@"is_new"]!=[NSNull null] && [[[connections objectAtIndex:indexPath.row]objectForKey:@"is_new"]boolValue]==true)  {
        cell.notificationImage.hidden = FALSE;
    }
    else{
        cell.notificationImage.hidden = true;
    }
    if ([connection objectForKey:@"instagram_username"]!=[NSNull null]) {
        //show insta button
        cell.instagramImage.hidden = false;
    }
    else{
        cell.instagramImage.hidden = TRUE;
    }
    if ([connection objectForKey:@"snapchat_username"]!=[NSNull null]) {
        //show snap button
        cell.snapchatImage.hidden = false;
    } else{
        cell.snapchatImage.hidden = TRUE;
    }
    if ([connection objectForKey:@"twitter_username"] !=[NSNull null]) {
        //show twitter button
        cell.twitterImage.hidden = false;
    } else{
        cell.twitterImage.hidden = TRUE;
    }
    if ([connection objectForKey:@"phone_number"]!=[NSNull null]) {
        //show phone button
        cell.phoneImage.hidden = false;
    } else{
        cell.phoneImage.hidden = TRUE;
    }
    if ([connection objectForKey:@"facebook_uid"]!=[NSNull null]) {
        //show insta button
        cell.facebookImage.hidden = false;
    } else{
        cell.facebookImage.hidden = TRUE;
    }
    NSString *picURL = [NSString stringWithFormat:@"http://api-dev.countdownsocial.com/user/%@/photo", [connection objectForKey:@"uid"]];
    
    NSLog(@"setProfilePicURL:%@",picURL);
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    
    NSString *FbToken = [session accessTokenData].accessToken;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:picURL parameters:@{@"height":@100,
                                     @"width": @100} success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    connection = [[NSMutableDictionary alloc]initWithDictionary:[connections objectAtIndex:indexPath.row]];
    if ([[connection objectForKey:@"is_true"]boolValue]==true) {
        [connections setValue:FALSE forKey:@"is_new"];
        [connections replaceObjectAtIndex:indexPath.row withObject:connection];
        [self.ConnectionsTableView reloadData];
        NSString *urlAsString =[NSString stringWithFormat:@"http://countdown-java-dev.elasticbeanstalk.com/user/%@/like/viewed", [connection objectForKey:@"uid"]];
        
        
        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        
        NSString *FbToken = [session accessTokenData].accessToken;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        NSDictionary *params = @{};
        [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"User shown as seen");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"User not shown as seen%@", error);
        }];

    }
    obj.connection = connection;
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}

@end
