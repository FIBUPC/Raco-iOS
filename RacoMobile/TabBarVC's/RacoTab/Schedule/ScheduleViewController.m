//
//  ScheduleViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import "IcalEvent.h"
#import "Utils.h"
#import "RacoMobileAppDelegate+ActivityView.h"
#import "Defines.h"
#import "ScheduleCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ScheduleViewController ()
-(void)setUpdatedLabelText;
- (void)setSincronizeButton;
- (void)initDatePickerAndSelectionButton;
- (void)setNavigationBarTitle;
- (void)initializeRowsHours;
- (void)initializeRowsColors;

- (void)getAllEventsWithChoosenDate;
- (void)scrollTableToTop;

- (void)initializeGestureRecognizer;
@end

@implementation ScheduleViewController

@synthesize scheduleTableView, scheduleItems, hoursRowsDict, hoursRowsColorDict;
@synthesize underButtonView, syncronizeButton, syncronizeLabel;
@synthesize myDate, selectedDateLabel;
@synthesize pickerShown, selectDateView, datePickerView;
@synthesize updatedLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self setUpdatedLabel:nil];
    [self setSelectDateView:nil];
    [self setDatePickerView:nil];
    [self setUnderButtonView:nil];
    [self setSyncronizeButton:nil];
    [self setSyncronizeLabel:nil];
    [self setScheduleTableView:nil];
    [self setScheduleItems:nil];
    [self setHoursRowsDict:nil];
    [self setHoursRowsColorDict:nil];
    [self setMyDate:nil];
    [self setSelectedDateLabel:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scheduleDataLoaded" object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Regiter Notification for self | Schedule Data Loaded
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"scheduleDataLoaded" object:nil];
    
    //Set selectedDateLabel text
    [self setMyDate:[NSDate date]];
    [selectedDateLabel setText:[Utils stringFromDate:myDate]];
    
    [self setUpdatedLabelText];
    
    [self setSincronizeButton];
    
    [self initDatePickerAndSelectionButton];
    
    [self setNavigationBarTitle];
    
    [self initializeRowsHours];
    
    [self initializeRowsColors];

    [self getAllEventsWithChoosenDate];
    
    [self scrollTableToTop];
    
    [self initializeGestureRecognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}

#pragma mark - Initialitation Methods

-(void)setUpdatedLabelText {
    NSDate *updatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"ScheduleUpdatedDate"];
    [updatedLabel setText:[NSString stringWithFormat:@" %@: %@",NSLocalizableString(@"_lastUpdate"),[Utils stringWithHourFromDate:updatedDate]]];
}

- (void)setSincronizeButton {
    //Set syncronizeLabel localized text   
    [syncronizeLabel setText:NSLocalizableString(@"_synchronizeSchedule")];
}

- (void)initDatePickerAndSelectionButton {
    //Add "findDate" button
    UIBarButtonItem *dayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizableString(@"_day") style:UIBarButtonItemStylePlain target:self action:@selector(findDate:)];
    [self.navigationItem setRightBarButtonItem:dayButton];
    [dayButton release];
    
    //Set pickerShown FALSE
    pickerShown = NO;
    
    //Set picker date
    [datePickerView setDate:myDate];
}

- (void)setNavigationBarTitle {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];    
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:myDate];  
    NSInteger weekdayNum = [weekdayComponents weekday];
    [gregorian release];
    
    NSString *weekDay = @"";
    switch (weekdayNum) {
        case 1:
            weekDay = NSLocalizableString(@"_sunday");
            break;            
        case 2:
            weekDay = NSLocalizableString(@"_monday");
            break;            
        case 3:
            weekDay = NSLocalizableString(@"_tuesday");
            break;
        case 4:
            weekDay = NSLocalizableString(@"_wednesday");
            break;            
        case 5:
            weekDay = NSLocalizableString(@"_thursday");
            break;            
        case 6:
            weekDay = NSLocalizableString(@"_friday");
            break;            
        case 7:
            weekDay = NSLocalizableString(@"_saturday");
            break;            
        default:
            break;
    }
    //Set the NavigationBar title
    self.navigationItem.title = weekDay;
}

- (void)initializeRowsHours {
    //Initialize table rows from 8:00 to 21:00
    hoursRowsDict = [[NSArray alloc] initWithObjects:@"08:00-09:00", @"09:00-10:00", @"10:00-11:00", @"11:00-12:00",
                     @"12:00-13:00", @"13:00-14:00", @"14:00-15:00", @"15:00-16:00",
                     @"16:00-17:00", @"17:00-18:00", @"18:00-19:00", @"19:00-20:00",
                     @"20:00-21:00",nil];
}

- (void)initializeRowsColors {
    hoursRowsColorDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:
                                                                [UIColor colorWithRed:255/255.0 green:189/255.0 blue:56/255.0 alpha:1],     //"08:00-09:00"
                                                                [UIColor colorWithRed:255/255.0 green:204/255.0 blue:245/255.0 alpha:1],    //"09:00-10:00"
                                                                [UIColor colorWithRed:143/255.0 green:233/255.0 blue:255/255.0 alpha:1],    //"10:00-11:00"
                                                                [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1],    //"11:00-12:00"
                                                                [UIColor colorWithRed:255/255.0 green:128/255.0 blue:128/255.0 alpha:1],    //"12:00-13:00" 
                                                                [UIColor colorWithRed:255/255.0 green:255/255.0 blue:117/255.0 alpha:1],    //"13:00-14:00"
                                                                [UIColor colorWithRed:176/255.0 green:255/255.0 blue:143/255.0 alpha:1],    //"14:00-15:00"
                                                                [UIColor colorWithRed:255/255.0 green:189/255.0 blue:56/255.0 alpha:1],     //"15:00-16:00"
                                                                [UIColor colorWithRed:255/255.0 green:204/255.0 blue:245/255.0 alpha:1],    //"16:00-17:00"
                                                                [UIColor colorWithRed:143/255.0 green:233/255.0 blue:255/255.0 alpha:1],    //"17:00-18:00"
                                                                [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1],    //"18:00-19:00"
                                                                [UIColor colorWithRed:255/255.0 green:128/255.0 blue:128/255.0 alpha:1],    //"19:00-20:00" 
                                                                [UIColor colorWithRed:255/255.0 green:255/255.0 blue:117/255.0 alpha:1],    //"20:00-21:00"
                                                                nil] forKeys:hoursRowsDict];
}
    
