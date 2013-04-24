//
//  addEventViewController.h
//  Preaching Log
//
//  Created by Patrick Asare on 1/30/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VariableStore.h"
#import <TapkuLibrary/TapkuLibrary.h>
#import "CalendarMonthViewController.h"
#import "Event.h"
#import "ActionSheetStringPicker.h"
#import "Contact.h"

@interface AddEventViewController : UIViewController<ABPersonViewControllerDelegate,ABNewPersonViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *contactsBar;
@property (weak, nonatomic) IBOutlet UITableView *eventsTable;
@property (weak, nonatomic) IBOutlet UINavigationItem *eventNavigationItem;
@property (weak, nonatomic) IBOutlet UITableView *contactsTable;

@property NSArray *contactsArray;
@property NSMutableDictionary *dailyEventsDictionary;
@property UIButton *changeMorning;
@property UIButton *changeAfternoon;
@property UIButton *changeEvening;

@end
