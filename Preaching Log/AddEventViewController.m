//
//  addEventViewController.m
//  Preaching Log
//
//  Created by Patrick Asare on 1/30/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import "addEventViewController.h"

@interface AddEventViewController ()
@property (nonatomic) NSMutableArray *eventsArray;
@property (weak,nonatomic) UILabel *currentLabel;
@end

@implementation AddEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initalize the view
    _eventsArray = [[NSMutableArray alloc] init];
    [_eventsArray addObject:@"None"];
    [_eventsArray addObject:@"Door to Door Preaching"];
    [_eventsArray addObject:@"Street Preaching"];
    [_eventsArray addObject:@"Acquaintance Preaching"];
    [_eventsArray addObject:@"Public Preaching"];
    [_eventsArray addObject:@"Visit"];
    [_eventsArray addObject:@"Education"];
    [_eventsArray addObject:@"Activity for Church"];
    [_eventsArray addObject:@"Church Gathering/Event"];
    [_eventsArray addObject:@"Offical Trip"];
    [_eventsArray addObject:@"Counseling"];
    [_eventsArray addObject:@"Administration"];
    [_eventsArray addObject:@"Head Office Work"];
    [_eventsArray addObject:@"Other(Specify)"];
    
    [self refreshView];
    
    //Notification for when table needs to be updated
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSaved:)
                                                 name:@"DataSaved" object:nil];
    //Notification for when the view is changed via swipe
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataReloaded:)
                                                 name:@"DataReloaded" object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Save Events" style:UIBarButtonItemStylePlain
                                              target:self action:@selector(saveEventCheck)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshView {
   
    _eventsTable.backgroundColor = [UIColor clearColor];
    [_eventsTable setBackgroundView:nil];
    
    if ([[VariableStore sharedInstance] currentDate] != nil)
        self.navigationItem.title = [[VariableStore sharedInstance] currentDate];
    else
        self.navigationItem.title = @"Add Event";
	
    //Contacts table set up
    _contactsArray = [[NSArray alloc] init];
    _contactsTable.backgroundColor = [UIColor clearColor];
    [_contactsTable setBackgroundView:nil];
    
    //get contacts
    [self getContacts];
    
    //get events
    _dailyEventsDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self getEvents];
}

-(void) dataSaved:(NSNotification *)notification{
    if ([[VariableStore sharedInstance] accessGranted]){
        [self getContacts];
        [[VariableStore sharedInstance]displayContacts];
        [_contactsTable reloadData];
    }
}

-(void) dataReloaded:(NSNotification *) notification {
    if ([[VariableStore sharedInstance] accessGranted]){
        [self getContacts];
        [[VariableStore sharedInstance]displayContacts];
        [_contactsTable reloadData];
        [_eventsTable reloadData];
    }
}

- (IBAction)moveOneDateLeft:(id)sender {
    //increase the date by one and reload the view
    NSDate *date = [[VariableStore sharedInstance] currentDateActual];
    if (date == nil) {
        date = [[VariableStore sharedInstance] startDate];
        
    }
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *dateToBeIncremented = [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];
    [[VariableStore sharedInstance] setCurrentDateActual:dateToBeIncremented];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:dateToBeIncremented
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    [[VariableStore sharedInstance]setCurrentDate:dateString];
    
    [self refreshView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataReloaded" object:nil];
    
    //show view animation
    
    [self.view setNeedsDisplay];
    [UIView transitionWithView:self.view duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.view.layer displayIfNeeded];
                    } completion:nil];
}

- (IBAction)moveOneDateRight:(id)sender {
    NSDate *date = [[VariableStore sharedInstance] currentDateActual];
    if (date == nil) {
        date = [[VariableStore sharedInstance] startDate];
        
    }
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *dateToBeIncremented = [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];
    [[VariableStore sharedInstance] setCurrentDateActual:dateToBeIncremented];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:dateToBeIncremented
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    [[VariableStore sharedInstance]setCurrentDate:dateString];
    
    [self refreshView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataReloaded" object:nil];
    
    //show view animation
    [self.view setNeedsDisplay];
    [UIView transitionWithView:self.view duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self.view.layer displayIfNeeded];
                    } completion:nil];
}

