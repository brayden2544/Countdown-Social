//
//  PhoneNumberView.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/8/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneNumberView : UIView

@property NSString *phoneNumber;

@property (strong, nonatomic)IBOutlet UITextField *phoneNumberText;

- (IBAction)setPhoneNumberButton:(id)sender;
- (IBAction)cancel:(id)sender;



@end
