//
//  MessagesViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/29/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"

@class MessagesViewController;

@protocol MessagesViewControllerDelegate <NSObject>

- (void)didDismissMessagesViewController:(MessagesViewController *)vc;

@end

@interface MessagesViewController : JSQMessagesViewController

@property (weak, nonatomic) id<MessagesViewControllerDelegate> delegateModal;


@property (strong, nonatomic) NSMutableArray *messages;
@property (copy, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;

- (void)closePressed:(UIBarButtonItem *)sender;


@end
