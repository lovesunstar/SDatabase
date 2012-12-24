//
//  SUserDB.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SUserDB.h"

#define kUserTableName @"SUser"

@implementation SUserDB

- (id) init {
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
        _db = [SDBManager defaultDBManager].dataBase;
        
    }
    return self;
}

/**
 * @brief 创建数据库
 */
- (void) createDataBase {
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kUserTableName]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        [AppDelegate showStatusWithText:@"数据库已经存在" duration:2];
    } else {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE SUser (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, name VARCHAR(50), description VARCHAR(100))";
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            [AppDelegate showStatusWithText:@"数据库创建失败" duration:2];
        } else {
            [AppDelegate showStatusWithText:@"数据库创建成功" duration:2];
        }
    }
}

/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */
- (void) saveUser:(SUser *) user {
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO SUser"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
    if (user.name) {
        [keys appendString:@"name,"];
        [values appendString:@"?,"];
        [arguments addObject:user.name];
    }
    if (user.description) {
        [keys appendString:@"description,"];
        [values appendString:@"?,"];
        [arguments addObject:user.description];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    NSLog(@"%@",query);
    [AppDelegate showStatusWithText:@"插入一条数据" duration:2.0];
    [_db executeUpdate:query withArgumentsInArray:arguments];
}

/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
- (void) deleteUserWithId:(NSString *) uid {
    NSString * query = [NSString stringWithFormat:@"DELETE FROM SUser WHERE uid = '%@'",uid];
    [AppDelegate showStatusWithText:@"删除一条数据" duration:2.0];
    [_db executeUpdate:query];
}

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */
- (void) mergeWithUser:(SUser *) user {
    if (!user.uid) {
        return;
    }
    NSString * query = @"UPDATE SUser SET";
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    // xxx = xxx;
    if (user.name) {
        [temp appendFormat:@" name = '%@',",user.name];
    }
    if (user.description) {
        [temp appendFormat:@" description = '%@',",user.description];
    }
    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE uid = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],user.uid];
    NSLog(@"%@",query);
    
    [AppDelegate showStatusWithText:@"修改一条数据" duration:2.0];
    [_db executeUpdate:query];
}

/**
 * @brief 模拟分页查找数据。取uid大于某个值以后的limit个数据
 *
 * @param uid
 * @param limit 每页取多少个
 */
- (NSArray *) findWithUid:(NSString *) uid limit:(int) limit {
    NSString * query = @"SELECT uid,name,description FROM SUser";
    if (!uid) {
        query = [query stringByAppendingFormat:@" ORDER BY uid DESC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" WHERE uid > %@ ORDER BY uid DESC limit %d",uid,limit];
    }

    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
	while ([rs next]) {
        SUser * user = [SUser new];
        user.uid = [rs stringForColumn:@"uid"];
        user.name = [rs stringForColumn:@"name"];
        user.description = [rs stringForColumn:@"description"];
        [array addObject:user];
	}
	[rs close];
    return array;
}

@end
