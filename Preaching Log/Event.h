//
//  Event.h
//  Preaching Log
//
//  Created by Patrick Asare on 4/19/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSManagedObject
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * timeofday;
@end
