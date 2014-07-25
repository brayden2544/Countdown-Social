//
//  SetLocationViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 4/27/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "SetLocationViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "RESideMenu/RESideMenu.h"

@interface SetLocationViewController ()

@property MKCoordinateRegion mapRegion;

@end

@implementation SetLocationViewController

@synthesize travelModeSwitch;
@synthesize setLocationMapView;
@synthesize travelModeAnnotation;
@synthesize fbProfilePic;
@synthesize mapRegion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.setLocationMapView.delegate=self;
    self.user = [User getInstance];
    self.setLocationMapView.showsUserLocation=YES;

    
    //Creat URL for image and download image
    NSString *picURL = @"http://graph.facebook.com/";
    NSString *uid =[[self.user.user objectForKey:@"facebook_uid"] stringValue];
    picURL= [picURL stringByAppendingString:uid];
    picURL = [picURL stringByAppendingString:@"/picture?width=200&height=200"];
    NSURL *url = [NSURL URLWithString:picURL];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    self.fbProfilePic = [UIImage imageWithData:imageData];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.3; //user needs to press for .3 seconds
    [self.setLocationMapView addGestureRecognizer:lpgr];
    
    travelModeAnnotation = [[MKPointAnnotation alloc] init];
    mapRegion.span.latitudeDelta = 1;
    mapRegion.span.longitudeDelta = 1;

    
    
    
    if ([[self.user.user objectForKey:@"vacation_mode"]isEqual:@true]) {
        [self.setLocationMapView removeAnnotation:travelModeAnnotation];
        [travelModeSwitch setOn:YES animated:YES];
        CLLocationCoordinate2D vacation_location = CLLocationCoordinate2DMake([[self.user.user objectForKey:@"lat"]doubleValue], [[self.user.user objectForKey:@"long"]doubleValue]);
        mapRegion.center = vacation_location;
        
        [self.setLocationMapView setRegion:mapRegion animated: YES];
        
        travelModeAnnotation.title = @"CustomPinAnnotationView";
        travelModeAnnotation.coordinate = vacation_location;
        [self.setLocationMapView addAnnotation:travelModeAnnotation];
    }else{
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = 500;
            [self.locationManager startUpdatingLocation];
        } else {
            NSLog(@"Location services are not enabled");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Not Enabled!!"
                                                            message:@"To have Countdown use your current location go to Settings, Location Services, and enable Countdown!"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Okay", nil];
            [alert show];

        }
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (travelModeSwitch.isOn == FALSE) {

    CLLocation *location = [locations lastObject];
    mapRegion.center = location.coordinate;
    mapRegion = [self.setLocationMapView regionThatFits:mapRegion];
    [self.setLocationMapView setRegion:mapRegion animated:NO];
    }

}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    [travelModeSwitch setOn:YES animated:YES];
    [self.setLocationMapView removeAnnotation:travelModeAnnotation];
    CGPoint touchPoint = [gestureRecognizer locationInView:self.setLocationMapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.setLocationMapView convertPoint:touchPoint toCoordinateFromView:self.setLocationMapView];
    
    travelModeAnnotation.title = @"CustomPinAnnotationView";
    travelModeAnnotation.coordinate = touchMapCoordinate;
    [self.setLocationMapView addAnnotation:travelModeAnnotation];
    [self updateVacationLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = NO;
            pinView.image = self.fbProfilePic;
            pinView.frame =  CGRectMake(0, 0, 50, 50);
            pinView.layer.cornerRadius = 25.0;
            pinView.layer.borderWidth = 5.0;
            pinView.layer.borderColor = [UIColor whiteColor].CGColor;
            pinView.layer.masksToBounds = YES;
            pinView.calloutOffset = CGPointMake(0, 32);
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView
didAddAnnotationViews:(NSArray *)annotationViews
{
    for (MKAnnotationView *annView in annotationViews)
    {
        
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.5
                         animations:^{ annView.frame = endFrame; }];
    }
}


-(void)updateVacationLocation{
    //Update Travel Location
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    NSDictionary *params = @{@"lat": [NSString stringWithFormat:@"%g",travelModeAnnotation.coordinate.latitude],
                             @"long": [NSString stringWithFormat:@"%g",travelModeAnnotation.coordinate.longitude],
                             @"vacation_mode":@"true"};
    [manager POST:@"http://api-dev.countdownsocial.com/user" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        User *Userobj =  [User getInstance];
        Userobj.user= responseObject;
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}



- (IBAction)travelModeSwitch:(id)sender {
    
    if (travelModeSwitch.isOn == FALSE) {
        [self.setLocationMapView removeAnnotation:travelModeAnnotation];
        self.setLocationMapView.showsUserLocation=YES;
        self.setLocationMapView.delegate=self;
        [self.setLocationMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        mapRegion.center = self.setLocationMapView.userLocation.coordinate;

        mapRegion = [self.setLocationMapView regionThatFits:mapRegion];
        [self.setLocationMapView setRegion:mapRegion animated: YES];
        
        FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
        NSString *FbToken = [session accessTokenData].accessToken;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
        NSDictionary *params = @{@"lat": [NSString stringWithFormat:@"%g",self.setLocationMapView.userLocation.coordinate.latitude],
                                 @"long": [NSString stringWithFormat:@"%g",self.setLocationMapView.userLocation.coordinate.longitude],
                                 @"vacation_mode":@"false"};
        [manager POST:@"http://api-dev.countdownsocial.com/user" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            User *Userobj =  [User getInstance];
            Userobj.user= responseObject;
            
            
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
        
    }
}

- (IBAction)presentMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
@end
