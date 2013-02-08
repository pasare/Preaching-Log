//
//  VariableStore.m
//  Preaching Log
//
//  Created by Patrick Asare on 2/1/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import "VariableStore.h"

@implementation VariableStore
+ (VariableStore *)sharedInstance
{
    // the instance of this class is stored here
    static VariableStore *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
        //myInstance.loginID
    }
    // return the instance of this class
    return myInstance;
}

- (NSString*) currentDate {
    return _currentDate;
}

- (NSDate*) currentDateActual {
    return _currentDateActual;
}

- (NSDate*) startDate {
    return _startDate;
}

- (UITableView*) calendar {
    return _calendar;
}
@end
