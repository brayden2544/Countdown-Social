//
//  SettingsViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/18/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
{
    IBOutlet UISwitch *hideProfile;
    IBOutlet UISwitch *sexualOrientation;
    
}


- (IBAction)presentMenu:(id)sender;

@end
