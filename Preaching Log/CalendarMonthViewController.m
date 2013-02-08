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
    globals.startDate = [NSDate month];
    globals.calendar = self.tableView;
    
}



#pragma mark - MonthView Delegate & DataSource
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	[self generateRandomDataForStartDate:startDate endDate:lastDate];
	return self.dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone systemTimeZone]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
	
	
	//Save the date as a global variable
    VariableStore *globals =[VariableStore sharedInstance];
    
    NSDate *modifiedDate = [myTimeZoneDay dateByAddingTimeInterval:8*60*60];
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


- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	// this function sets up dataArray & dataDictionary
	// dataArray: has boolean markers for each day to pass to the calendar view (via the delegate function)
	// dataDictionary: has items that are associated with date keys (for tableview)
	
	NSLog(@"Delegate Range: %@ %@ %d",start,end,[start daysBetweenDate:end]);
	
    //Retrieve the events the user has saved, if this is first time create fresh
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.dataArray = [NSMutableArray array];
    self.dataDictionary = [NSMutableDictionary dictionary];
	NSDictionary *memoryDictionary = [defaults objectForKey:@"dataDictionary"];
    if (memoryDictionary == nil) {
        [defaults setObject:self.dataDictionary forKey:@"dataDictionary"];
    }
	NSDate *d = start;
    NSDate *modifiedDate;
    NSString *dateString;
	while(YES){
        modifiedDate = [d dateByAddingTimeInterval:8*60*60];
        dateString = [NSDateFormatter localizedStringFromDate:modifiedDate
                                    dateStyle:NSDateFormatterShortStyle
                                    timeStyle:NSDateFormatterNoStyle];
		if ([memoryDictionary objectForKey:dateString] != nil) {
            [self.dataDictionary setObject:[memoryDictionary objectForKey:dateString] forKey:d];
            [self.dataArray addObject:[NSNumber numberWithBool:YES]];
        }

        else
			[self.dataArray addObject:[NSNumber numberWithBool:NO]];
		
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone systemTimeZone]];
		info.day++;
        
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
        
		if([d compare:end]==NSOrderedDescending) {
            break;
        }
	}
	
}

-(void) refreshTable {
    [self.tableView reloadData];
}


@end