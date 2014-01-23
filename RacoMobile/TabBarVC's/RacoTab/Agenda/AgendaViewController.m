//
//  AgendaViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AgendaViewController.h"
#import "IcalEvent.h"
#import "RacoMobileAppDelegate.h"
#import "Defines.h"
#import "RacoMobileAppDelegate+ActivityView.h"
#import "Utils.h"
#import "AgendaCell.h"

@interface AgendaViewController ()
- (void)addTodayRowToAgendaItems;
- (void)scrollToTodayRow;
@end

@implementation AgendaViewController

@synthesize agendaTableView, agendaItems;
@synthesize underButtonView, syncronizeButton, syncronizeLabel;
@synthesize todayIndex;
@synthesize todayButton;
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
    [self setUnderButtonView:nil];
    [self setSyncronizeButton:nil];
    [self setSyncronizeLabel:nil];
    [self setAgendaTableView:nil];
    [self setAgendaItems:nil];
    [self setTodayButton:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"agendaDataLoaded" object:nil];
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
    
    //Regiter Notification for self
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"agendaDataLoaded" object:nil];
    
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_AgendaNavTitle");
    
    //Set updatedLabel text
    NSDate *updatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"AgendaUpdatedDate"];
    [updatedLabel setText:[NSString stringWithFormat:@" %@: %@",NSLocalizableString(@"_lastUpdate"),[Utils stringWithHourFromDate:updatedDate]]];
    
    //Set syncronizeLabez localized text
    [syncronizeLabel setText:NSLocalizableString(@"_synchronizeAgenda")];
    
    //Add todayButton to navigationBar
    todayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizableString(@"_today") style:UIBarButtonItemStylePlain target:self action:@selector(scrollToTodayRow)];
    self.navigationItem.rightBarButtonItem = todayButton;
    
    //Retrieve AgendaEvents
    [[AgendaIcsHandler sharedHandler] sortAgendaEvents];
    agendaItems = [[NSMutableArray alloc] initWithArray:[[AgendaIcsHandler sharedHandler] agenda]];
    
    if ([self.agendaItems count]==0) {
        //No results..
        //Disable TodayButton
        [todayButton setEnabled:NO];
    }
    
    if (agendaItems) {
        //Add "Today" row to "agendaItems"
        [self addTodayRowToAgendaItems];
    
        [self scrollToTodayRow];
    }
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

#pragma mark - Private Methods

- (void)reloadTableView {
    //Retrieve AgendaEvents
    [[AgendaIcsHandler sharedHandler] sortAgendaEvents];
    agendaItems = [[NSMutableArray alloc] initWithArray:[[AgendaIcsHandler sharedHandler] agenda]];
    
    if (agendaItems) {
        //Add "Today" row to "agendaItems"
        [self addTodayRowToAgendaItems];
        
        [self scrollToTodayRow];
    }
    
    [agendaTableView reloadData];
}

- (void)scrollToTodayRow {
    if (agendaItems) {
        //Scroll tableview to "Today" index
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:todayIndex inSection:0];
        [[self agendaTableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)SynchronizeAgenda:(id)sender{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *icalPortadaIcsKey = [userDefaults objectForKey:kIcalPortadaIcsKey];
	
	NSString *urlAgenda = [NSString stringWithFormat:@"%@%@",kAgendaIcsSyncronizeUrl,icalPortadaIcsKey];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAgenda]];
}

