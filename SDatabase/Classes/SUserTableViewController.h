//
//  SUserTableViewController.h
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SDBManager.h"
#import "SUserDB.h"
#import "SUser.h"

@interface SUserTableViewController : UITableViewController {
    SUserDB * _userDB;
    
    NSMutableArray * _userData;
}

@end
