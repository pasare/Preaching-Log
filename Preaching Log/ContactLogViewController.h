//
//  ContactLogViewController.h
//  Preaching Log
//
//  Created by Patrick Asare on 4/20/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VariableStore.h"

@interface ContactLogViewController : UITableViewController<UISearchBarDelegate,ABPersonViewControllerDelegate,ABNewPersonViewControllerDelegate>
@property (nonatomic, retain)  UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic) NSArray *contactsArray;
@end
