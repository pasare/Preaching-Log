//
//  AppDelegate.h
//  Preaching Log
//
//  Created by Patrick Asare on 1/28/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CalendarViewController *detail;

@end
