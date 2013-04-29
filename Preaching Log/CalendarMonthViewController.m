//
//  CalendarMonthViewController.m
//  Preaching Log
//
//  Created by Patrick Asare on 1/30/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import "CalendarMonthViewController.h"


@implementation CalendarMonthViewController

#pragma mark - View Lifecycle
- (void) viewDidLoad{
	[super viewDidLoad];
	[self.monthView selectDate:[NSDate month]];
    VariableStore *globals =[VariableStore sharedInstance];
    NSDate *modifiedDate = [[NSDate month] dateByAddingTimeInterval:4*60*60];
    globals.startDate = modifiedDate;
    
    //Notification for when table needs to be updated
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSaved:)
                                                 name:@"DataSaved" object:nil];
    
}



#pragma mark - MonthView Delegate & DataSource
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
    [self generateTableMarks:startDate endDate:lastDate];
	return self.dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	
	//Save the date as a global variable
    VariableStore *globals =[VariableStore sharedInstance];
    
    NSDate *modifiedDate = date;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:modifiedDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    globals.currentDate = dateString;
    globals.currentDateActual = modifiedDate;
	[self.tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
	[super calendarMonthView:mv monthDidChange:d animated:animated];
	[self.tableView reloadData];
}


#pragma mark - UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *ar = [self.dataDictionary objectForKey:[self.monthView dateSelected]];
	if(ar == nil) return 0;
	return [ar count];
}
- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	
    
	NSArray *ar = [self.dataDictionary objectForKey:[self.monthView dateSelected]];
	cell.textLabel.text = [ar objectAtIndex:indexPath.row];
	
    return cell;
	
}


- (void) generateTableMarks:(NSDate*)start endDate:(NSDate*)end{
	// this function sets up dataArray & dataDictionary
	// dataArray: has boolean markers for each day to pass to the calendar view (via the delegate function)
	// dataDictionary: has items that are associated with date keys (for tableview)
	
	NSLog(@"Delegate Range: %@ %@ %d",start,end,[start daysBetweenDate:end]);
	
    //Retrieve the events the user has saved
    NSError *error;
    NSManagedObjectContext *context = [[VariableStore sharedInstance] context];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    
    self.dataArray = [NSMutableArray array];
    self.dataDictionary = [NSMutableDictionary dictionary];
	NSDate *d = start;
    NSDate *modifiedDate;
	while(YES){
        modifiedDate = d;
        //search for this date
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(date == %@)", modifiedDate];
        [request setPredicate:predicate];
        NSArray *results = [context executeFetchRequest:request error:&error];
        if (error != nil) {
            //Deal with failure
        }
        else {
            if (results.count > 0) {
                NSMutableArray *titlesArray = [[NSMutableArray alloc] init];
                for (Event *event in results) {
                    [titlesArray addObject:event.title];
                }
                [self.dataDictionary setObject:titlesArray forKey:d];
                [self.dataArray addObject:[NSNumber numberWithBool:YES]];
            }
            else
                [self.dataArray addObject:[NSNumber numberWithBool:NO]];
        }

		NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
		info.day++;
        
		d = [NSDate dateWithDateComponents:info];
        
		if([d compare:end]==NSOrderedDescending) {
            break;
        }
	}
	
}

- (void) dataSaved:(NSNotification *)notification{
    [self.monthView reloadData];
    
}


@end