#pragma mark - Private Methods

- (void)refreshSchedule:(id)sender {
    
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];    
    //ShowActivityViewer
    [delegate showActivityViewer];
    
    //Refresh ScheduleData
    [delegate refreshScheduleDataAlways];
    
    //Reload updatedLabel text
    NSDate *updatedDate = [NSDate date];
    [updatedLabel setText:[NSString stringWithFormat:@" %@: %@",NSLocalizableString(@"_lastUpdate"),[Utils stringWithHourFromDate:updatedDate]]];
}

- (void)reloadTableView {
    [self getAllEventsWithChoosenDate];
    [scheduleTableView reloadData];
}

- (void)findDate:(id)sender {
    if (pickerShown) {
        //Hide picker and call service
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [selectDateView setFrame:CGRectMake(
                                        0, 
                                        self.view.bounds.size.height, 
                                        selectDateView.bounds.size.width, 
                                        selectDateView.bounds.size.height)];
        [UIView commitAnimations];
        
        pickerShown = NO;
        
        [self setMyDate:[datePickerView date]];
        [selectedDateLabel setText:[Utils stringFromDate:myDate]];
        [self getAllEventsWithChoosenDate];
    }
    else {
        //Show Picker
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [selectDateView setFrame:CGRectMake(
                                            0, 
                                            self.view.bounds.size.height - selectDateView.bounds.size.height, 
                                            selectDateView.bounds.size.width, 
                                            selectDateView.bounds.size.height)];
        [UIView commitAnimations];
        
        pickerShown = YES;
    }
}

- (void)SynchronizeSchedule:(id)sender{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *icalHorariIcsKey = [userDefaults objectForKey:kIcalHorariIcsKey];
	
	NSString *urlCorreu = [NSString stringWithFormat:@"%@%@",kScheduleSyncronizeUrl,icalHorariIcsKey];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlCorreu]];
}

- (void)dayAfterPressed:(id)sender {
    //Plus one day
    NSDate *tempDate = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:myDate];
    [self setMyDate:tempDate];
    [selectedDateLabel setText:[Utils stringFromDate:myDate]];
    [self getAllEventsWithChoosenDate];
}

- (void)dayBeforePressed:(id)sender {
    //minus one day
    NSDate *tempDate = [NSDate dateWithTimeInterval:(-24*60*60) sinceDate:myDate];
    [self setMyDate:tempDate];
    [selectedDateLabel setText:[Utils stringFromDate:myDate]];
    [self getAllEventsWithChoosenDate];
}

- (void)getAllEventsWithChoosenDate {
    
    if (!scheduleItems) {
        scheduleItems = [[NSMutableArray alloc] init];
    } else [scheduleItems removeAllObjects];
    
    NSArray *dateEvents = [[ScheduleHandler sharedHandler] getEventsWithDate:myDate];
    
    NSString *hourTime;
    for (int i=0; i<[hoursRowsDict count]; i++) {
        hourTime = [hoursRowsDict objectAtIndex:i];
        NSMutableArray *anEventArray = [[ScheduleHandler sharedHandler] getEventWithInterval:hourTime date:myDate fromEvents:dateEvents];
        
        NSMutableDictionary *eventAndHourDict = [[NSMutableDictionary alloc] init];
        
        if ([anEventArray count] > 0) {
            for (IcalEvent *anEvent in anEventArray) {
                [eventAndHourDict setObject:anEvent forKey:hourTime];
                [scheduleItems addObject:eventAndHourDict];
            }
        }
        else {
            IcalEvent *anEventFake = [[IcalEvent alloc] init];
            [eventAndHourDict setObject:anEventFake forKey:hourTime];
            [scheduleItems addObject:eventAndHourDict];
            [anEventFake release];
        }
        [eventAndHourDict release];
    }
    [self setNavigationBarTitle];
    
    [scheduleTableView reloadData];
}

- (void)scrollTableToTop {
    if (scheduleItems) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [[self scheduleTableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - TableView Delegates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [scheduleItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"ScheduleCell";
	ScheduleCell *cell = (ScheduleCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil) {
		//IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"ScheduleCell" bundle:nil];
		cell = (ScheduleCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.backgroundImage.layer.cornerRadius = 8;
	}
	
	//Customize cell
    
    NSString *hourTime = [[[scheduleItems objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
    IcalEvent *anEvent = [[[scheduleItems objectAtIndex:indexPath.row] allObjects] objectAtIndex:0];
    NSString *shortHourTime = [hourTime substringToIndex:5];
    [cell.hourLabel setText:shortHourTime];
    [cell.subjectLabel setText:[anEvent summary]];
    [cell.classLabel setText:[anEvent location]];
    [cell.backgroundImage setBackgroundColor:[hoursRowsColorDict objectForKey:hourTime]];

    return cell;
}

#pragma mark - Gestures Delegates

- (void)initializeGestureRecognizer {
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self dayBeforePressed:self];
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self dayAfterPressed:self];
    }
}


@end