//Event Picker methods
-(void) displayPicker:(UIButton *)sender {
[ActionSheetStringPicker showPickerWithTitle:@"Select Activity" rows:_eventsArray initialSelection:0 target:self successAction:@selector(eventWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (void)eventWasSelected:(NSNumber *)selectedIndex element:(id)element {
    _currentLabel.text = [_eventsArray objectAtIndex:[selectedIndex intValue]];
}

- (void)actionPickerCancelled:(id)sender {
    //do nothing for now
}

-(void)changeMorning:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *currentCell = [_eventsTable cellForRowAtIndexPath:indexPath];
    _currentLabel = currentCell.detailTextLabel;
    [self displayPicker:sender];
}


-(void)changeAfternoon:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *currentCell = [_eventsTable cellForRowAtIndexPath:indexPath];
    _currentLabel = currentCell.detailTextLabel;
    [self displayPicker:sender];
}

-(void)changeEvening:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *currentCell = [_eventsTable cellForRowAtIndexPath:indexPath];
    _currentLabel = currentCell.detailTextLabel;
    [self displayPicker:sender];
}

-(void) saveEventCheck {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *morningCell = [_eventsTable cellForRowAtIndexPath:indexPath];
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *afternoonCell = [_eventsTable cellForRowAtIndexPath:indexPath];
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *eveningCell = [_eventsTable cellForRowAtIndexPath:indexPath];
    
    if ([morningCell.detailTextLabel.text isEqualToString:@"None"]&&[afternoonCell.detailTextLabel.text isEqualToString:@"None"]&&[eveningCell.detailTextLabel.text isEqualToString:@"None"] ){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"There are no events to save"];
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(backToCalendar) userInfo:nil repeats:NO];
    }
    else
        [self saveEvent];
}
-(void) saveEvent {
    NSDate *date = [[VariableStore sharedInstance] currentDateActual];
    if (date == nil) {
        date = [[VariableStore sharedInstance] startDate];
        
    }
    //Check if there are already entries for this date
    NSError *error;
    NSManagedObjectContext *context = [[VariableStore sharedInstance] context];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(date == %@)", date];
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
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *morningCell = [_eventsTable cellForRowAtIndexPath:indexPath];
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *afternoonCell = [_eventsTable cellForRowAtIndexPath:indexPath];
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *eveningCell = [_eventsTable cellForRowAtIndexPath:indexPath];
    
    [self addEvent:date withTimeOfDay:@"1" withTitle:morningCell.detailTextLabel.text];
    [self addEvent:date withTimeOfDay:@"2" withTitle:afternoonCell.detailTextLabel.text];
    [self addEvent:date withTimeOfDay:@"3" withTitle:eveningCell.detailTextLabel.text];
    
    //Go back to calendar
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataSaved" object:nil];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"The events have been sucessfully posted!"];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(backToCalendar) userInfo:nil repeats:NO];
    
    
}

-(void) backToCalendar{
   [self.navigationController popViewControllerAnimated:YES]; 
}

-(void) addEvent:(NSDate *)saveDate withTimeOfDay:(NSString *) timeOfDay withTitle:(NSString*)eventTitle {
    NSError *error;
    
    NSManagedObjectContext *context = [[VariableStore sharedInstance] context];
    //Create the new events and save them
    Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[[VariableStore sharedInstance] context]];
    [event setDate:saveDate];
    [event setTitle:eventTitle];
    [event setTimeofday:timeOfDay];
    
    //Save changes
    if (![context save:&error]) {
        // Handle the error.
    }
    event = nil;
}

