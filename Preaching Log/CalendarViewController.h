//
//  CalendarViewController.h
//  Preaching Log
//
//  Created by Patrick Asare on 1/28/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import "CalendarMonthViewController.h"
#import "AddEventViewController.h"
@interface CalendarViewController : UIViewController <UISplitViewControllerDelegate>


@property (nonatomic,strong) NSArray *data;
@property (nonatomic, retain) TKCalendarMonthView *calendar;
@property (strong,nonatomic) UIToolbar *toolbar;
@property (nonatomic,strong) UIViewController *mainController;
@property (nonatomic,strong) UIPopoverController *currentPopoverController;

- (void) setupWithMainController:(UIViewController*)controller;
@end
