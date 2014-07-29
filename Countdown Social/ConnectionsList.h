//
//  ConnectionsList.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/28/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ConnectionsList : NSObject{
    NSMutableArray *connections;
}

@property (nonatomic, retain) NSMutableArray * connections;

+(ConnectionsList *)getInstance;
+(ConnectionsList *)updateMatches;

@end
