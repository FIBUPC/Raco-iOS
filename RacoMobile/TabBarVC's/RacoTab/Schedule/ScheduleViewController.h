//
//  ScheduleViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScheduleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView     *scheduleTableView;
    NSMutableArray  *scheduleItems;
    NSArray         *hoursRowsDict;
    NSDictionary    *hoursRowsColorDict;
    UIView          *underButtonView;
    UIButton        *syncronizeButton;
    UILabel         *syncronizeLabel;
    
    NSDate          *myDate;
    UILabel         *selectedDateLabel;
    
    BOOL            pickerShown;
    UIView          *selectDateView;
    UIDatePicker    *datePickerView;
    
    UILabel         *updatedLabel;
}

@property (nonatomic, retain) IBOutlet UITableView  *scheduleTableView;
@property (nonatomic, retain) NSMutableArray        *scheduleItems;
@property (nonatomic, retain) NSArray               *hoursRowsDict;
@property (nonatomic, retain) NSDictionary          *hoursRowsColorDict;
@property (nonatomic, retain) IBOutlet UIView       *underButtonView;
@property (nonatomic, retain) IBOutlet UIButton     *syncronizeButton;
@property (nonatomic, retain) IBOutlet UILabel      *syncronizeLabel;


@property (nonatomic, retain) NSDate                *myDate;
@property (nonatomic, retain) IBOutlet UILabel      *selectedDateLabel;

@property (nonatomic, readwrite) BOOL               pickerShown;
@property (nonatomic, retain) IBOutlet UIView       *selectDateView;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePickerView;

@property (nonatomic, retain) IBOutlet UILabel      *updatedLabel;

- (IBAction)SynchronizeSchedule:(id)sender;
- (IBAction)dayAfterPressed:(id)sender;
- (IBAction)dayBeforePressed:(id)sender;
- (IBAction)findDate:(id)sender;
- (IBAction)refreshSchedule:(id)sender;

@end
