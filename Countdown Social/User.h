//
//  User.h
//  Countdown Social
//
//  Created by Brayden Adams on 6/23/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSDictionary *user;
}

@property (nonatomic, retain) NSDictionary *user;

+(User*)getInstance;

@end
