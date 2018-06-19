//
// AuthorManager.m
//
// Copyright (c) 2014. All rights reserved.
//

#import "ChargingStationManager.h"
#import "UserSessionInfo.h"
#import "Utils.h"
#import "ChargingStation.h"
#import "vipertestAppDelegate.h"

@implementation ChargingStationManager


- (void)doesLocalDBNeedUpdate:(void (^)(BOOL serverDBChanged, NSError *error))completionHandler;
{
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:STAGE_DB_PATH]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil)
            {
                //All is good.  We get the updated file from server.  Here are the steps we do now.
                
                //********* STEP 1 *********
                //Check if there is any error during the seiralization process.
                //If there are any errors found, report them.
                
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error != nil)
                {
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:@"The updated database is invalid. Please contact support." forKey:@"errmessage"];
                    
                    error = [NSError errorWithDomain:error.description code:error.code userInfo:details];
                    completionHandler(nil, error);
                    return;
                }
                
                //********* STEP 2 *********
                //Check if there is there is a mismatch in versions.
                //Only then proceed for the database update.
                
                NSString *version = dataDict[@"version"];
                if ([version isEqualToString:userSession.dbVersion])
                {
                    completionHandler(NO, error);
                }
                else
                {
                    completionHandler(YES, error);
                }
            }
            else
            {
                    completionHandler(NO, error);
            }
    }] resume];
}

- (void)downloadUpdatedStationDB:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler
{
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:STAGE_DB_PATH]
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (error == nil)
         {
             //All is good.  We get the updated file from server.  Here are the steps we do now.
             
             //********* STEP 1 *********
             //Check if there is any error during the seiralization process.
             //If there are any errors found, report them.
             
             NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             if (error != nil)
             {
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:@"The updated database is invalid. Please contact support." forKey:@"errmessage"];
                 
                 error = [NSError errorWithDomain:error.description code:error.code userInfo:details];
                 completionHandler(nil, error);
                 return;
             }
             
             //********* STEP 2 *********
             //Check if there is there is a mismatch in versions.
             //Only then proceed for the database update.
             
             NSString *version = dataDict[@"version"];
             if ([version isEqualToString:userSession.dbVersion])
             {
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:@"Your database is already upto date. Nothing to update!" forKey:@"errmessage"];
                 
                 error = [NSError errorWithDomain:@"errorDomain" code:250 userInfo:details];
                 completionHandler(nil, error);
                 return;
             }
             
             //********* STEP 3 *********
             //Check if 'Documents' folder actually has a database.  This is just a precautionary step.  We will always have the DB in the documents folder.
             //If there is no DB - then copy a DB from resource folder.
             
             NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
             NSString *resourcePathOfDB = [resourcePath stringByAppendingPathComponent:@"ChargingStations.JSON"];
             
             NSError *err;
             // Check to see if the JSON database file already exists in Documents folder
             bool databaseExists = [[NSFileManager defaultManager] fileExistsAtPath:userSession.databasePath];
             
             // If the DB does not exist in the documents folder system, then copy the resource DB
             if (!databaseExists)
             {
                 //Unlikely to get here
                 
                 NSLog(@"Replacing the Resource DB to documents folder...");
                 // Copy the database from the package to the users filesystem
                 [[NSFileManager defaultManager] copyItemAtPath:resourcePathOfDB toPath:userSession.databasePath error:&err];
             }
             
             //********* STEP 4 *********
             //Update the session with updated stations cache.
             
             //New version found - Update Session
             userSession.dbVersion = version;
             
             NSArray *arrayOfStations = dataDict[@"data"];
             NSMutableArray *stations = [self serializeJSON:arrayOfStations];
             
             userSession.stationsCache = stations;
             
             //********* STEP 6 *********
             //Remove the current database from the Documents folder
             
             NSError *errRemove;
             [[NSFileManager defaultManager] removeItemAtPath:userSession.databasePath error:&errRemove];
             
             NSLog(@"Old Database removed");
             
             //********* STEP 7 *********
             // Finally save the updated new Database!  Phew!!
             BOOL success = [data writeToFile:userSession.databasePath atomically:YES];
             
             if (!success)
             {
                 //Crapola. Some problem. Lets revert the database from Backup folder.
                 
                 //Delete any bad file if found
                 if ([[NSFileManager defaultManager]  fileExistsAtPath:userSession.databasePath] == YES) {
                     NSError *errDel;
                     [[NSFileManager defaultManager]  removeItemAtPath:userSession.databasePath error:&errDel];
                 }
                 
                 // Revert the database from the backup folder to the documents folder
                 [[NSFileManager defaultManager] copyItemAtPath:userSession.databaseBackupPath toPath:userSession.databasePath error:&err];
                 
                 NSLog(@"Error writing updated DB");
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:@"There was an error updating the database. Reverted to current version." forKey:@"errmessage"];
                 
                 error = [NSError errorWithDomain:@"errorDomain" code:250 userInfo:details];
                 completionHandler(nil, error);
                 return;
             }
             
             //********* STEP 8 *********
             // Finally Just double check to see if the new database file is available in Documents folder
             BOOL databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:userSession.databasePath];
             
             if (!databaseAlreadyExists)
             {
                 // Revert the database from the backup folder to the documents folder
                 [[NSFileManager defaultManager] copyItemAtPath:userSession.databaseBackupPath toPath:userSession.databasePath error:&err];
                 
                 NSLog(@"Error writing updated DB at last step");
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:@"There was an error updating the database. Reverted to current version." forKey:@"errmessage"];
                 
                 error = [NSError errorWithDomain:@"errorDomain" code:250 userInfo:details];
                 completionHandler(nil, error);
                 return;
             }
             
             //********* STEP 9 *********
             //Make a backup of the new database into the backup folder
             
             //Delete the old backup file if found
             if ([[NSFileManager defaultManager]  fileExistsAtPath:userSession.databaseBackupPath] == YES) {
                 NSError *errBackup;
                 [[NSFileManager defaultManager]  removeItemAtPath:userSession.databaseBackupPath error:&errBackup];
             }
             
             NSError *errCopy;
             // Copy the database from the documents to the backup folder
             [[NSFileManager defaultManager] copyItemAtPath:userSession.databasePath toPath:userSession.databaseBackupPath error:&errCopy];
             
             NSLog(@"Updated Database created");
             
             completionHandler(stations, nil);
         }
         else
         {
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:@"Could not download the database.  Please try again after sometime." forKey:@"errmessage"];
             
             error = [NSError errorWithDomain:error.description code:error.code userInfo:details];
             completionHandler(nil, error);
             return;
         }
    }] resume];
}

