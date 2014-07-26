//
//  Connection.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/25/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connection : NSObject{
NSDictionary *connection;
}

@property (nonatomic, retain) NSDictionary *connection;

+(Connection*)getInstance;

@end


