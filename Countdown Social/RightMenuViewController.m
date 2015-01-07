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
#import "Constants.h"

@interface RightMenuViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableDictionary *imageDictionary;
@property BOOL isFiltered;
@end

@implementation RightMenuViewController
@synthesize connections;
@synthesize connection;
@synthesize lastMessage;
@synthesize connectionSearchBar;
@synthesize isFiltered;

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

    _imageDictionary = [[NSMutableDictionary alloc]init];
    ConnectionsList *obj = [ConnectionsList getInstance];
    connections = obj.connections;
    self.ConnectionsTableView.dataSource = self;
    self.ConnectionsTableView.delegate = self;
    // Do any additional setup after loading the view.
    //[self.ConnectionsTableView registerClass:[ConnectionsCellTableViewCell class] forCellReuseIdentifier:@"connectionCell"];
    self.ConnectionsTableView.layer.cornerRadius = 5;
    self.ConnectionsTableView.layer.masksToBounds = YES;
    
    //Set up search filteredConnections array
    connectionSearchBar.delegate = (id)self;
    self.filteredConnections = [[NSMutableArray alloc]init];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateTable)
                  forControlEvents:UIControlEventValueChanged];
    [self.ConnectionsTableView addSubview:self.refreshControl];
    [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(updateTable) userInfo:nil repeats:YES];
   
   
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.view endEditing:YES];

}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.connectionSearchBar resignFirstResponder];
    return YES;
}
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        self.filteredConnections = [[NSMutableArray alloc] init];
        
        for (NSDictionary* search in connections)
        {
            NSRange nameRange = [[[search objectForKey:@"liked_user"]objectForKey:@"firstName"] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound )
            {
                [self.filteredConnections addObject:search];
            }
        }
    }
    
    [self updateTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateTable{
    [ConnectionsList updateMatches];
    ConnectionsList *obj = [ConnectionsList getInstance];
    connections = obj.connections;
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"date_time" ascending:NO];
    connections = [NSMutableArray arrayWithArray:[connections sortedArrayUsingDescriptors:@[dateSort]]];
    [self.ConnectionsTableView reloadData];
    [self.refreshControl endRefreshing];
    NSLog(@"update Table Called");

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Connection should be populating");
    static NSString *CellIdentifier = @"connectionCell";

    ConnectionsCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ConnectionsCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //NSLog(@"%@",connections);
    if (isFiltered) {
        connection = [self.filteredConnections objectAtIndex:indexPath.row];
    }else{
        connection = [connections objectAtIndex:indexPath.row];
    }

    NSLog(@"connection%@", connection);
    NSLog(@"IS new??%@",[connection objectForKey:@"is_new"]);
    if (
        [[connection objectForKey:@"is_new"]boolValue]==1)  {
        cell.notificationImage.hidden = FALSE;
    }
    else{
        cell.notificationImage.hidden = true;
    }

    
    if ([connection objectForKey:@"last_message"]&&
        [connection objectForKey:@"last_message"] !=[NSNull null]&&
        [[connection objectForKey:@"last_message"] objectForKey:@"content"]&&
        [[connection objectForKey:@"last_message"] objectForKey:@"content"]!=[NSNull null]) {
        lastMessage = [connection objectForKey:@"last_message"];

        NSString *fullMessage = [NSString stringWithFormat:@"%@",[lastMessage objectForKey:@"content"]];
        if (fullMessage.length > 20) {
            NSString *shortMessage = [fullMessage substringWithRange:NSMakeRange(0,20)];
            cell.label.text = shortMessage;
        }else{
            cell.label.text = fullMessage;
        }
        if ([lastMessage objectForKey:@"is_new"] !=[NSNull null]&&
            [[lastMessage objectForKey:@"is_new"]boolValue]==1) {
            cell.notificationImage.hidden = false;
        }
        
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd"];
        NSDate *connectionNSDate = [NSDate dateWithTimeIntervalSince1970:[[connection objectForKey:@"date_time"]doubleValue]/1000];
        NSLog(@"Date = %@", connectionNSDate);
        NSString *connectionDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:connectionNSDate ]];
        cell.label.text = [NSString stringWithFormat:@"Connected %@ ",connectionDate];
    }
       if ([[connection objectForKey:@"liked_user" ] objectForKey:@"instagram_username"]!=[NSNull null]) {
        //show insta button
        cell.instagramImage.hidden = false;
    }
    else{
        cell.instagramImage.hidden = TRUE;
    }
    if ([[connection objectForKey:@"liked_user" ] objectForKey:@"snapchat_username"]!=[NSNull null]) {
        //show snap button
        cell.snapchatImage.hidden = false;
    } else{
        cell.snapchatImage.hidden = TRUE;
    }
    if ([[connection objectForKey:@"liked_user" ] objectForKey:@"twitter_username"] !=[NSNull null]) {
        //show twitter button
        cell.twitterImage.hidden = false;
    } else{
        cell.twitterImage.hidden = TRUE;
    }
    if ([[connection objectForKey:@"liked_user" ] objectForKey:@"phone_number"]!=[NSNull null]) {
        //show phone button
        cell.phoneImage.hidden = false;
    } else{
        cell.phoneImage.hidden = TRUE;
    }
    if ([[connection objectForKey:@"liked_user" ] objectForKey:@"facebook_uid"]==[NSNull null]||
        [[[[connection objectForKey:@"liked_user" ] objectForKey:@"facebook_uid"]stringValue] isEqualToString:@"0"]) {
        //show insta button
        cell.facebookImage.hidden = true;
    } else{
        cell.facebookImage.hidden = false;
    }
    cell.uid = [NSString stringWithFormat:@"%@",[[connection objectForKey:@"liked_user"]objectForKey:@"uid" ]];
    NSLog(@"cell.uid = %@",cell.uid);
    cell.nameLabel.text = [[connection objectForKey:@"liked_user" ] objectForKey:@"firstName"];
    
    [self updatePic:cell uidString:cell.uid];
    
    return cell;
}

-(void)updatePic:(ConnectionsCellTableViewCell *)cell uidString:(NSString *)uid{
    NSString *picURL = kBaseURL;
    picURL = [picURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/photo",uid]];
    
    NSLog(@"setProfilePicURL:%@",picURL);
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    
    
    NSString *FbToken = [session accessTokenData].accessToken;

    if ([_imageDictionary objectForKey:uid]) {
        cell.profilePic.image =[_imageDictionary objectForKey:uid];
    }
    else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        manager.responseSerializer = [AFImageResponseSerializer serializer];
        [manager GET:picURL parameters:@{@"height":@100,
                                         @"width": @100} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             cell.profilePic.image = responseObject;
                                             cell.profilePic.layer.cornerRadius = cell.profilePic.layer.frame.size.height/2;
                                             cell.profilePic.layer.masksToBounds = YES;
                                             [_imageDictionary setObject:responseObject forKey:uid];
                                             NSLog(@"cell uid:%@",cell.uid);
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"Photo failed to load%@",error);
                                         }];
        
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger rowCount;
    if (self.isFiltered) {
        rowCount = [self.filteredConnections count];
    }else{
        rowCount = [connections count];
    }
    return rowCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    Connection *obj = [Connection getInstance];
    if (isFiltered) {
        connection = [[NSMutableDictionary alloc]initWithDictionary:[self.filteredConnections objectAtIndex:indexPath.row]];
    }else{
    connection = [[NSMutableDictionary alloc]initWithDictionary:[connections objectAtIndex:indexPath.row]];
    }
        obj.connection = connection;
    ConnectionsCellTableViewCell *cell = (ConnectionsCellTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.notificationImage.hidden = TRUE;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}

@end
