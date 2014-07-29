//
//  ConnectionsCellTableViewCell.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/28/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ConnectionsCellTableViewCell.h"

@implementation ConnectionsCellTableViewCell
@synthesize nameLabel;
@synthesize notificationImage;
@synthesize phoneImage;
@synthesize profilePic;
@synthesize snapchatImage;
@synthesize facebookImage;
@synthesize instagramImage;
@synthesize twitterImage;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
