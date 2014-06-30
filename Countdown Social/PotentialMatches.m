//
//  PotentialMatches.m
//  Countdown Social
//
//  Created by Brayden Adams on 6/19/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "PotentialMatches.h"

@implementation PotentialMatches
@synthesize potentialMatches;

+(PotentialMatches *)getInstance{
    static PotentialMatches *instance = nil;
    static dispatch_once_t onceToken;
    
   dispatch_once(&onceToken, ^{
            instance= [[self alloc]init];
       instance.potentialMatches = [[NSMutableArray alloc]init];
   }); return instance;
    }

+(PotentialMatches *)nextMatch{
    static PotentialMatches *instance = nil;
    instance = [self getInstance];
    NSMutableArray *matches = instance.potentialMatches;
    [matches removeObjectAtIndex:0];
     instance.potentialMatches = matches;
    return instance;
}

//-(id)init{
//    if (self = [super init]) {
//        potentialMatches = [NSMutableArray arrayWithCapacity:100];
//    }
//    return self;
//}


@end
