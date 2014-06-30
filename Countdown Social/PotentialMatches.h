//
//  PotentialMatches.h
//  Countdown Social
//
//  Created by Brayden Adams on 6/19/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PotentialMatches : NSObject {
    NSMutableArray *potentialMatches;

}

@property (nonatomic, retain) NSMutableArray *potentialMatches;

+(PotentialMatches*)getInstance;
+(PotentialMatches*)nextMatch;


@end
