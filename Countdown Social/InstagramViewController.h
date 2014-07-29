//
//  InstagramViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 6/18/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString *instagram_token;
@property (strong, nonatomic) NSString *instagram_uid;
@property (strong, nonatomic) NSString *instagram_username;
@property (strong, nonatomic) NSString *instagram_code;


@end
