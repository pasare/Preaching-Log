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

@interface AddEventViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *eventNavigationItem;
@property (weak, nonatomic) IBOutlet UILabel *eveningLabel;
@property (weak, nonatomic) IBOutlet UILabel *afternoonLabel;
@property (weak, nonatomic) IBOutlet UILabel *morningLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *eventPicker;
@property (weak, nonatomic) IBOutlet UIButton *changeEvening;
@property (weak, nonatomic) IBOutlet UIButton *changeAfternoon;
@property (weak, nonatomic) IBOutlet UIButton *changeMorning;

@end
