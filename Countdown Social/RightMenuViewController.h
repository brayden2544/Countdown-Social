//
//  RightMenuViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/25/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightMenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *ConnectionsTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *ConnectionsTableCell;

@property (strong, nonatomic) IBOutlet UIImageView *notification;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UIImageView *instagram;
@property (strong, nonatomic) IBOutlet UIImageView *twitter;
@property (strong, nonatomic) IBOutlet UIImageView *snapchat;
@property (strong, nonatomic) IBOutlet UIImageView *facebook;
@property (strong, nonatomic) IBOutlet UIImageView *phone;



@end
