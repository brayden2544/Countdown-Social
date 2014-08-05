//
//  VideoPreviewViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 5/14/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "ViewController.h"

@interface VideoPreviewViewController : ViewController <UIAlertViewDelegate>

@property(nonatomic) NSString *videoFile;


- (IBAction)approveVideo:(id)sender;
- (IBAction)back:(id)sender;

@end

