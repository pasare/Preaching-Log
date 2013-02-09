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

+ (VariableStore *)sharedInstance;
- (NSDate*) startDate;
- (NSString*) currentDate;
- (NSDate*) currentDateActual;
@end
