//
//  VideoPath.h
//  Countdown Social
//
//  Created by Brayden Adams on 6/30/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoPath : NSObject {NSString *videoPath;}


@property (nonatomic, retain) NSString *videoPath;

+ (VideoPath*) getInstance;

@end
