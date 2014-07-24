//
//  APNsToken.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/23/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APNsToken : NSObject{
    NSString *APNsToken;
}
@property (nonatomic,strong) NSString *APNsToken;

+(APNsToken*)getInstance;

@end