- (void)getStationsNearCordinate:(CLLocationCoordinate2D)coordinates
                      completion:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler
{
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSMutableArray *stations = userSession.stationsCache;
    NSMutableArray *matchingStations = [[NSMutableArray alloc] init];
    
    if (stations == nil)
    {
        //Just in case
        
        NSString *jsonPath = userSession.databasePath;
        
        NSError *error = nil;;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:kNilOptions error:&error];
    
        if (error != nil)
        {
            completionHandler(nil, error);
            return;
        }
        
        NSArray *arrayOfStations = dataDict[@"data"];
        
        stations = [self serializeJSON:arrayOfStations];
    }
    
    //CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
    
    //double radius = userSession.distanceToBeCovered;
    
    for(ChargingStation *station in stations)
    {
        //CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:[station.lattitude floatValue] longitude:[station.longitude floatValue]];

        //CLLocationDistance meters = [stationLocation distanceFromLocation:userLocation];

        [matchingStations addObject:station];
        
        /*if (meters <= radius)
        {
            [matchingStations addObject:station];
        }*/
    }
    
    BOOL isSuccess = YES;
    
    if (!isSuccess)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not"
                                   " load stations as there are no stations in the inventory."};
        
        NSError *error = [NSError errorWithDomain:CHARGING_STATION_ERRORDOMAIN
                                             code:StationNotLoadedError
                                         userInfo:userInfo];
        completionHandler(nil, error);
    }
    else
    {
        completionHandler(matchingStations, nil);
    }
}



- (void) getAllStations:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler
{
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSString *jsonPath = userSession.databasePath;
    
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (error != nil)
    {
        completionHandler(nil, error);
        return;
    }
    
    NSString *version = dataDict[@"version"];
    userSession.dbVersion = version;
    
    NSArray *arrayOfStations = dataDict[@"data"];
    
    NSMutableArray *stations = [self serializeJSON:arrayOfStations];
    
    if (stations == nil)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not"
                                   " load stations as there are no stations in the inventory."};
        
        NSError *error = [NSError errorWithDomain:CHARGING_STATION_ERRORDOMAIN
                                             code:StationNotLoadedError
                                         userInfo:userInfo];
        
        completionHandler(nil, error);
    }
    else
    {
        completionHandler(stations, nil);
    }
}

