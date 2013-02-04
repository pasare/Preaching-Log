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
    //Programatically create the toolbar
    /*self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
	self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.toolbar.items = [NSArray array];
	[self.view addSubview:self.toolbar]; */
    
    //Create the calendar
	UIViewController *calendarView = [[CalendarMonthViewController alloc] initWithSunday:YES];
    [self setupWithMainController:calendarView];
    
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
	
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-85, self.view.frame.size.width, 44);
    [toolbar setTintColor:[UIColor grayColor]];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"List Week" style:UIBarButtonItemStyleBordered
                                                     target:self action:@selector(updateList:)]];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Clear Old Events" style:UIBarButtonItemStyleBordered
                                                     target:self action:@selector(removeOldDates:)]];
    [toolbar setItems:items animated:NO];
    [self.view addSubview:toolbar];
    
    self.navigationItem.title =@"Preaching Log";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addEvent)];
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
    
    //Move to add detail screen
    AddEventViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addEventView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


@end
