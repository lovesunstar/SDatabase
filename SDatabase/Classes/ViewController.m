//
//  ViewController.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "ViewController.h"
#import "SUserTableViewController.h"
#import "SUserDB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterUserTable:(id)sender {
    SUserDB * db = [[SUserDB alloc] init];
    [db createDataBase];
    SUserTableViewController * controller =   [[SUserTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
