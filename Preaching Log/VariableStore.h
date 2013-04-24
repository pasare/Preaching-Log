//
//  VariableStore.h
//  Preaching Log
//
//  Created by Patrick Asare on 2/1/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarMonthViewController.h"

@interface VariableStore : NSObject
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSString *currentDate;
@property (nonatomic) NSDate *currentDateActual;
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchedResultsController *fetchedEventsController;
@property (nonatomic) BOOL accessGranted;
@property (nonatomic) NSArray *ABcontactsArray;
@property ABRecordID groupId;


+ (VariableStore *)sharedInstance;
- (NSDate*) startDate;
- (NSString*) currentDate;
- (NSDate*) currentDateActual;
- (NSManagedObjectContext*) context;
- (NSFetchedResultsController*) fetchedEventsController;
- (ABRecordID)groupId;
- (BOOL) accessGranted;
- (NSArray*) ABcontactsArray;
- (void) displayContacts;
@end
