//
//  Constants.h
//  Countdown Social
//
//  Created by Brayden Adams on 8/11/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#ifdef DEBUG
    //#define kBaseURL @"http://api-dev.countdownsocial.com/"
    #define kBaseURL @"http://countdown-live.elasticbeanstalk.com/"
#else
    //#define kBaseURL @"http://api-live.countdownsocial.com/";
    #define kBaseURL @"http://api-live.countdownsocial.com/";
#endif

@end
