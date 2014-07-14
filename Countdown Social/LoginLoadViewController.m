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
#import "PotentialMatches.h"
#import "User.h"

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

//gets current location and uploads it to API.
-(void) locationManager:(CLLocationManager *)manager
           didUpdateToLocation:(CLLocation *)newLocation
                  fromLocation:(CLLocation *)oldLocation{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    CLLocation *currentLocation = newLocation;
    [self.currentLocationManager stopUpdatingLocation];

    if (currentLocation !=nil){
        
        NSLog(@"Longitude %.8f", currentLocation.coordinate.longitude);
        NSLog(@"Latitude %.8f", currentLocation.coordinate.latitude);


        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        
        NSString *FbToken = [session accessTokenData].accessToken;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        NSDictionary *params = @{@"lat=": [NSString stringWithFormat:@"%g",currentLocation.coordinate.latitude],
                                 @"long=": [NSString stringWithFormat:@"%g",currentLocation.coordinate.longitude]};
        [manager POST:@"http://api-dev.countdownsocial.com/user" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            User *Userobj =  [User getInstance];
            Userobj.user= responseObject;
            user = responseObject;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateLocationCompleted" object:nil];


        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];

        
 
        
    }
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Failed with error %@", error);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Waits for login request to complete from Countdown Api
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (successfulLogin)
                                            name:@"LoginSuccessful"
                                            object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (getPotentialMatches)
                                                 name:@"UpdateLocationCompleted"
                                               object:nil];
    //Gets current Location of User
    [self checkLocationServices];
    
}

- (void)checkLocationServices {
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.currentLocationManager = [[CLLocationManager alloc] init];
        self.currentLocationManager.delegate = self;
        self.currentLocationManager.distanceFilter = 500;
        
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

- (void) getPotentialMatches
{
    [PotentialMatches getInstance];
}

- (void) successfulLogin
{
    
        dispatch_async(dispatch_get_main_queue(), ^{
        // Update the UI
        NSLog(@"Successful Notification Alert");
        //Check to see if user has video uploaded, if not, video upload screen is shown.
        //if ((NSNull *)[user objectForKey: @"videoUri"] == [NSNull null]){
//            PBJViewController *pbjViewController = [[PBJViewController alloc] init];
//            [self presentViewController:pbjViewController animated:YES completion:nil];
            
       // }
        //If user has video, matching screen is uploaded.
       // else {
            NSLog(@"present matching view controller here");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
            [self presentViewController:menuViewController animated:YES completion:nil];
            
       // }

    });
   
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