//Table delegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _eventsTable)
        return 3;
    else {
        if ([_contactsArray count] > 0 )
            return [_contactsArray count];
        else
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (table == _eventsTable) {
        return [self populateEventSelections:table cellForRowAtIndexPath:indexPath];
        }
    else
        return [self populateContacts:table cellForRowAtIndexPath:indexPath];
        
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _contactsTable && [_contactsArray count] >0) {
        Contact *currentContact = [_contactsArray objectAtIndex:indexPath.row];
        NSString *contactName = currentContact.name;
        
        [self loadContact:contactName];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UITableViewCell*)populateEventSelections:(UITableView*) table cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"eventCell"];
    if( cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"];
    UIImage *image = [UIImage imageNamed:@"blue_button.png"];
    if (indexPath.row == 0) {
        //Create the button
        _changeMorning = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_changeMorning setTitle:@"Change" forState:UIControlStateNormal];
        [_changeMorning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeMorning setBackgroundImage:image forState:UIControlStateNormal];
        _changeMorning.frame = CGRectMake(80.0, 210.0, 70.0, 30.0);
        [_changeMorning addTarget:self action:@selector(changeMorning:)forControlEvents:UIControlEventTouchDown];
        
        cell.textLabel.text = @"Morning:";
        cell.accessoryView = _changeMorning;
        if ([_dailyEventsDictionary objectForKey:@"1"])
            cell.detailTextLabel.text = [_dailyEventsDictionary objectForKey:@"1"];
        else
            cell.detailTextLabel.text = @"None\n\n\n";
    }
    if (indexPath.row == 1) {
        //Create the button
        _changeAfternoon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_changeAfternoon setTitle:@"Change" forState:UIControlStateNormal];
        [_changeAfternoon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeAfternoon setBackgroundImage:image forState:UIControlStateNormal];
        _changeAfternoon.frame = CGRectMake(80.0, 210.0, 70.0, 30.0);
        [_changeAfternoon addTarget:self action:@selector(changeAfternoon:)forControlEvents:UIControlEventTouchDown];
        
        cell.textLabel.text = @"Afternoon:";
        cell.accessoryView = _changeAfternoon;
        if ([_dailyEventsDictionary objectForKey:@"2"])
            cell.detailTextLabel.text = [_dailyEventsDictionary objectForKey:@"2"];
        else
            cell.detailTextLabel.text = @"None\n\n\n";
    }
    if (indexPath.row == 2) {
        //Create the button
        _changeEvening = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_changeEvening setTitle:@"Change" forState:UIControlStateNormal];
        [_changeEvening setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeEvening setBackgroundImage:image forState:UIControlStateNormal];
        _changeEvening.frame = CGRectMake(80.0, 210.0, 70.0, 30.0);
        [_changeEvening addTarget:self action:@selector(changeEvening:)forControlEvents:UIControlEventTouchDown];
        
        cell.textLabel.text = @"Evening:";
        cell.accessoryView = _changeEvening;
        if ([_dailyEventsDictionary objectForKey:@"3"])
            cell.detailTextLabel.text = [_dailyEventsDictionary objectForKey:@"3"];
        else
            cell.detailTextLabel.text = @"None\n\n\n";
    }
    
    /*
     //cell.backgroundColor = [UIColor colorWithRed:210/255.0f green:226/255.0f blue:245/255.0f alpha:1]; */
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableViewCell*)populateContacts:(UITableView*) table cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"contactCell"];
    if( cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactCell"];
    
    if([_contactsArray count] <= 0) {
        cell.textLabel.text = @"No Contacts For This Day";
    }
    else {
        Contact *currentContact = [_contactsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = currentContact.name;
    }
    return cell;
}

//Contact picker methods
-(void)loadContact:(NSString*)contactName {
    
	ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,NULL);;
	NSArray *people = (__bridge NSArray *)ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)(contactName));
	if ((people != nil) && [people count])
	{
		ABRecordRef person = (__bridge ABRecordRef)[people objectAtIndex:0];
		ABPersonViewController *picker = [[ABPersonViewController alloc] init];
		picker.personViewDelegate = self;
		picker.displayedPerson = person;
		picker.allowsEditing = YES;
        picker.navigationItem.title=@"Contact Info";
		[self.navigationController pushViewController:picker animated:YES];
	}
	else
	{
		// Show an alert if contact is not in addressbook
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Could not find the contact in your addressbook"
													   delegate:nil
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:nil];
		[alert show];
	}
	CFRelease(addressBook);
}