- (void)addTodayRowToAgendaItems{
    int index = 0;
    NSDate *actualDate      = [NSDate date];
    NSString *actualStringDate = [NSDateFormatter localizedStringFromDate:actualDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle]; //05/05/2011 18:21:15
    
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier] autorelease];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:enUSPOSIXLocale];
    [dateFormat setDateFormat:@"dd/MM/y HH:mm:ss"];  //"06/04/2011 13:15:34"
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:kTimeZoneName]];
    
    actualDate = [dateFormat dateFromString:actualStringDate];
    
    //Search index to add "Today" object
    int i = 0;
    NSDate *eventDate;
    for (IcalEvent *anEvent in agendaItems) {
        eventDate = [anEvent compareDate];
        if ([eventDate compare:actualDate] == NSOrderedAscending) {
            index = i;
            [self setTodayIndex:index];
            break;
        }
        i++;
    }
    
    [dateFormat release];
    
    //Not used...
    //NSString *hour = [actualStringDate substringFromIndex:11]; //05/05/2011 18:21:15
    //hour = [hour substringToIndex:5];   //18:21:15
    
    NSDictionary *todayDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:actualStringDate,actualStringDate,actualStringDate,NSLocalizableString(@"_today"),@"",@"",nil]  
                                                             forKeys:[NSArray arrayWithObjects:@"DTSTAMP",@"DTSTART",@"DTEND",@"SUMMARY",@"LOCATION",@"UID",nil]];
    
    //Add Today event object
    IcalEvent *todayEvent = [[IcalEvent alloc] initWithDictionary:todayDict];
    [todayDict release];

    [agendaItems insertObject:todayEvent atIndex:i];
    [todayEvent release];
}

- (void)refreshAgenda:(id)sender {
    
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];    
    //ShowActivityViewer
    [delegate showActivityViewer];
    
    //Refresh AgendaData
    [delegate refreshAgendaDataAlways];
    
    //Reload updatedLabel text
    NSDate *updatedDate = [NSDate date];
    [updatedLabel setText:[NSString stringWithFormat:@" %@: %@",NSLocalizableString(@"_lastUpdate"),[Utils stringWithHourFromDate:updatedDate]]];
}

#pragma mark - TableView Delegates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [agendaItems count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizableString(@"_agendaTableHeader");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return NSLocalizableString(@"_agendaTableFooter");
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"AgendaCell";
	AgendaCell *cell = (AgendaCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil) {
		//IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"AgendaCell" bundle:nil];
		cell = (AgendaCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	
    // Configure the cell.
    
    IcalEvent *anEvent = [agendaItems objectAtIndex:indexPath.row];
    [cell.titleLabel setText:[anEvent summary]];
    
    if (indexPath.row == todayIndex) {
        NSDate *updatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"AgendaUpdatedDate"];
        [cell.dateLabel setText:[Utils stringWithHourFromDate:updatedDate]];
        [cell.dateLabel setTextColor:[UIColor whiteColor]];
    }
    else {
        //Take only date from largeDate
        NSString *normalDate = @"";
        @try {
            normalDate = [[anEvent dateStart] substringToIndex:10];   //dd/mm/aaaa
        }
        @catch (NSException *exception) {
            normalDate = NSLocalizableString(@"_no_date");
        }
        
        if ([anEvent startHour]) {
            //StartHour defined
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@ %@-%@",normalDate,[anEvent startHour],[anEvent endHour]]];
        }
        else {
            //StartHour not defined, so put "All day"
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@ %@",normalDate,NSLocalizableString(@"_allDay")]];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AgendaCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Customize TodayObject
    if (indexPath.row == todayIndex)
    {
        [cell.titleLabel setTextColor:[UIColor whiteColor]];
        [cell.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
        [cell.backgroundImage setImage:[UIImage imageNamed:@"raco_mi_agenda_banda_ahora.png"]];
    }
    else {
        //Set blue colors for future events and red colors for past events
        if (indexPath.row < todayIndex) {
            //Future events
            if (indexPath.row % 2)
            {
                [cell.backgroundImage setBackgroundColor:[UIColor colorWithRed:210/255.0 green:240/255.0 blue:254/255.0 alpha:1]];
            }
            else [cell.backgroundImage setBackgroundColor:[UIColor colorWithRed:179/255.0 green:232/255.0 blue:250/255.0 alpha:1]];
        }
        else {
            //Past events
            if (indexPath.row % 2)
            {
                [cell.backgroundImage setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]];
            }
            else [cell.backgroundImage setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
        }
    }
}


@end