- (void)getAllCommentsForStationId:(NSString *)stationId
                        completion:(void (^)(NSMutableArray *commentList, NSError *error))completionHandler
{
    NSMutableArray *commentArray = [[NSMutableArray alloc]init];
    vipertestAppDelegate *appDel = (vipertestAppDelegate *)[[UIApplication sharedApplication] delegate];
    FIRDatabaseReference *ref =appDel.ref;
    
    [[[ref child:@"comments"] child:stationId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if(snapshot.childrenCount==0){
            completionHandler(commentArray, nil);
        }
        else
        {
         
            NSDictionary *dictResponse = (NSDictionary *) snapshot.value;
            //NSArray *arrResponse = (NSArray *) snapshot.value;
            //NSString* str = arrResponse[0];
            for (NSDictionary* dict in [dictResponse allValues]) {

                NSString *commentId = [dict objectForKey:@"id"];
                NSString *comment = [dict objectForKey:@"comment"];
                NSString *addedByUser = [dict objectForKey:@"addedByUser"];
                NSString *reactionString = [dict objectForKey:@"reaction"];
                NSString *dateLong = [dict objectForKey:@"date"];
                
                long dateComment = [dateLong longLongValue];
                
                Comment *commentObj = [Comment alloc];
                commentObj.commentId = commentId;
                commentObj.comment = comment;
                commentObj.userName = addedByUser;
                commentObj.date = dateComment;
                commentObj.reaction = reactionString.boolValue;
                
                [commentArray addObject:commentObj];
            }
            
            completionHandler(commentArray, nil);
        }
        
        // Get user value
        //User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
        
        // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}



- (void)addCommentForStation:(Comment *)comment
                   stationId: (long) stationId
                  completion:(void (^)(NSError *error))completionHandler
{
    NSNumber *reaction = [NSNumber numberWithInt:comment.reaction];
    NSNumber *dateOfComment = [NSNumber numberWithLong:comment.date];
    
    NSDictionary *commentData = @{ @"addedByUser" : comment.userName, @"comment" : comment.comment, @"date" : dateOfComment, @"id" : comment.commentId, @"reaction" : reaction};
    
    //NSDictionary *commentDataWithID = @{ comment.commentId : commentData};
    
    vipertestAppDelegate *appDel = (vipertestAppDelegate *)[[UIApplication sharedApplication] delegate];
    FIRDatabaseReference *ref =appDel.ref;
    
    NSString *stationIdString = [NSString stringWithFormat:@"%ld", stationId];
    //NSDictionary *commentDataWithStationID = @{ stationIdString : commentDataWithID};
    
    FIRDatabaseReference *commentsRef = [[[ref child:@"comments"] child:stationIdString] child:comment.commentId];
    // The value is null
    [commentsRef setValue:commentData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error == nil)
        {
            completionHandler(nil);
        }
        else
        {
            completionHandler(error);
        }
    }];

    
}

- (void)updateCommentForStation:(Comment *)comment
                    stationId: (long) stationId
                    completion:(void (^)(NSError *error))completionHandler
{
    NSNumber *reaction = [NSNumber numberWithInt:comment.reaction];
    NSNumber *dateOfComment = [NSNumber numberWithLong:comment.date];
    
    NSDictionary *commentData = @{ @"addedByUser" : comment.userName, @"comment" : comment.comment, @"date" : dateOfComment, @"id" : comment.commentId, @"reaction" : reaction};
    
    //NSDictionary *commentDataWithID = @{ comment.commentId : commentData};
    
    vipertestAppDelegate *appDel = (vipertestAppDelegate *)[[UIApplication sharedApplication] delegate];
    FIRDatabaseReference *ref =appDel.ref;
    
    NSString *stationIdString = [NSString stringWithFormat:@"%ld", stationId];
    //NSDictionary *commentDataWithStationID = @{ stationIdString : commentDataWithID};
    
    FIRDatabaseReference *commentsRef = [[[ref child:@"comments"] child:stationIdString] child:comment.commentId];
    // The value is null
    [commentsRef updateChildValues:commentData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error == nil)
        {
            completionHandler(nil);
        }
        else
        {
            completionHandler(error);
        }
    }];
}

- (void)deleteCommentForStation:(Comment *)comment
                      stationId: (long) stationId
                     completion:(void (^)(NSError *error))completionHandler
{
    vipertestAppDelegate *appDel = (vipertestAppDelegate *)[[UIApplication sharedApplication] delegate];
    FIRDatabaseReference *ref =appDel.ref;
    
    NSString *stationIdString = [NSString stringWithFormat:@"%ld", stationId];
    //NSDictionary *commentDataWithStationID = @{ stationIdString : commentDataWithID};
    
    FIRDatabaseReference *commentsRef = [[[ref child:@"comments"] child:stationIdString] child:comment.commentId];
    // The value is null
    [commentsRef removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil)
        {
            completionHandler(nil);
        }
        else
        {
            completionHandler(error);
        }
    }];
}



//private
- (NSMutableArray *) serializeJSON:(NSArray *)arrayOfStations
{
    if (arrayOfStations.count <= 0)
        return nil;
    
    NSMutableArray *stations = [[NSMutableArray alloc] initWithCapacity:arrayOfStations.count];
    
    for (NSDictionary *dict in arrayOfStations) {
    
        ChargingStation *station = [[ChargingStation alloc]init];
        station.stationid = dict[@"stationid"];
        station.name = dict[@"name"];
        station.contact = dict[@"contact"];
        station.address = dict[@"address"];
        station.phones = dict[@"phones"];
        station.pricing = dict[@"pricing"];
        station.notes = dict[@"notes"];
        station.type = dict[@"type"];
        station.isValidated = dict[@"isValidated"];
        station.lattitude = dict[@"lattitude"];
        station.longitude = dict[@"longitude"];
        
        [stations addObject:station];
    }
    
    return stations;
}


@end
