//
//  MessagesViewController.m
//  Countdown Social
//
//  Created by Brayden Adams on 7/29/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import "MessagesViewController.h"


#import "User.h"
#import "Connection.h"
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "Constants.h"

@interface MessagesViewController ()
@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) NSDictionary *connection;
@property (strong, nonatomic) UIImage *senderImage;
@property (strong, nonatomic) UIImage *connectionImage;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *typingTimer;


@end

@implementation MessagesViewController
@synthesize user;
@synthesize connection;
@synthesize senderImage;
@synthesize connectionImage;



- (void)viewDidLoad
{
    


    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (loadConnectionAvatar)
                                                 name:@"ConnectionImageLoaded"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (loadUserAvatar)
                                                 name:@"UserImageLoaded"
                                               object:nil];
    
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"messagingNavbar"] forBarMetrics:UIBarMetricsDefault];
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    User *obj = [User getInstance];
    user = obj.user;
    Connection *conObj = [Connection getInstance];
    connection = [conObj.connection objectForKey:@"liked_user"];
    self.title = [connection objectForKey:@"firstName"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor blackColor],
       NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:26.0]}];
    self.sender =[user objectForKey: @"uid"];
    
    
    self.outgoingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    outgoingMessageBubbleImageViewWithColor:[UIColor colorWithRed:86/255.0 green:249/255.0 blue:213/255.0 alpha:1]];
    
    self.incomingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    incomingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    


    [self getMessages];
    [self downloadAvatars];

    _timer = [NSTimer    scheduledTimerWithTimeInterval:10.0    target:self    selector:@selector(refreshMessages)    userInfo:nil repeats:YES];
    _typingTimer =[NSTimer    scheduledTimerWithTimeInterval:3.0    target:self    selector:@selector(checkTyping)    userInfo:nil repeats:YES];
}

-(void)getMessages{
    NSString *messageURL =kBaseURL;
    messageURL = [messageURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/conversation", [connection objectForKey:@"uid"]]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:messageURL parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"resonse Object %@",responseObject);
        self.messages = [[NSMutableArray alloc]init];
        for (NSDictionary *messageContent in responseObject ) {
            JSQMessage *message = [[JSQMessage alloc] initWithText:[messageContent objectForKey:@"content"] sender:[messageContent objectForKey:@"from_user_id"] date:[NSDate dateWithTimeIntervalSince1970:[[messageContent objectForKey:@"date_time"]doubleValue]/1000]];
            NSLog(@"double value %@",message.date);

            [self.messages addObject:message];
        }
        [self.collectionView reloadData];
        [self finishReceivingMessage];

       
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Photo failed to load%@",error);
                                     }];
}

-(void) downloadAvatars{
    CGFloat incomingDiameter = self.collectionView.collectionViewLayout.incomingAvatarViewSize.width;
    //self.avatars = [[NSMutableDictionary alloc]init];
    NSString *picURL =kBaseURL;
    picURL = [picURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/photo", [connection objectForKey:@"uid"]]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:picURL parameters:@{@"height": @50,
                                     @"width": @50} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         connectionImage = [JSQMessagesAvatarFactory avatarWithImage:responseObject
                                                                                                diameter:incomingDiameter];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectionImageLoaded" object:nil];


        
                                         NSLog(@"resonse Object %@",responseObject);
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Photo failed to load%@",error);
                                     }];


}

-(void) loadConnectionAvatar{
    CGFloat outgoingDiameter = self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width;
    //self.avatars = [[NSMutableDictionary alloc]init];
    NSString *picURL =kBaseURL;
    picURL = [picURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/photo", [user objectForKey:@"uid"]]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:picURL parameters:@{@"height": @50,
                                     @"width": @50} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         senderImage = [JSQMessagesAvatarFactory avatarWithImage:responseObject
                                                                                            diameter:outgoingDiameter];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UserImageLoaded" object:nil];
                                         
                                         
                                         
                                         NSLog(@"resonse Object %@",responseObject);
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Photo failed to load%@",error);
                                     }];

}
-(void) loadUserAvatar{
    self.avatars = @{self.sender:senderImage,
                     [connection objectForKey:@"uid"]:connectionImage};
    [self.collectionView reloadData];
    NSLog(@"is this called?");
    
    
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.delegateModal didDismissMessagesViewController:self];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"]]animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self typingStarted];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self typingStopped];
}

