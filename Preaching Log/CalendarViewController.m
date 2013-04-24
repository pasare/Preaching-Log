//
//  CalendarViewController.m
//  Preaching Log
//
//  Created by Patrick Asare on 1/28/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		//calendar = 	[[TKCalendarMonthView alloc] init];
		//calendar.delegate = self;
		//calendar.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get the contacts
    [[VariableStore sharedInstance] displayContacts];
    
    //Programatically create the toolbar
    /*self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
	self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.toolbar.items = [NSArray array];
	[self.view addSubview:self.toolbar]; */
    
    //Get the users name
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    
    if (username == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"To begin using this application please enter your name. This is a one time process." delegate:self cancelButtonTitle:@"Save" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        self.navigationItem.title =@"Preaching Log";
    }
    else {
        NSString *firstName;
        NSScanner *scanner = [NSScanner scannerWithString:username];
        [scanner scanUpToString:@" " intoString:&firstName];
        self.navigationItem.title =[NSString stringWithFormat:@"%@'s Preaching Log",firstName];
    }
    
    
    //Create the calendar
	_calendarView = [[CalendarMonthViewController alloc] initWithSunday:YES];
    [self setupWithMainController:_calendarView];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupWithMainController:(UIViewController*)controller{
	[self.mainController.view removeFromSuperview];
	self.mainController = controller;
	
	CGFloat h = self.toolbar.frame.size.height;
	
	CGRect r = CGRectMake(0, h, self.view.frame.size.width, self.view.frame.size.height-h);
	self.mainController.view.frame = r;
	[self.mainController viewWillAppear:NO];
	[self.view addSubview:self.mainController.view];
	[self.mainController viewDidAppear:NO];
	
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    //Create bottom bar items
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"List Week" style:UIBarButtonItemStyleBordered
                                                     target:self action:@selector(viewWeek)]];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Clear Old Events" style:UIBarButtonItemStyleBordered
                                                     target:self action:@selector(removeOldEvents)]];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Contacts Log" style:UIBarButtonItemStyleBordered
                                                     target:self action:@selector(viewContactsLog)]];
    
    [self.navigationController.toolbar setTintColor:[UIColor grayColor]];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:items animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addEvent)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteEvent)];
	if(self.currentPopoverController!=nil){
		
		UIBarButtonItem *item = [[self.toolbar items] objectAtIndex:0];
		
		
		NSMutableArray *items = [NSMutableArray array];
		[items addObject:item];
        
		if(self.mainController.toolbarItems!=nil){
			[items addObjectsFromArray:self.mainController.toolbarItems];
		}
		[self.toolbar setItems:items animated:YES];
        
		
	}else{
		[self.toolbar setItems:self.mainController.toolbarItems];
	}
}

- (void) splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	barButtonItem.title = @"Preaching Log";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.currentPopoverController = pc;
}
- (void) splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
	NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.currentPopoverController = nil;
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
    
}

-(void) addEvent {
    //Keep track of the date that was selected
    
    //check to ensure a date is selected
        //Move to add detail screen
    AddEventViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addEventView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

//delete the days events
-(void)deleteEvent {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Delete Events"
                          message:@"This will erase the days events"
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Delete", nil];
    [alert show];
}

-(void)confirmDeleteEvent {
    NSError *error;
    NSManagedObjectContext *context = [[VariableStore sharedInstance] context];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(date == %@)", [[VariableStore sharedInstance] currentDateActual]];
    [request setPredicate:predicate];
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        //Deal with failure
    }
    else {
        if (results.count > 0) {
            for (Event * event in results){
                [context deleteObject:event];
            }
            //Save changes
            if (![context save:&error]) {
                // Handle the error.
            }
            
            int64_t delayInSeconds = .7;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DataSaved" object:nil];
               [[TKAlertCenter defaultCenter] postAlertWithMessage:@"The events have been deleted sucessfully!"];
            });
        
        }
        else {
            int64_t delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"There are no events to delete"];
            });
        }
    }
}

-(void) viewWeek {
    ViewWeekViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewWeek"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) removeOldEvents {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Warning!"
                          message:@"This will erase all events older than 30 days"
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Confirm", nil];
    [alert show];
    
    
    //This clears all saved dates
    /*NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
     [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];*/
     
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Confirm"]) {
        [self confirmRemove];
    }
    else if([title isEqualToString:@"Save"]) {
        [self confirmSaveUserName:alertView];
    }
    if ([title isEqualToString:@"Delete"]) {
        [self confirmDeleteEvent];
    }
    else if([title isEqualToString:@"Cancel"]){
        
    }
}

-(void) confirmSaveUserName:(UIAlertView *) alertView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    [defaults setObject:[[alertView textFieldAtIndex:0] text] forKey:@"username"];
    NSString *firstName;
    NSScanner *scanner = [NSScanner scannerWithString:[[alertView textFieldAtIndex:0] text]];
    [scanner scanUpToString:@" " intoString:&firstName];
    self.navigationItem.title =[NSString stringWithFormat:@"%@'s Preaching Log",firstName];
}
-(void) confirmRemove {
    NSError *error;
    NSManagedObjectContext *context = [[VariableStore sharedInstance] context];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(date == %@)", date];
    //[request setPredicate:predicate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setTimeStyle:NSDateFormatterNoStyle];
    
    NSTimeInterval secondsBetween;
    int numberOfDays;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        //Deal with failure
    }
    else {
        if (results.count > 0) {
            for (Event * event in results){
                secondsBetween = [[NSDate date] timeIntervalSinceDate: event.date];
                numberOfDays = secondsBetween / 86400;
                if (numberOfDays >= 30)
                    [context deleteObject:event];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataSaved" object:nil];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"The events have been successfully removed"];
}

-(void) viewContactsLog {
    [self performSegueWithIdentifier: @"ContactsLogSegue" sender: self];
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
