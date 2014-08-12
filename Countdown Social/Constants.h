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

@end
