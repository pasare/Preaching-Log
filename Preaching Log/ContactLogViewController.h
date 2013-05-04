//
//  ContactLogViewController.h
//  Preaching Log
//
//  Created by Patrick Asare on 4/20/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VariableStore.h"
#import "Contact.h"
#import "OrderedDictionary.h"

@interface ContactLogViewController : UITableViewController<UISearchBarDelegate,ABPersonViewControllerDelegate,ABNewPersonViewControllerDelegate>
@property (nonatomic, retain)  UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic) OrderedDictionary *contactsDictionary;
@property (nonatomic) OrderedDictionary *datedContactsDictionary;
//@property (nonatomic) NSArray *contactsArray;
@property (nonatomic) OrderedDictionary *oldContactsDictionary;
@end
