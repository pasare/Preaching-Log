//
//  ViewWeekViewController.m
//  Preaching Log
//
//  Created by Patrick Asare on 2/5/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import "ViewWeekViewController.h"

@interface ViewWeekViewController ()

@end

@implementation ViewWeekViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableArray = [[NSMutableArray alloc] initWithCapacity:7];
    NSCalendar *calendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    
    NSDate *currentDate =[[VariableStore sharedInstance]currentDateActual];
    if (currentDate == nil)
        currentDate = [[VariableStore sharedInstance] startDate];
    
    //Add email overseer button
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Send To Overseer" style:UIBarButtonItemStyleBordered
                                                     target:self action:@selector(emailWeek)]];
    
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.toolbar setTintColor:[UIColor grayColor]];
    [self setToolbarItems:items animated:YES ];
    
    
    //Get the start of the week and the end of the week
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit|NSWeekOfMonthCalendarUnit|NSWeekCalendarUnit|NSMonthCalendarUnit fromDate:currentDate];
    NSDateComponents *dayOfWeek = [[NSDateComponents alloc] init];
    NSMutableString *currentWeek = [[NSMutableString alloc] init];
    [currentWeek appendFormat:@"Week Number %d",[weekdayComponents weekOfMonth]];
    self.navigationItem.title =currentWeek;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dataDictionary = [defaults objectForKey:@"dataDictionary"];
    
    
    NSMutableArray *sundayArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *mondayArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *tuesdayArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *wednesdayArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *thursdayArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *fridayArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *saturdayArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSArray *invalidDay = [[NSArray alloc] initWithObjects:@"Not part of this month",@"Not part of this month",@"Not part of this month", nil];
    NSArray *currentActivity = [dataDictionary objectForKey:[[VariableStore sharedInstance] currentDate]];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    //Loop through the week recording what events were done on what days
    NSMutableString *workingDate = [[NSMutableString alloc]init];
    int currentMonth = [weekdayComponents month];
    NSDate *currentDayOfWeek;
    for (int i=1; i<=7; i++) {
        
        
        //calculate the total days of this week, have to add one to current date for some reason (TimeZone issue?)
        
        [componentsToSubtract setDay: - ([weekdayComponents weekday] - (i))];
        if ([[VariableStore sharedInstance] currentDateActual] != nil) {
            currentDayOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:[[VariableStore sharedInstance] currentDateActual] options:0];
        }
        else {
            currentDayOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:[[VariableStore sharedInstance] startDate] options:0];
        }
        NSString *dateString = [NSDateFormatter localizedStringFromDate:currentDayOfWeek
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        currentActivity = [dataDictionary objectForKey:dateString];
        dayOfWeek = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:currentDayOfWeek];
       
        switch (i) {
            case 1:
                if ([dayOfWeek month] == currentMonth)
                    [sundayArray addObjectsFromArray:currentActivity];
                else
                    [sundayArray addObjectsFromArray:invalidDay];
                break;
            case 2:
                if ([dayOfWeek month] == currentMonth)
                    [mondayArray addObjectsFromArray:currentActivity];
                else
                    [mondayArray addObjectsFromArray:invalidDay];
                break;
            case 3:
                if ([dayOfWeek month] == currentMonth)
                    [tuesdayArray addObjectsFromArray:currentActivity];
                else
                    [tuesdayArray addObjectsFromArray:invalidDay];
                break;
            case 4:
                if ([dayOfWeek month] == currentMonth)
                    [wednesdayArray addObjectsFromArray:currentActivity];
                else
                    [wednesdayArray addObjectsFromArray:invalidDay];
                break;
            case 5:
                if ([dayOfWeek month] == currentMonth)
                    [thursdayArray addObjectsFromArray:currentActivity];
                else
                    [thursdayArray addObjectsFromArray:invalidDay];
                break;
            case 6:
                if ([dayOfWeek month] == currentMonth)
                    [fridayArray addObjectsFromArray:currentActivity];
                else
                    [fridayArray addObjectsFromArray:invalidDay];
                break;
            case 7:
                if ([dayOfWeek month] == currentMonth)
                    [saturdayArray addObjectsFromArray:currentActivity];
                else
                    [saturdayArray addObjectsFromArray:invalidDay];
                break;
        } 
        [workingDate setString:@""];
    }
    [_tableArray addObject:sundayArray];
    [_tableArray addObject:mondayArray];
    [_tableArray addObject:tuesdayArray];
    [_tableArray addObject:wednesdayArray];
    [_tableArray addObject:thursdayArray];
    [_tableArray addObject:fridayArray];
    [_tableArray addObject:saturdayArray];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *array = [_tableArray objectAtIndex:indexPath.section];
    if ([array count] > 0)
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = @"None";
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Sunday";
    else if (section == 1)
        return @"Monday";
    else if (section == 2)
        return @"Tuesday";
    else if (section == 3)
        return @"Wednesday";
    else if (section == 4)
        return @"Thursday";
    else if (section == 5)
        return @"Friday";
    else if (section == 6)
        return @"Saturday";
    
}

-(void) emailWeek {
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"This feature has not been implemented yet"];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
