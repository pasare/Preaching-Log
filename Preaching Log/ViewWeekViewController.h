//
//  ViewWeekViewController.h
//  Preaching Log
//
//  Created by Patrick Asare on 2/5/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VariableStore.h"
#import "TableCell.h"
#import <TapkuLibrary/TapkuLibrary.h>

@interface ViewWeekViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *weekTable;
@property NSMutableArray *tableArray;

@end