- (void)refreshMessages{
    NSString *messageURL =kBaseURL;
    messageURL = [messageURL stringByAppendingString:[NSString stringWithFormat:@"user/%@/conversation", [connection objectForKey:@"uid"]]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:messageURL parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tempMessages = [[NSMutableArray alloc]init];
        for (NSDictionary *messageContent in responseObject ) {
            JSQMessage *message = [[JSQMessage alloc] initWithText:[messageContent objectForKey:@"content"] sender:[messageContent objectForKey:@"from_user_id"] date:[NSDate dateWithTimeIntervalSince1970:[[messageContent objectForKey:@"date_time"]doubleValue]/1000]];
            [tempMessages addObject:message];
        }
        NSMutableArray *newMessageArray = [[NSMutableArray alloc]initWithArray:tempMessages];
        for(JSQMessage *message in tempMessages){
            if ([message.sender isEqualToString:self.sender]) {
                [newMessageArray removeObject:message];
            }
        for (JSQMessage *oldMessage in self.messages ) {
            if ([oldMessage isEqualToMessage:message]) {
                [newMessageArray removeObject:message];
            }
           
        }
        }
        if ([newMessageArray count]>0) {
            [self.messages addObjectsFromArray:newMessageArray];
            [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
            [self finishReceivingMessage];
            NSLog(@"New Messages");

        }
        
        if (    self.inputToolbar.contentView.textView.hasText) {
            [self typingStarted];
        }
        else{
            [self typingStopped];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Photo failed to load%@",error);
    }];
}
-(void)checkTyping{
    NSString *typingUrl =kBaseURL;
    typingUrl = [typingUrl stringByAppendingString:[NSString stringWithFormat:@"user/%@/message/typing", [connection objectForKey:@"uid"] ]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:typingUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status" ]integerValue]==1  ) {
            self.showTypingIndicator =true;
            [self scrollToBottomAnimated:YES];
            NSLog(@"user is Typing");
        }else if ([[responseObject objectForKey:@"status"]integerValue]==0){
            self.showTypingIndicator = false;
            NSLog(@"user is not Typing");

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error with typing stopped %@",error);
    }];
    
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                    sender:(NSString *)sender
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithText:text sender:sender date:date];
    [self.messages addObject:message];
    NSString *messageURL = [NSString stringWithFormat:@"user/%@/message/", [connection objectForKey:@"uid"]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:messageURL parameters:@{@"content":message.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);

    }];
    [self typingStopped];
    [self finishSendingMessage];
    [self scrollToBottomAnimated:NO];

}
- (void) typingStopped{
    NSString *typingUrl =kBaseURL;
    typingUrl = [typingUrl stringByAppendingString:[NSString stringWithFormat:@"user/%@/message/typing", [connection objectForKey:@"uid"]]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    [manager DELETE:typingUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Typing stopped");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error with typing stopped %@",error);
    }];
}

- (void) typingStarted{
    NSString *typingUrl =kBaseURL;
    typingUrl = [typingUrl stringByAppendingString:[NSString stringWithFormat:@"user/%@/message/typing", [connection objectForKey:@"uid"]]];
    FBSession *session = [(AppDelegate *)[[UIApplication sharedApplication] delegate] FBsession];
    NSString *FbToken = [session accessTokenData].accessToken;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager.requestSerializer setValue:FbToken forHTTPHeaderField:@"Access-Token"];
    [manager POST:typingUrl parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Typing started");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error with typing started %@",error);
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                          target:self
                                                                                          action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem.tintColor =[UIColor colorWithRed:86/255.0 green:249/255.0 blue:213/255.0 alpha:1];
}
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.sender isEqualToString:self.sender]) {
        return [[UIImageView alloc] initWithImage:self.outgoingBubbleImageView.image
                                 highlightedImage:self.outgoingBubbleImageView.highlightedImage];
    }
    
    return [[UIImageView alloc] initWithImage:self.incomingBubbleImageView.image
                             highlightedImage:self.incomingBubbleImageView.highlightedImage];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
     JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    UIImage *avatarImage = [self.avatars objectForKey:message.sender];
    return [[UIImageView alloc] initWithImage:avatarImage];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
      if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.sender isEqualToString:self.sender]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage sender] isEqualToString:message.sender]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.sender];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if ([msg.sender isEqualToString:self.sender]) {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else {
        cell.textView.textColor = [UIColor blackColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
//    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
//    if ([[currentMessage sender] isEqualToString:self.sender]) {
//        return 0.0f;
//    }
//    
//    if (indexPath.item - 1 > 0) {
//        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
//        if ([[previousMessage sender] isEqualToString:[currentMessage sender]]) {
//            return 0.0f;
//        }
//    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

-(void)viewDidDisappear:(BOOL)animated{
    [_timer invalidate];
    [_typingTimer invalidate];
}




@end
