//
//  AppDelegate.h
//  Countdown Social
//
//  Created by Brayden Adams on 4/27/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MapKit/MapKit.h>
#import "AFNetworking/AFOAuth1Client.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
FBSession *FBsession;
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) FBSession *FBsession;



@end
