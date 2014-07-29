//
//  RightMenuViewController.h
//  Countdown Social
//
//  Created by Brayden Adams on 7/25/14.
//  Copyright (c) 2014 Brayden Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionsCellTableViewCell.h"

@interface RightMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *ConnectionsTableView;
@property (strong, nonatomic) IBOutlet ConnectionsCellTableViewCell *connectionstableviewcell;


@property (strong, nonatomic) NSMutableArray *connections;
@property (strong, nonatomic) NSDictionary *connection;




@end
