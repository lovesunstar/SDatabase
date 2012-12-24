//
//  SUserTableViewController.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SUserTableViewController.h"
#import "SUserViewController.h"

@implementation SUserTableViewController

- (id) initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _userDB = [[SUserDB alloc] init];
    }
    return self;
}

- (void) loadView {
    [super loadView];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected)
        [self.tableView deselectRowAtIndexPath:selected animated:animated];
    _userData = [NSMutableArray arrayWithArray:[_userDB findWithUid:nil limit:10000]];
    [self.tableView reloadData];
}

- (void) addUser:(id) sender {
   SUserViewController * controller =  [[SUserViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_userData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellName = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    SUser * user = [_userData objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.description;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SUser * user = [_userData objectAtIndex:indexPath.row];
    SUserViewController * controller = [[SUserViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:controller animated:YES];
}


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
/// 左右滑动所显示的文字
- (NSString *)tableView:(UITableView *)tableVie titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"干掉";
}
/// 当点击删除时，删除该条记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 如果是删除事件，则删除该条记录
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SUser * user = [_userData objectAtIndex:indexPath.row];
        [_userDB deleteUserWithId:user.uid];
        [_userData removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

@end