-(IBAction)addContact:(id)sender {
    ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
    view.newPersonViewDelegate = self;
    UINavigationController *newNavigationController = [[UINavigationController alloc]
                                                       initWithRootViewController:view];
    [self presentViewController:newNavigationController animated:YES completion:^(void){}];
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person {
    CFErrorRef error = NULL;
    if (person) {
        ABRecordID groupId =  [[VariableStore sharedInstance] groupId];
        ABRecordRef zionAmericaGroup = ABAddressBookGetGroupWithRecordID(newPersonViewController.addressBook, groupId);
        ABGroupAddMember(zionAmericaGroup, person, &error);
        ABAddressBookSave(newPersonViewController.addressBook, &error);
        
        [self saveContactRecord:person];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataSaved" object:nil];
    }
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

-(void)saveContactRecord:(ABRecordRef)person {
    //Get the persons name
    
    NSString *firstName =(__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSMutableString *personName = [[NSMutableString alloc] initWithFormat:@"%@ %@",firstName,lastName];
    
    NSDate *saveDate = [[VariableStore sharedInstance] currentDateActual];
    if (saveDate == nil) {
        saveDate = [[VariableStore sharedInstance] startDate];
        
    }
    NSError *error;
    NSManagedObjectContext *context = [[VariableStore sharedInstance] context];
    //Create the new contact and save it
    Contact *contact = (Contact *)[NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:[[VariableStore sharedInstance] context]];
    [contact setDate:saveDate];
    [contact setName:personName];
    
    //Save changes
    if (![context save:&error]) {
        // Handle the error.
    }
}

-(void)getContacts{
    NSDate *date = [[VariableStore sharedInstance] currentDateActual];
    if (date == nil) {
        date = [[VariableStore sharedInstance] startDate];
        
    }
    
    NSError *error;
    NSManagedObjectContext *context = [[VariableStore sharedInstance] context];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Contact"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(date == %@)", date];
    [request setPredicate:predicate];
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        //Deal with failure
    }
    else {
        _contactsArray = results;
    }
}

-(void)getEvents {
    NSDate *date = [[VariableStore sharedInstance] currentDateActual];
    if (date == nil) {
        date = [[VariableStore sharedInstance] startDate];
        
    }
    
    NSError *error;
    NSManagedObjectContext *context = [[VariableStore sharedInstance] context];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(date == %@)", date];
    [request setPredicate:predicate];
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        //Deal with failure
    }
    else {
        //_dailyEventsDictionary = results;
        for (Event *event in results) {
            if ([event.timeofday isEqualToString:@"1"]){
                [_dailyEventsDictionary setValue:event.title forKey:@"1"];
                
                /*NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                UITableViewCell *currentCell = [_eventsTable cellForRowAtIndexPath:indexPath];
                currentCell.detailTextLabel.text = event.title; */
            }
            if ([event.timeofday isEqualToString:@"2"]) {
                [_dailyEventsDictionary setValue:event.title forKey:@"2"];
                
                /*NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                UITableViewCell *currentCell = [_eventsTable cellForRowAtIndexPath:indexPath];
                currentCell.detailTextLabel.text = event.title; */
            }
            if ([event.timeofday isEqualToString:@"3"]) {
                [_dailyEventsDictionary setValue:event.title forKey:@"3"];
                
                /*NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                UITableViewCell *currentCell = [_eventsTable cellForRowAtIndexPath:indexPath];
                currentCell.detailTextLabel.text = event.title; */
            }
        }
    }
}


- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return YES;
}

@end
