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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _listOfItems = [[NSMutableArray alloc] init];
    _contactsArray  = [[VariableStore sharedInstance] ABcontactsArray];
    UISearchBar *tempSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    _searchBar = tempSearchBar;
    _searchBar.delegate = self;
    [_searchBar sizeToFit];
    _searchBar.tintColor = [UIColor lightGrayColor];
    self.tableView.tableHeaderView = _searchBar;
    
    
    //Notification for when table needs to be updated
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSaved:)
                                                 name:@"DataSaved" object:nil];
    
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
    return 1;
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
    NSString *firstName;
    NSString *lastName;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (_searching){
        firstName =(__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([_listOfItems objectAtIndex:indexPath.row]), kABPersonFirstNameProperty);
        lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([_listOfItems objectAtIndex:indexPath.row]), kABPersonLastNameProperty);
    }
    else {
        firstName =(__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([_contactsArray objectAtIndex:indexPath.row]), kABPersonFirstNameProperty);
        lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([_contactsArray objectAtIndex:indexPath.row]), kABPersonLastNameProperty);
    }
    
    NSMutableString *personName = [[NSMutableString alloc] initWithFormat:@"%@ %@",firstName,lastName];
    cell.textLabel.text = personName;
    //cell.backgroundColor = [UIColor colorWithRed:210/255.0f green:226/255.0f blue:245/255.0f alpha:1];
    return cell;
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
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.personViewDelegate = self;
    personViewController.allowsActions = YES;
    personViewController.navigationItem.title=@"Contact Info";
    
    if (_searching){
        personViewController.displayedPerson = (__bridge ABRecordRef)([_listOfItems objectAtIndex:indexPath.row]);
    }
    else {
        personViewController.displayedPerson = (__bridge ABRecordRef)([_contactsArray objectAtIndex:indexPath.row]);
    }
    [self.navigationController pushViewController:personViewController animated:YES];
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
    NSString *firstName;
    NSString *lastName;
    NSMutableString *personName;
    for (int i=0; i<[searchArray count]; i++) {
        firstName =(__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([searchArray objectAtIndex:i]), kABPersonFirstNameProperty);
        lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([searchArray objectAtIndex:i]), kABPersonLastNameProperty);
        personName = [[NSMutableString alloc] initWithFormat:@"%@ %@",firstName,lastName];
        
        NSRange titleResultsRange = [personName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (titleResultsRange.length > 0)
            [_listOfItems addObject:[_contactsArray objectAtIndex:i]];
    }
    searchArray = nil;
}



@end
