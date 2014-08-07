//
//  ConnectionViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/28/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *matchProfilePic;


@property (strong, nonatomic) IBOutlet UILabel *connectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *checkOutLabel;

@property (strong, nonatomic) IBOutlet UIButton *viewProfileButton;

- (IBAction)keepPlayingAction:(id)sender;
- (IBAction)viewProfileAction:(id)sender;






@end
