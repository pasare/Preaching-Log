//
//  CalendarMonthViewController.h
//  Preaching Log
//
//  Created by Patrick Asare on 1/30/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//
#import <TapkuLibrary/TapkuLibrary.h>
#import <UIKit/UIKit.h>
#import "VariableStore.h"


@interface CalendarMonthViewController : TKCalendarMonthTableViewController

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableDictionary *dataDictionary;
@property (strong,nonatomic) TKCalendarMonthView *monthView;
@property (strong,nonatomic) NSDate *startDate;
@property (strong,nonatomic) NSDate *lastDate;

- (void) generateTableMarks:(NSDate*)start endDate:(NSDate*)end;

@end
