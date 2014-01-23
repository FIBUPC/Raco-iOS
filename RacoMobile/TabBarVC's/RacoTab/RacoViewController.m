//
//  RacoViewController.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 25/03/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "RacoViewController.h"
#import "Defines.h"
#import "LoginViewController.h"
#import "RacoSubjectsViewController.h"
#import "MailsViewController.h"
#import "AgendaViewController.h"
#import "ScheduleViewController.h"
#import "RacoMobileAppDelegate+ActivityView.h"
#import "CommonTableCell.h"


@implementation RacoViewController

@synthesize racoTableView, racoItems;
@synthesize backgroundImage, loginButton, needLoginView, needToLoginLabel;

static NSString *racoRowItemNameKey = @"Name";
static NSString *racoRowItemImageKey = @"Image";
static NSString *racoRowItemImageSelectedKey = @"ImageSelected";
static NSString *racoRowItemViewKey = @"View";

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
    [self setNeedLoginView:nil];
    [self setNeedToLoginLabel:nil];
    [self setLoginButton:nil];
    [self setBackgroundImage:nil];
    [self setRacoItems:nil];
    [self setRacoTableView:nil];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Deselect Row
    [racoTableView deselectRowAtIndexPath:[racoTableView indexPathForSelectedRow] animated:YES];
    
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_RacoNavTitle");
    
    //Set the needToLoginLabel text
    [self.needToLoginLabel setText:NSLocalizableString(@"_needToLogin")];
    
    //Check if user is logged
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    logged = [delegate userIsLogged];
    
    //Hide or show racoTableView to show login background
    if (!logged) { 
        DLog(@"hidden yes");
        [[self racoTableView] setHidden:YES];
        [self.backgroundImage setHidden:YES];
        [self.loginButton setEnabled:YES];
        [self.needLoginView setHidden:NO];
        [self openLoginViewController];
    }
    else {
        DLog(@"hidden no");
        [[self racoTableView] setHidden:NO];
        [self.backgroundImage setHidden:NO];
        [self.loginButton setEnabled:NO];
        [self.needLoginView setHidden:YES];
    }
    
    //Initialize Table items
    NSDictionary *mySubjects = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToMySubjects"),
                                                                      @"raco_icon_my_subjects.png",
                                                                      @"raco_icon_my_subjects_.png",
                                                                      @"RacoSubjectsViewController",nil]  
                                                             forKeys:[NSArray arrayWithObjects:racoRowItemNameKey,
                                                                      racoRowItemImageKey,
                                                                      racoRowItemImageSelectedKey,
                                                                      racoRowItemViewKey,nil]];
    NSDictionary *myAgenda = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToAgenda"),
                                                                    @"raco_icon_my_agenda.png",
                                                                    @"raco_icon_my_agenda_.png",
                                                                    @"AgendaViewController",nil]  
                                                           forKeys:[NSArray arrayWithObjects:racoRowItemNameKey,
                                                                    racoRowItemImageKey,
                                                                    racoRowItemImageSelectedKey,
                                                                    racoRowItemViewKey,nil]];
    NSDictionary *mySchedule = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToSchedule"),
                                                                      @"raco_icon_my_schedule.png",
                                                                      @"raco_icon_my_schedule_.png",
                                                                      @"ScheduleViewController",nil]  
                                                             forKeys:[NSArray arrayWithObjects:racoRowItemNameKey,
                                                                      racoRowItemImageKey,
                                                                      racoRowItemImageSelectedKey,
                                                                      racoRowItemViewKey,nil]];
    NSDictionary *myMail = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToMail"),
                                                                  @"raco_icon_my_mail.png",
                                                                  @"raco_icon_my_mail_.png",
                                                                  @"MailsViewController",nil]  
                                                         forKeys:[NSArray arrayWithObjects:racoRowItemNameKey,
                                                                  racoRowItemImageKey,
                                                                  racoRowItemImageSelectedKey,
                                                                  racoRowItemViewKey,nil]];
    
    self.racoItems = [[[NSMutableArray alloc] initWithObjects:mySubjects, myAgenda, mySchedule, myMail, nil] autorelease];
    [mySubjects release];
    [myAgenda release];
    [mySchedule release];
    [myMail release];
    
    //Reload all Data if lagunage has changed
    RacoMobileAppDelegate *appDelegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([appDelegate languageHasChanged]) {
        [racoTableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

- (IBAction)needToLoginImagePressed:(id)sender {
    [self openLoginViewController];
}

- (void)openLoginViewController {
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [loginViewController view];//viewDidLoad fired!
    [self presentModalViewController:loginViewController animated:YES];
    [loginViewController release];
}

#pragma mark - TableView Delegates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [racoItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifierFIB = @"CommonTableCell";
	CommonTableCell *cell = (CommonTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierFIB];
    
    NSDictionary *anItem = [racoItems objectAtIndex:indexPath.row];
    
	if (cell == nil) {
		//IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"CommonTableCell" bundle:nil];
		cell = (CommonTableCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //Set name from iconImage for selected style
        cell.iconImageName = [anItem objectForKey:racoRowItemImageKey];
        cell.iconImageNameSelected = [anItem objectForKey:racoRowItemImageSelectedKey];
	}
	
	//Customize cell
    
    [cell.titleLabel setText:[anItem objectForKey:racoRowItemNameKey]];
    
    [cell.iconImage setContentMode:UIViewContentModeScaleAspectFit];
    [cell.iconImage setImage:[UIImage imageNamed:[anItem objectForKey:racoRowItemImageKey]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the nib name
    NSDictionary *anItem = [racoItems objectAtIndex:indexPath.row];
    NSString *nibName = [anItem objectForKey:racoRowItemViewKey];
    
    if ([nibName isEqualToString:@"RacoSubjectsViewController"]) {
        RacoSubjectsViewController *racoSubjectsViewController = [[RacoSubjectsViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [racoSubjectsViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:racoSubjectsViewController animated:YES];
        [racoSubjectsViewController release];
    }
    else if ([nibName isEqualToString:@"AgendaViewController"]) {
        AgendaViewController *agendaViewController = [[AgendaViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [agendaViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:agendaViewController animated:YES];
        [agendaViewController release];
    }
    else if ([nibName isEqualToString:@"ScheduleViewController"]) {        
        ScheduleViewController *scheduleViewController = [[ScheduleViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [scheduleViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:scheduleViewController animated:YES];
        [scheduleViewController release];
    }
    else if ([nibName isEqualToString:@"MailsViewController"]) {
        MailsViewController *mailsViewController = [[MailsViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [mailsViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:mailsViewController animated:YES];
        [mailsViewController release];
    }
}


@end
