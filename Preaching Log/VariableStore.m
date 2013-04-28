//
//  VariableStore.m
//  Preaching Log
//
//  Created by Patrick Asare on 2/1/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import "VariableStore.h"

@implementation VariableStore
+ (VariableStore *)sharedInstance
{
    // the instance of this class is stored here
    static VariableStore *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
        //myInstance.loginID
    }
    // return the instance of this class
    return myInstance;
}

- (NSString*) currentDate {
    return _currentDate;
}

- (NSDate*) currentDateActual {
    return _currentDateActual;
}

- (NSDate*) startDate {
    return _startDate;
}

-(NSManagedObjectContext *)context {
    return _context;
}

- (NSFetchedResultsController*) fetchedContactsController{
    return _fetchedEventsController;
}

-(BOOL)accessGranted {
    return _accessGranted;
}

-(NSArray*)ABcontactsArray {
    return _ABcontactsArray;
}

//Methods for the iOS addressbook
-(void) displayContacts {
    [[VariableStore sharedInstance] setAccessGranted:NO];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,NULL);
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        //First time access granted
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                [[VariableStore sharedInstance] setAccessGranted:granted];
            });
        }
        // Authorized access
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            [[VariableStore sharedInstance] setAccessGranted:YES];
        }
        else {
            //Access has been denied
            UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Unable to access contacts, grant this application access in your privacy settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil ];
            [failedAlert show];
        }
    }
    //Legacy device access request is not required
    else {
        [[VariableStore sharedInstance] setAccessGranted:YES];
    }
    
    
    if ([[VariableStore sharedInstance] accessGranted]) {
        NSArray *tempContactsArray;
        NSMutableArray *returnedContactsArray = [[NSMutableArray alloc] init];
        [self CheckIfGroupExistsWithName:@"Zion America"];
        ABRecordRef zionAmericaGroup = ABAddressBookGetGroupWithRecordID(addressBook,[[VariableStore sharedInstance] groupId]);
        tempContactsArray = (__bridge_transfer NSArray*)ABGroupCopyArrayOfAllMembersWithSortOrdering(zionAmericaGroup, kABPersonSortByFirstName);
        NSString *firstName;
        NSString *lastName;
        NSMutableString *fullName;
        for (int i=0; i<[tempContactsArray count]; i++) {
            firstName =(__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([tempContactsArray objectAtIndex:i]) , kABPersonFirstNameProperty);
            lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([tempContactsArray objectAtIndex:i]), kABPersonLastNameProperty);
            fullName = [[NSMutableString alloc] initWithFormat:@"%@ %@",firstName,lastName];
            [returnedContactsArray addObject:fullName];
        }
            
        [[VariableStore sharedInstance] setABcontactsArray:returnedContactsArray];
    }
    
    //CFRelease(addressBook);
}

//Check for group name
-(void) CheckIfGroupExistsWithName:(NSString*)groupName {
    
    
    BOOL hasGroup = NO;
    //checks to see if the group is created and creates group if it does not exist
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFIndex groupCount = ABAddressBookGetGroupCount(addressBook);
    CFArrayRef groupLists= ABAddressBookCopyArrayOfAllGroups(addressBook);
    
    for (int i=0; i<groupCount; i++) {
        ABRecordRef currentCheckedGroup = CFArrayGetValueAtIndex(groupLists, i);
        NSString *currentGroupName = (__bridge NSString *)ABRecordCopyCompositeName(currentCheckedGroup);
        
        if ([currentGroupName isEqualToString:groupName]){
            //!!! important - save groupID for later use
            [[VariableStore sharedInstance] setGroupId:ABRecordGetRecordID(currentCheckedGroup)];
            hasGroup=YES;
        }
    }
    
    if (hasGroup==NO){
        //id the group does not exist you can create one
        [self createNewGroup:groupName];
    }
    
    CFRelease(addressBook);
}

-(void) createNewGroup:(NSString*)groupName {
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef newGroup = ABGroupCreate();
    ABRecordSetValue(newGroup, kABGroupNameProperty,(__bridge CFTypeRef)(groupName), nil);
    ABAddressBookAddRecord(addressBook, newGroup, nil);
    ABAddressBookSave(addressBook, nil);
    CFRelease(addressBook);
    
    //save groupId for later use
    [[VariableStore sharedInstance] setGroupId:ABRecordGetRecordID(newGroup)];
    CFRelease(newGroup);
}

@end
