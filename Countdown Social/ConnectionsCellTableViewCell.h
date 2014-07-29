//
//  ConnectionsCellTableViewCell.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/28/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionsCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *notificationImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;
@property (weak, nonatomic) IBOutlet UIImageView *snapchatImage;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;
@property (weak, nonatomic) IBOutlet UIImageView *instagramImage;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;


@end
