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

@interface LoginLoadViewController ()

@end

@implementation LoginLoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) loadCamera{
    PBJViewController *videorecorderviewcontroller = [[PBJViewController alloc] init];
    [self presentViewController:videorecorderviewcontroller animated:YES completion:nil];
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
        
        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        
        NSString *FbToken = [session accessTokenData].accessToken;
        
        NSLog(@"Token is %@", FbToken);
        
        [urlRequest setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        
        
        [urlRequest setTimeoutInterval:5.0f];
        [urlRequest setHTTPMethod:@"POST"];
        
        NSOperationQueue *queque = [[NSOperationQueue alloc] init];
        
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
                 
                 NSLog(@" POST HTML = %@", html);
                
                 
                 
                 id UserJson = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:NSJSONReadingAllowFragments
                                error:&error];
                 user = UserJson;
                 NSLog(@"dictionary contains %@" , user);
                 
                 
                 
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"POST Nothing was downloaded.");
                              }
             else if (error !=nil){
                 NSLog(@"Error happened = %@", error);
                 NSLog(@"POST BROKEN");
             }
         }];
        //Check to see if user has video uploaded, if not, video upload screen is shown.
        if ([[user objectForKey: @"videoUri"]  isEqual: @"null"]){
            PBJViewController *videorecorderviewcontroller = [[PBJViewController alloc] init];
            [self presentViewController:videorecorderviewcontroller animated:YES completion:nil];
        }
        //If user has video, matching screen is uploaded.
        else {
            NSLog(@"present matching view controller here");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PotentialMatchesViewController *potentialmatchesviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"PotentialMatchesViewController"];
            [self presentViewController:potentialmatchesviewcontroller animated:YES completion:nil];
        }

        
    }
    
    [self.currentLocationManager stopUpdatingLocation];
    
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Failed with error %@", error);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Gets current Location of User

             if ([CLLocationManager locationServicesEnabled]) {
                 
                 self.currentLocationManager = [[CLLocationManager alloc] init];
                 self.currentLocationManager.delegate = self;
                 
                 [self.currentLocationManager startUpdatingLocation];
                 NSLog(@"If Loop WOrking");
             }
             else {
                 //TODO: Create code for manual selection of location.
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 ChooseLocationViewController *chooseLocationViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChooseLocationViewController"];
                 [self presentViewController:chooseLocationViewController animated:YES completion:nil];
             }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
