//
//  APNsToken.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/23/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APNsToken : NSObject{
    NSData *APNsToken;
}
@property (nonatomic,strong) NSData *APNsToken;

+(APNsToken*)getInstance;

@end
