//
//  DatabaseController.m
//
// Copyright (c) 2014. All rights reserved.
//

#import "DatabaseController.h"
#import "UserSessionInfo.h"

@implementation DatabaseController

- (id)init {
    
    self = [super init];
    
    self.db = nil;
    [self setUp];
    
    return self;
}


- (void) setUp
{
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSString *dbPath = userSession.databasePath;

    self.db = [FMDatabase databaseWithPath:dbPath];
}

- (BOOL) openDB
{
    if (![self.db open]) {
        NSLog(@"Could not open db.");
        
        return NO;
    }
    return YES;
}

- (void) closeDB
{
    if (self.db == nil)
        return;
    
    
    [self.db close];
}


- (void)executeUpdate: (NSString *)inputquery
{
    dispatch_async
    (dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
        @autoreleasepool
        {
            [self.db beginTransaction];
            [self.db executeUpdate:inputquery];
            [self.db commit];
        }
    });
    
    return;
}

- (BOOL)executeUpdateSyncronous: (NSString*)query
{
    BOOL success;
    
    success = [self.db executeUpdate:query];
    
    return success;
}

- (BOOL)executeUpdateWithDictSyncronous: (NSString*)query withParameterDictionary:(NSDictionary *)dictionaryArgs
{
    BOOL success;
    
    success = [self.db executeUpdate:query withParameterDictionary:dictionaryArgs];

    return success;
}

- (long) getLastInsertId
{
    return self.db.lastInsertRowId;
}


- (FMResultSet *)executeQuery: (NSString *)inputquery
{
    FMResultSet *rs = [self.db executeQuery:inputquery];
    
    return rs;
}

/*
 Bulk query can be in this format
 
 NSString *sql = @"create table bulktest1 (id integer primary key autoincrement, x text);"
 "create table bulktest2 (id integer primary key autoincrement, y text);"
 "create table bulktest3 (id integer primary key autoincrement, z text);"
 "insert into bulktest1 (x) values ('XXX');"
 "insert into bulktest2 (y) values ('YYY');"
 "insert into bulktest3 (z) values ('ZZZ');";
 
 */

- (BOOL)executeBulkStatements: (NSString *)bulkStatementQuery
{
    BOOL success;
    
    success = [self.db executeStatements:bulkStatementQuery];
    
    /*NSString *sql = @"create table bulktest1 (id integer primary key autoincrement, x text);"
    "create table bulktest2 (id integer primary key autoincrement, y text);"
    "create table bulktest3 (id integer primary key autoincrement, z text);"
    "insert into bulktest1 (x) values ('XXX');"
    "insert into bulktest2 (y) values ('YYY');"
    "insert into bulktest3 (z) values ('ZZZ');";
    
    success = [self.db executeStatements:sql];
    
    
    sql = @"select count(*) as count from bulktest1;"
    "select count(*) as count from bulktest2;"
    "select count(*) as count from bulktest3;";
    
    success = [self.db executeStatements:sql withResultBlock:^int(NSDictionary *dictionary) {
        NSInteger count = [dictionary[@"count"] integerValue];
        XCTAssertEqual(count, 1, @"expected one record for dictionary %@", dictionary);
        return 0;
    }];
    
    
    sql = @"drop table bulktest1;"
    "drop table bulktest2;"
    "drop table bulktest3;";
    
    success = [self.db executeStatements:sql];*/
    
    return success;
}

@end
