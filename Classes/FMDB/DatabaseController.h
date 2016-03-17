//
//  DatabaseController.h
//
// Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseController : NSObject
{
    
}

@property FMDatabase *db;

- (void) closeDB;

- (BOOL) openDB;

- (long) getLastInsertId;

- (void)executeUpdate: (NSString *)inputquery;

- (BOOL)executeUpdateSyncronous: (NSString*)query;

- (BOOL)executeUpdateWithDictSyncronous: (NSString*)query withParameterDictionary:(NSDictionary *)dictionaryArgs;

- (FMResultSet *)executeQuery: (NSString *)inputquery;

/*
 Bulk query can be in this format 
 
 NSString *sql = @"create table bulktest1 (id integer primary key autoincrement, x text);"
 "create table bulktest2 (id integer primary key autoincrement, y text);"
 "create table bulktest3 (id integer primary key autoincrement, z text);"
 "insert into bulktest1 (x) values ('XXX');"
 "insert into bulktest2 (y) values ('YYY');"
 "insert into bulktest3 (z) values ('ZZZ');";
 
 */

- (BOOL)executeBulkStatements: (NSString *)bulkStatementQuery;

@end
