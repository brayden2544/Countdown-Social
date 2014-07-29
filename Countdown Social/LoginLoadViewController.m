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
#import "PotentialMatchesViewController.h"
#import "MenuViewController.h"
#import "PotentialMatches.h"
#import "User.h"
#import "RESideMenu/RESideMenu.h"
#import "ConnectionsList.h"

@interface LoginLoadViewController ()

@end

@implementation LoginLoadViewController





-(void)getUserObject{
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];


    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSDictionary *params = @{};
    [manager POST:@"http://api-dev.countdownsocial.com/user" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        User *Userobj =  [User getInstance];
        Userobj.user= responseObject;
        user = responseObject;
        if ([[user objectForKey:@"vacation_mode"]  isEqual:@false] ) {
            [self checkLocationServices];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateLocationCompleted" object:nil];
 
        }
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [self getUserObject];
     }];

    
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
        NSDictionary *params = @{@"lat": [NSString stringWithFormat:@"%g",currentLocation.coordinate.latitude],
                                 @"long": [NSString stringWithFormat:@"%g",currentLocation.coordinate.longitude]};
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
    NSLog(@"Location services disabled");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled!!"
                                                    message:@"Set Travel Mode Location \n\n or \n\n To have Countdown use your current location go to Settings, Location Services, and enable Countdown!"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Okay", nil];
    [alert show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateLocationCompleted" object:nil];


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
    [self getUserObject];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled!!"
                                                        message:@"Set Travel Mode Location \n or \n To have Countdown use your current location go to Settings, Location Services, and enable Countdown!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Okay", nil];
        [alert show];
        

        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateLocationCompleted" object:nil];

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
    [ConnectionsList getInstance];
}

- (void)successfulLogin
{
    
        dispatch_async(dispatch_get_main_queue(), ^{
        // Update the UI
        NSLog(@"Successful Notification Alert");

            NSLog(@"present matching view controller here");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
            [self presentViewController:menuViewController animated:YES completion:nil];
            

    });
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



@end
