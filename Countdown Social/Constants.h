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
    #define kBaseURL @"http://api-dev.countdownsocial.com/"
#else
    #define kBaseURL @"http://api-live.countdownsocial.com/";

#endif

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@end
