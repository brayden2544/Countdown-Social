//
//  FeedbackViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/18/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "FeedbackViewController.h"
#import "RESideMenu.h"
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"
#import "AppDelegate.h"


@interface FeedbackViewController ()
@property (strong, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (strong, nonatomic) NSString *feedback;

@end

@implementation FeedbackViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.feedbackTextView.delegate = self;
    
    
    
}

- (void)postFeedback{

    NSString *urlAsString =@"http://api-dev.countdownsocial.com/feedback/";
//    urlAsString = [urlAsString stringByAppendingString:[[user objectForKey:@"uid"] stringValue]];
//    urlAsString =[urlAsString stringByAppendingString:@"/feedback"];
    
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc]init];
    manager.operationQueue = backgroundQueue;
    NSDictionary *params = @{@"content":_feedback};
    [manager POST:urlAsString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback Uploaded!!"
                                                        message:@"Thanks for helping us make Countdown better!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Okay", nil];
        [alert show];
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback Not Uploaded!!"
                                                         message:@"Please try again!"
                                                        delegate:self
                                               cancelButtonTitle:@"Okay"
                                               otherButtonTitles:nil];
         [alert show];
         
     }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Clicked button index 0");
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)presentMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)submitFeedback:(id)sender {
    _feedback =_feedbackTextView.text;
    [self postFeedback];
}
@end
