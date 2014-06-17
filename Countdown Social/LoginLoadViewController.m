//
//  LoginLoadViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 5/6/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "LoginLoadViewController.h"
#import "AppDelegate.h"
#import "PBJViewController.h"
#import "ChooseLocationViewController.h"
#import "PotentialMatchesViewController.h"
#import "MenuViewController.h"

@interface LoginLoadViewController ()

@end

@implementation LoginLoadViewController

@synthesize user;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//gets current location and uploads it to API.
-(void) locationManager:(CLLocationManager *)manager
           didUpdateToLocation:(CLLocation *)newLocation
                  fromLocation:(CLLocation *)oldLocation{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation !=nil){
        
        NSLog(@"Longitude %.8f", currentLocation.coordinate.longitude);
        NSLog(@"Latitude %.8f", currentLocation.coordinate.latitude);
        

        NSString *urlAsString =@"http://api-dev.countdownsocial.com/user";
        
        NSURL *url = [NSURL URLWithString:urlAsString];
        
        NSMutableURLRequest *urlRequest =
        [NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setHTTPBody:[[NSString stringWithFormat:@"lat=%g&long=%g", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude] dataUsingEncoding:NSUTF8StringEncoding]];
        [self.currentLocationManager stopUpdatingLocation];

        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        
        NSString *FbToken = [session accessTokenData].accessToken;
        
        NSLog(@"Token is %@", FbToken);
        
        [urlRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        
        
        [urlRequest setTimeoutInterval:300.0f];
        [urlRequest setHTTPMethod:@"POST"];
        
        NSOperationQueue *queque = [[NSOperationQueue alloc] init];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^{
            
            
        [NSURLConnection
         sendAsynchronousRequest:urlRequest
         queue:queque
         completionHandler:^(NSURLResponse *response,
                             NSData *data,
                             NSError *error){
             if ([data length] >0 && error == nil){
                 NSString *html =
                 [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
                 NSLog(html);
                 
                 id UserJson = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:NSJSONReadingAllowFragments
                                error:&error];
                 user = UserJson;

                 NSLog(@"dictionary contains %@" , user);
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFinish" object:nil];

                 
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"POST Nothing was downloaded.");
                              }
             else if (error !=nil){
                 NSLog(@"Error happened = %@", error);
                 NSLog(@"POST BROKEN");
             }
         }];
        });
        
    }
    
    
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Failed with error %@", error);
}

//void (^fillPotentialMatchesQueue)(void)= ^{
//    
//    NSString *urlAsString = @"http://www.countdownsocial.com/user/";
//    urlAsString = [urlAsString NSStringbyAppendingString]
//};

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Waits for login request to complete from Countdown Api
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (successfulLogin)
                                            name:@"NSURLConnectionDidFinish"
                                            object:nil];
    //Gets current Location of User

             if ([CLLocationManager locationServicesEnabled]) {
                 
                 self.currentLocationManager = [[CLLocationManager alloc] init];
                 self.currentLocationManager.delegate = self;
                 
                 [self.currentLocationManager startUpdatingLocation];
                 NSLog(@"Updating Location");
             }
             else {
                 //TODO: Create code for manual selection of location.
                 NSLog(@"Location services disabled");
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 ChooseLocationViewController *chooseLocationViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChooseLocationViewController"];
                 [self presentViewController:chooseLocationViewController animated:YES completion:nil];
             }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory Warning in LoginLoadViewController");
}


- (void) successfulLogin
{
    
    //start filling Potential Matches Queue
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        
       __block NSMutableArray *potentialMatches = nil;
        
        dispatch_async(concurrentQueue, ^{
           //Download potential matches here
            NSString *urlAsString =@"http://countdown-java-dev.elasticbeanstalk.com/user/";
            // TODO:NSString *userID = [user objectForKey:@"uid"];
            urlAsString = [urlAsString stringByAppendingString:@"690825080"];
            urlAsString = [urlAsString stringByAppendingString:@"/nextPotentials"];
            NSLog(@"%@", urlAsString);
            
            NSURL *PotentialMatchesUrl = [NSURL URLWithString:urlAsString];
            
            NSMutableURLRequest *potentialMatchesRequest = [NSMutableURLRequest requestWithURL:PotentialMatchesUrl];
            
            
            FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
            
            NSString *FbToken = [session accessTokenData].accessToken;
            [potentialMatchesRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];

            [potentialMatchesRequest setTimeoutInterval:300.0f];
            [potentialMatchesRequest setHTTPMethod:@"POST"];
            NSLog(@"IN DISPATCH");
            NSOperationQueue *potentialMatchesQueue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection
             sendAsynchronousRequest:potentialMatchesRequest
             queue:potentialMatchesQueue
             completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                
                 if ([data length] >0 && error == nil){
                     NSString *html =
                     [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
                     NSLog(html);
                     
                     
                 }
                 else if ([data length] == 0 && error == nil){
                     NSLog(@"POST Nothing was downloaded.");
                 }
                 else if (error !=nil){
                     NSLog(@"Error happened = %@", error);
                     NSLog(@"POST BROKEN");
                 }
             }];
            
            
            
        });
    });
    
    NSLog(@"Successful Notification Alert");
    //Check to see if user has video uploaded, if not, video upload screen is shown.
  if ((NSNull *)[user objectForKey: @"videoUri"] == [NSNull null]){
        PBJViewController *pbjViewController = [[PBJViewController alloc] init];
        [self presentViewController:pbjViewController animated:YES completion:nil];

    }
    //If user has video, matching screen is uploaded.
    else {
        NSLog(@"present matching view controller here");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
        [self presentViewController:menuViewController animated:YES completion:nil];
        
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
