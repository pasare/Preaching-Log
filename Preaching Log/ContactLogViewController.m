//
//  ContactLogViewController.m
//  Preaching Log
//
//  Created by Patrick Asare on 4/20/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import "ContactLogViewController.h"

@interface ContactLogViewController ()

@end

@implementation ContactLogViewController
bool _searching = NO;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated {
    _searching = NO;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _listOfItems = [[NSMutableArray alloc] init];
    _contactsArray  = [[VariableStore sharedInstance] ABcontactsArray];
    _oldContactsArray = [[VariableStore sharedInstance] ABcontactsArray];;
    UISearchBar *tempSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    _searchBar = tempSearchBar;
    _searchBar.delegate = self;
    [_searchBar setShowsScopeBar:YES];
    NSArray *scopeItems = [[NSArray alloc] initWithObjects:@"Name",@"Date", nil];
    [_searchBar setScopeButtonTitles:scopeItems];
    [_searchBar sizeToFit];
    _searchBar.tintColor = [UIColor lightGrayColor];
    self.tableView.tableHeaderView = _searchBar;
    
    
    //Notification for when table needs to be updated
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSaved:)
                                                 name:@"DataSaved" object:nil];
    
    //Get contacts by date
    [self getDatedContacts];
    
    //create the contacts array and dictionary
    
    
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

-(void) dataSaved:(NSNotification *)notification{
    if ([[VariableStore sharedInstance] accessGranted]){
        [[VariableStore sharedInstance]displayContacts];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searching)
        return 1;
    else {
        return 1;
        //return [[_contactsDictionary allKeys] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searching)
        return [_listOfItems count];
    else {
        return [_contactsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (_searching){
        cell.textLabel.text = [_listOfItems objectAtIndex:indexPath.row];
    }
    else {
        cell.textLabel.text = [_contactsArray objectAtIndex:indexPath.row];
    }
    
    //cell.backgroundColor = [UIColor colorWithRed:210/255.0f green:226/255.0f blue:245/255.0f alpha:1];
    return cell;
}

/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *sectionedArray = [[NSMutableArray alloc]init];
    for(char c ='A' ; c <= 'Z' ;  c++)
    {
        [sectionedArray addObject:[NSString stringWithFormat:@"%c",c]];
    }
    return sectionedArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in _contactsArray)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
} */




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searching){
        [self loadContact:[_listOfItems objectAtIndex:indexPath.row]];
    }
    else {
        [self loadContact:[_contactsArray objectAtIndex:indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//Add contact functions
- (IBAction)addContact:(id)sender {
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataSaved" object:nil];
    }
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

//Edit contact functions
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ABPersonViewController *personView = [[ABPersonViewController alloc] init];
    personView.personViewDelegate = self;
    personView.displayedPerson = (__bridge ABRecordRef)([_contactsArray objectAtIndex:indexPath.row]);
    personView.allowsEditing = YES;
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],[NSNumber numberWithInt:kABPersonNoteProperty], nil];
    personView.displayedProperties = displayedItems;
    [self.navigationController pushViewController:personView animated:YES];
    
}

//View contact
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return YES;
}

//search methods

-(void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    if (selectedScope == 0) {
        _contactsArray = _oldContactsArray;
    }
    if (selectedScope == 1) {
        _contactsArray = _datedContactsArray;
    }
    [self.tableView reloadData];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    return YES;
}


- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    theSearchBar.showsCancelButton = YES;
    //Remove all objects first.
    [_listOfItems removeAllObjects];
    
    if([searchText length] > 0) {
        _searching = YES;
        [self searchTableView];
    }
    else {
        _searching = NO;
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	searchBar.text = nil;
	[searchBar resignFirstResponder];
    _searching = NO;
    searchBar.showsCancelButton = NO;
    [self.tableView reloadData];
	
}


- (void) searchTableView {
    
    NSString *searchText = _searchBar.text;
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    [searchArray addObjectsFromArray:_contactsArray];
    NSString *personName;
    for (int i=0; i<[searchArray count]; i++) {
        
        personName = [searchArray objectAtIndex:i];
        NSRange titleResultsRange = [personName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (titleResultsRange.length > 0)
            [_listOfItems addObject:[_contactsArray objectAtIndex:i]];
    }
    searchArray = nil;
}

//Retrieving contacts
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

-(void) getDatedContacts {
    NSDate *date = [[VariableStore sharedInstance] currentDateActual];
    if (date == nil) {
        date = [[VariableStore sharedInstance] startDate];
        
    }
    NSError *error;
    NSManagedObjectContext *context = [[VariableStore sharedInstance] context];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Contact"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        //Deal with failure
    }
    else {
        //Get dated names in proper order
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (Contact *contact in results){
            
            [tempArray addObject:contact.name];
        }
        //Add undated names to the end
        NSString *personName;
        for (int i=0; i<[_contactsArray count]; i++) {
    
            personName = [_contactsArray objectAtIndex:i];
            if (![tempArray containsObject:personName]){
                [tempArray addObject:personName];
            }
        }
        NSLog(@"%@",tempArray);
        _datedContactsArray = tempArray;
    }
}

//Return an order dictionary of contacts for the contact list
/*-(void)getContacts {
    NSArray *contacts = [[VariableStore sharedInstance] ABcontactsArray];
    _contactsDictionary = [[NSMutableDictionary alloc]init];
    NSString *firstCharacter;
    NSMutableArray *group;
    for (NSString *contact in contacts) {
        firstCharacter = [[contact substringToIndex:1] uppercaseString];
        
        if ([_contactsDictionary valueForKey:firstCharacter] != nil){
            group = [_contactsDictionary valueForKey:firstCharacter];
            [group addObject:contact];
            [_contactsDictionary setValue:group forKey:firstCharacter];
        }
        else {
            NSArray *newGroup = [[NSArray alloc]initWithObjects:contact, nil];
            [_contactsDictionary setValue:newGroup forKey:firstCharacter];
        }
    }
} */


@end
