//
//  SnapchatView.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/8/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnapchatView : UIView

@property NSString *snapchatUsername;

@property (strong, nonatomic)IBOutlet UITextField *snapchatUserText;

- (IBAction)setSnapchatButton:(id)sender;
- (IBAction)cancel:(id)sender;

@end