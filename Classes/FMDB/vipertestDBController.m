//
//  vipertestDBController.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "vipertestDBController.h"
#import "FMDatabase.h"
#import "Utils.h"


@implementation vipertestDBController

- (id)init {
    
    self = [super init];
    
    dbController = [[DatabaseController alloc] init];
    //mapper = [[ClassXMLMapper alloc] init];
    
    
    
    return self;
}


/********************************************************************************************************************************
 This method queries the database and returns list of all contacts
 The database call is executed asyncronously
 ********************************************************************************************************************************/

- (BOOL) getAllContacts;
{
    dispatch_async
    (dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
     {
         NSMutableArray *contactsInfo;
         @autoreleasepool
         {
             contactsInfo = [self getContactDataInBackgroundThread];
         }
         
         dispatch_async(dispatch_get_main_queue(),^
         {
             //Send pets data into our main thread
             
             if (contactsInfo == nil)
             {
                 //error callback

                 [self.delegate dbFailureCallback:self returnError:@"Error getting pet information." operation:@"getAllContacts"];
             }
             else
             {
                 //success call back
                 
                 [self.delegate dbDataSuccessCallback:self returnData:contactsInfo operation:@"getAllContacts"];
             }
         });
     });
    
     return YES;
}

//Helper method that runs in background
- (NSMutableArray *) getContactDataInBackgroundThread
{
    NSMutableArray *reqInfo = [[NSMutableArray alloc] init];
    
    if (![dbController openDB])
    {
        // "Could not open db.
        return nil;
    }
    
    NSString *strQuery = @"SELECT phonenumber, usingvipertest, isFavorite, id, contactId , name FROM contacts";
    
    FMResultSet *resultSet = [dbController executeQuery:strQuery];
    
    while ([resultSet next])
    {
        /*ContactRecord *rec = [[ContactRecord alloc] init];
        
        NSString *phoneNumber = [resultSet stringForColumnIndex:0];
        BOOL usingvipertest = [resultSet boolForColumnIndex:1];
        BOOL isFavorite = [resultSet boolForColumnIndex:2];
        int32_t contactId = [resultSet intForColumnIndex:4];
        NSString *fullName = [resultSet stringForColumnIndex:5];
        
        rec.phoneNumber = phoneNumber;
        rec.isAppInstalled = usingvipertest;
        rec.isFavorite = isFavorite;
        rec.contactId = contactId;
        rec.contactFullName = fullName;
        
        [reqInfo addObject:rec];*/
    }
    
    [resultSet close];
    
    if ([dbController.db hasOpenResultSets])
    {
        return nil;
    }
    
    if ([dbController.db hadError])
    {
        return nil;
    }
    
    [dbController closeDB];
    
    return reqInfo;
}

/********************************************************************************************************************************
 This method creates set of Contacts in the database
 
 ********************************************************************************************************************************/
- (BOOL)createContacts : (NSMutableArray *)newContacts;
{
    dispatch_async
    (dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
     {
         BOOL status;
         
         @autoreleasepool
         {
             status = [self createContactsInBackground:newContacts];
         }
         
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            //Update our main thread
                            
                            //Send pets data into our main thread
                            
                            if (status == NO)
                            {
                                //error callback
                                
                                [self.delegate dbFailureCallback:self returnError:@"Error creating contacts information." operation:@"createContacts"];
                            }
                            else
                            {
                                //success call back
                                
                                [self.delegate dbDataSuccessCallback:self returnData:nil operation:@"createContacts"];
                            }
                        });
     });
    
    return YES;
}


//Helper method to create Petdata in background thread
- (BOOL)createContactsInBackground : (NSMutableArray *)newContacts;
{
    [dbController openDB];
    
    [dbController.db beginTransaction];
    
    BOOL foundError = NO;
    /*for (ContactRecord *rec in newContacts)
    {
        NSMutableString *fullName;
        fullName = [[NSMutableString alloc] initWithString:rec.contactFirstName];
        [fullName appendString:@" "];
        [fullName appendString:rec.contactLastName];
        
        //Enter into Contacts table
        BOOL status = [dbController.db executeUpdate:@"insert into contacts (phonenumber, usingvipertest, isFavorite, contactId, name) values (?, ?, ?, ?, ?)", rec.phoneNumber, [NSNumber numberWithBool:rec.isAppInstalled],  [NSNumber numberWithBool:rec.isFavorite], [NSNumber numberWithInt:rec.contactId], fullName];
    
        if ((status == NO) || [dbController.db hadError])
        {
            foundError = YES;
        
            break;
        }
    
        long newContactId = [dbController getLastInsertId];
    
        if (newContactId <= 0)
        {
            foundError = YES;
        
            break;
        }
    }*/
    
      
    if (foundError == YES)
    {
        [dbController.db rollback];
        
        return NO;
    }
    
    [dbController.db commit];
    
    [dbController closeDB];
    
    return YES;
}



@end
