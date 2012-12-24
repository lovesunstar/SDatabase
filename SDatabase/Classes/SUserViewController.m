//
//  SUserViewController.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SUserViewController.h"
#import "SUserDB.h"

@interface SUserViewController ()

@property (nonatomic, strong) UITextField * nameField;

@property (nonatomic, strong) UITextView * descTextView;

@property (nonatomic, strong) SUser * user;

@property (nonatomic, strong) SUserDB * userDB;

@end

@implementation SUserViewController

- (id) init {
    self = [super init];
    if (self) {
        self.user = nil;
    }
    return self;
}

- (id) initWithUser:(SUser *) user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.userDB = [[SUserDB alloc] init];
    
    if (!self.user) {
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
        self.navigationItem.leftBarButtonItem = left;
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"用户ID:%@",self.user.uid];
    }
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = right;
    
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 60, 40)];
    label1.text = @"姓名";
    label1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label1];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(80, 40, 200, 40)];
    self.nameField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nameField];
    self.nameField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.nameField.layer.cornerRadius = 10.0;
    self.nameField.layer.masksToBounds = YES;
    
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 60, 40)];
    label2.text = @"描述";
    label2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label2];
    
    self.descTextView = [[UITextView alloc] initWithFrame:CGRectMake(80, 120, 200, 80)];
    [self.view addSubview:self.descTextView];
    self.descTextView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.descTextView.layer.cornerRadius = 10.0;
    self.descTextView.layer.masksToBounds = YES;
    
    if (self.user) {
        self.nameField.text = _user.name;
        self.descTextView.text = _user.description;
    }
}

- (void) viewDidUnload {
    [super viewDidUnload];
    self.user = nil;
    self.nameField = nil;
    self.descTextView = nil;
    self.userDB = nil;
}

- (void) done:(id) sender {
    if (self.user) {
        _user.name = self.nameField.text;
        _user.description = self.descTextView.text;
        [_userDB mergeWithUser:self.user];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        SUser * user = [SUser new];
        user.name = self.nameField.text;
        user.description = self.descTextView.text;
        [_userDB saveUser:user];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}

- (void) dismiss:(id) sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
