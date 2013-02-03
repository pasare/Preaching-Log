//
//  addEventViewController.m
//  Preaching Log
//
//  Created by Patrick Asare on 1/30/13.
//  Copyright (c) 2013 Church Of God. All rights reserved.
//

#import "addEventViewController.h"

@interface AddEventViewController ()
@property (nonatomic) NSMutableArray *eventsArray;
@property (weak,nonatomic) UILabel *currentLabel;
@end

@implementation AddEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_eventsArray = [[NSMutableArray alloc] init];
    [_eventsArray addObject:@"1 Door to Door Preaching"];
    [_eventsArray addObject:@"2 Street Preaching"];
    [_eventsArray addObject:@"7 Activity for Church"];
    [_eventsArray addObject:@"8 Church Gathering"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Save Events" style:UIBarButtonItemStylePlain
                                              target:self action:@selector(saveEvent)];
    //Retrieve the events for the day
    NSString *date = [[VariableStore sharedInstance] currentDate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dataDictionary = [defaults objectForKey:@"dataDictionary"];
    NSArray *eventsArray = [dataDictionary objectForKey:date];
    if (eventsArray != nil) {
        _morningLabel.text = [eventsArray objectAtIndex:0];
        _afternoonLabel.text = [eventsArray objectAtIndex:1];
        _eveningLabel.text = [eventsArray objectAtIndex:2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Event Picker methods

-(IBAction)changeMorning:(id)sender
{
    _currentLabel = _morningLabel;
    _eventPicker.hidden = NO;
}


-(IBAction)changeAfternoon:(id)sender
{
    _currentLabel = _afternoonLabel;
    _eventPicker.hidden = NO;
}

-(IBAction)changeEvening:(id)sender
{
    _currentLabel = _eveningLabel;
    _eventPicker.hidden = NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_eventsArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_eventsArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *selectedEvent = [_eventsArray objectAtIndex:row];
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:selectedEvent forKey:@"zionName"];
    _currentLabel.text = selectedEvent;
    _eventPicker.hidden = YES;
}

-(void) saveEvent {
    //retrieve the data
    NSString *date = [[VariableStore sharedInstance] currentDate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dataDictionary = [[defaults objectForKey:@"dataDictionary"] mutableCopy];
    if (date == nil) {
        date = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                dateStyle:NSDateFormatterShortStyle
                                timeStyle:NSDateFormatterNoStyle];
    }
    //Save the event data
    [dataDictionary setObject:[NSArray arrayWithObjects:_morningLabel.text,_afternoonLabel.text,_eveningLabel.text,nil] forKey:date];
    
    
    //save everything
    [defaults setObject:dataDictionary forKey:@"dataDictionary"];
    
    //Go back to calender
    
    [[[VariableStore sharedInstance]calendar] reloadData];
    
    //AddEventViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addEventView"];
    //[self.navigationController pushViewController:viewController animated:YES];
}

@end
