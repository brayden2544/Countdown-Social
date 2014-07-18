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

@interface SetLocationViewController ()

@end

@implementation SetLocationViewController

@synthesize travelModeSwitch;
@synthesize setLocationMapView;
@synthesize travelModeAnnotation;
@synthesize fbProfilePic;
@synthesize setLocationButton;

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
    self.user = [User getInstance];
    
    //Creat URL for image and download image
    NSString *picURL = @"http://graph.facebook.com/";
    NSString *uid =[[self.user.user objectForKey:@"uid"] stringValue];
    picURL= [picURL stringByAppendingString:uid];
    picURL = [picURL stringByAppendingString:@"/picture?width=200&height=200"];
    NSURL *url = [NSURL URLWithString:picURL];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    self.fbProfilePic = [UIImage imageWithData:imageData];

    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.3; //user needs to press for 2 seconds
    [self.setLocationMapView addGestureRecognizer:lpgr];
    
    travelModeAnnotation = [[MKPointAnnotation alloc] init];

    
    
    self.setLocationMapView.showsUserLocation=YES;
    self.setLocationMapView.delegate=self;
    [self.setLocationMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.setLocationMapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    
    [self.setLocationMapView setRegion:mapRegion animated: YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    travelModeAnnotation.title = @"Travel Mode Location";
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
        MKCoordinateRegion mapRegion;
        mapRegion.center = self.setLocationMapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.2;
        mapRegion.span.longitudeDelta = 0.2;
    
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
@end
