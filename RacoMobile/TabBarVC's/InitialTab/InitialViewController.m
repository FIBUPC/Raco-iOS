//
//  Initial2ViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InitialViewController.h"
#import "Defines.h"
#import "LoginViewController.h"
#import "ItemProtocol.h"
#import "Mail.h"
#import "NewRss.h"
#import "Avis.h"
#import "RacoMobileAppDelegate.h"
#import "NoticiaTextViewController.h"
#import "MailsViewController.h"
#import "AvisosDetailViewController.h"
#import "InitialSettingsViewController.h"
#import "RacoMobileAppDelegate.h"
#import "InitialTableCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation InitialViewController

@synthesize itemsTableView;
@synthesize itemsArray;
@synthesize mailsArray, newsArray, noticeArray;

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
    [self setItemsArray:nil];
    [self setMailsArray:nil];
    [self setNewsArray:nil];
    [self setNoticeArray:nil];
    [self setItemsTableView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"allHeadlinesDataLoaded" object:nil];
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
    
    //Add reload button to navigation bar
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadAllData)];
    [[self navigationItem] setLeftBarButtonItem:reloadButton];
    [reloadButton release];
    
    
    //Load itemsArray nil
    itemsArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    //Check if InitialData is Loaded
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    bool isInitialDataLoaded = [delegate isInitialDataLoaded];
    if (isInitialDataLoaded) {
        //Refresh TableView Data
        [self refreshTableView];
    }
    
    //Regiter Notification for self
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"allHeadlinesDataLoaded" object:nil];
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
    [itemsTableView deselectRowAtIndexPath:[itemsTableView indexPathForSelectedRow] animated:YES];
    
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_InitialNavTitle");
    
    //Add initialSettingsButton
    UIBarButtonItem *initialSettingsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizableString(@"_initialSettingsNavTitle") style:UIBarButtonItemStyleBordered target:self action:@selector(goToInitialPriorizer)];
    self.navigationItem.rightBarButtonItem = initialSettingsButton;
    [initialSettingsButton release];
    
    //Reload all Data if lagunage has changed
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([delegate languageHasChanged]) {
        [itemsTableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}

#pragma mark - Public Methods

- (void)refreshTableView{
    //Method called to refresh data on TableView
    DLog(@"Enter on refreshTable rooteviewController");
    
    //Check if user is logged
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    logged = [delegate userIsLogged];
    
    //Retrieve news
    newsArray = [[NSMutableArray alloc] initWithArray:[[NewsHandler sharedHandler] retrieveNewsArrayWithNumber:[KMaxNumberItems intValue]]];

    if ([self.newsArray count]==0) {
        newsArray = [[NSMutableArray alloc] init];
        NSDictionary *aNew = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_noNews"),@"",@"",@"",@"",@"",nil]  
                                                            forKeys:[NSArray arrayWithObjects:kNewTitle,kNewDescription,kNewLink,kNewTGuid,kNewPubDate,kNewThumb,nil]];
        NewRss *emptyNew = [[NewRss alloc] initWithDictionary:aNew];
        [newsArray addObject:emptyNew];
        [aNew release];
        [emptyNew release];
    }
    
    //Retrieve mails
    mailsArray = [[NSMutableArray alloc] initWithArray:[[MailHandler sharedHandler] retrieveMailsArrayWithNumber:[KMaxNumberItems intValue]]];

    if (logged) {
        DLog(@"I'm logged (mails)");
        //Check if is empty
        if ([self.mailsArray count]==0) {
            mailsArray = [[NSMutableArray alloc] init];
            NSDictionary *aMail = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_noMails"),@"",@"",@"",@"",@"",nil]  
                                                                forKeys:[NSArray arrayWithObjects:kMailSubject,kMailFrom,kMailDate,kMailUnseen,kMailUrl,kMailDeleted,nil]];
            Mail *emptyMail = [[Mail alloc] initWithDictionary:aMail];
            [mailsArray addObject:emptyMail];
            [aMail release];
            [emptyMail release];
        }
    }
    else {
        DLog(@"I'm not logged (mails)");
        mailsArray = [[NSMutableArray alloc] init];
        NSDictionary *aMail = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_enterLogin"),@"",@"",@"",@"",@"",nil]  
                                                            forKeys:[NSArray arrayWithObjects:kMailSubject,kMailFrom,kMailDate,kMailUnseen,kMailUrl,kMailDeleted,nil]];
        Mail *notLoggedMail = [[Mail alloc] initWithDictionary:aMail];
        [mailsArray addObject:notLoggedMail];
        [aMail release];
        [notLoggedMail release];
    }
    
    //Retrieve avisos
    noticeArray = [[NSMutableArray alloc] initWithArray:[[AvisosHandler sharedHandler] retrieveAvisosArrayWithNumber:[KMaxNumberItems intValue]]];

    if (logged) {
        DLog(@"I'm logged (avisos)");
        //Check if is empty
        if ([self.noticeArray count]==0) {
            noticeArray = [[NSMutableArray alloc] init];
            NSDictionary *aNotice = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_noAvisos"),@"",@"",@"",@"",nil]  
                                                                forKeys:[NSArray arrayWithObjects:kAvisTitle,kAvisLink,kAvisDescription,kAvisPubDate,kAvisCategory,nil]];
            Avis *emptyNotice = [[Avis alloc] initWithDictionary:aNotice];
            [noticeArray addObject:emptyNotice];
            [aNotice release];
            [emptyNotice release];
        }
    }
    else {
        DLog(@"I'm not logged (avisos)");
        noticeArray = [[NSMutableArray alloc] init];
        NSDictionary *aNotice = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_enterLogin"),@"",@"",@"",@"",nil]  
                                                              forKeys:[NSArray arrayWithObjects:kAvisTitle,kAvisLink,kAvisDescription,kAvisPubDate,kAvisCategory,nil]];
        Avis *emptyNotice = [[Avis alloc] initWithDictionary:aNotice];
        [noticeArray addObject:emptyNotice];
        [aNotice release];
        [emptyNotice release];
    }
    
    [self setPrioriyToTableItems];
}

#pragma mark - Private Methods

- (void)reloadAllData {
    //Call to downloadInitialServices from AppDelegate
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate downloadInitialServices];
}

- (void)insertItemsToArrayWithPriority {
    [[self itemsArray] removeAllObjects];
    DLog(@"index mails: %i",[[[NSUserDefaults standardUserDefaults] objectForKey:kMailKey] intValue]);
    DLog(@"index notices: %i",[[[NSUserDefaults standardUserDefaults] objectForKey:kNoticesKey] intValue]);
    DLog(@"index News: %i",[[[NSUserDefaults standardUserDefaults] objectForKey:kNewsKey] intValue]);
    
    int mailIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kMailKey] intValue];
    int noticesIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kNoticesKey] intValue];
    int newsIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewsKey] intValue];
    
    if ( (mailIndex == 0) && (noticesIndex == 1) ) {
        [[self itemsArray] addObject:mailsArray];
        [[self itemsArray] addObject:noticeArray];
        [[self itemsArray] addObject:newsArray];
    }
    else if ( (mailIndex == 0) && (newsIndex == 1) ) {
        [[self itemsArray] addObject:mailsArray];
        [[self itemsArray] addObject:newsArray];
        [[self itemsArray] addObject:noticeArray];
    }
    else if ( (noticesIndex == 0) && (newsIndex == 1) ) {
        [[self itemsArray] addObject:noticeArray];
        [[self itemsArray] addObject:newsArray];
        [[self itemsArray] addObject:mailsArray];
    }
    else if ( (noticesIndex == 0) && (mailIndex == 1) ) {
        [[self itemsArray] addObject:noticeArray];
        [[self itemsArray] addObject:mailsArray];
        [[self itemsArray] addObject:newsArray];
    }
    else if ( (newsIndex == 0) && (mailIndex == 1) ) {
        [[self itemsArray] addObject:newsArray];
        [[self itemsArray] addObject:mailsArray];
        [[self itemsArray] addObject:noticeArray];
    }
    else if ( (newsIndex == 0) && (noticesIndex == 1) ) {
        [[self itemsArray] addObject:newsArray];
        [[self itemsArray] addObject:noticeArray];
        [[self itemsArray] addObject:mailsArray];
    }
}

- (void)setPrioriyToTableItems {
    //Insert Arrays to itemsArray with priority
    [self insertItemsToArrayWithPriority];
    
    //Reload tableView Data
    [[self itemsTableView] reloadData];
}

- (void)openLoginModalViewController {
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [loginVC view];//viewDidLoad fired!
    [self presentModalViewController:loginVC animated:YES];
    [loginVC release];
}

- (void)goToInitialPriorizer {
    InitialSettingsViewController *initialSettingsViewController = [[InitialSettingsViewController alloc] initWithNibName:@"InitialSettingsViewController" bundle:nil];
    [initialSettingsViewController setParentVC:self];
    initialSettingsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [initialSettingsViewController view];//viewDidLoad fired!
    [self presentModalViewController:initialSettingsViewController animated:YES];
    [initialSettingsViewController release];
}

#pragma mark - TableView Delegates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [itemsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[itemsArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *item = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"section%i",section]];
    
    if([item isEqualToString:kMailKey]) {
        return NSLocalizableString(@"_mails");
    }
    else if([item isEqualToString:kNoticesKey]) {
        return NSLocalizableString(@"_notices");
    }
    else return NSLocalizableString(@"_news");
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
    [headerView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 11, tableView.bounds.size.width, 18)] autorelease];
    label.text = [NSString stringWithFormat:@"   %@",[self tableView:itemsTableView titleForHeaderInSection:section]];
    label.textColor = [UIColor colorWithRed:3/255.0 green:146/255.0 blue:208/255.0 alpha:1];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifierInitial = @"CommonTableCell";
	InitialTableCell *cell = (InitialTableCell*)[itemsTableView dequeueReusableCellWithIdentifier:cellIdentifierInitial];
    
    NSArray *sectionArray = [itemsArray objectAtIndex:indexPath.section];
    id <ItemProtocol> commonItem = [sectionArray objectAtIndex:indexPath.row];
    
	if (cell == nil) {
        //IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"InitialTableCell" bundle:nil];
		cell = (InitialTableCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    //Customize cell
    
    [cell.titleLabel setText:[commonItem commonItemTitle]];
    [cell.dateLabel setText:[commonItem commonItemDate]];
    
    [cell.iconImage setContentMode:UIViewContentModeScaleAspectFit];
    [cell.iconImage setImage:[UIImage imageNamed:[commonItem commonItemIcon]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *item = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"section%i",indexPath.section]];
    
    NSArray *sectionArray = [itemsArray objectAtIndex:indexPath.section];
    id <ItemProtocol> commonItem = [sectionArray objectAtIndex:indexPath.row];
    
    if (!logged) {
        if ([item isEqualToString:kMailKey] || [item isEqualToString:kNoticesKey]) {            
            LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [loginViewController view];//viewDidLoad fired!
            [self presentModalViewController:loginViewController animated:YES];
            [loginViewController release];
        }
    }
    else {
        if ([item isEqualToString:kMailKey]) {
            MailsViewController *mailsViewController = [[MailsViewController alloc] initWithNibName:@"MailsViewController" bundle:nil];
            //HidesBottomBarWhenPushed
            [mailsViewController setHidesBottomBarWhenPushed:YES];
            [mailsViewController setSelectedMailSubject:[commonItem commonItemTitle]];
            [mailsViewController setSelectedMailDate:[commonItem commonItemDate]];
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:mailsViewController animated:YES];
            [mailsViewController release];
        }
        else if ([item isEqualToString:kNoticesKey]) {
            NSArray *sectionArray = [itemsArray objectAtIndex:indexPath.section];
            Avis *anAvis = [sectionArray objectAtIndex:indexPath.row];
            NSString *titleWithTag = [anAvis title];
            
            NSString *search = @" - ";
            //Substring to index "search index" -3 (space-space)
            NSString *avisTag;
            @try {
                avisTag = [titleWithTag substringToIndex:NSMaxRange([titleWithTag rangeOfString:search])-3];
            }
            @catch (NSException *exception) {
                avisTag = @"";
            }
            
            AvisosDetailViewController *avisosDetailViewController = [[AvisosDetailViewController alloc] initWithNibName:@"AvisosDetailViewController" bundle:nil];
            //HidesBottomBarWhenPushed
            [avisosDetailViewController setHidesBottomBarWhenPushed:YES];
            //Set the avisDetail
            [avisosDetailViewController setAvisDetail:[sectionArray objectAtIndex:indexPath.row]];
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:avisosDetailViewController animated:YES];
            [avisosDetailViewController release];
        }
    }
    if ([item isEqualToString:kNewsKey]) {
        NSArray *sectionArray = [itemsArray objectAtIndex:indexPath.section];
        
        NoticiaTextViewController *noticiaTextViewController = [[NoticiaTextViewController alloc] initWithNibName:@"NoticiaTextViewController" bundle:nil];
        //HidesBottomBarWhenPushed
        [noticiaTextViewController setHidesBottomBarWhenPushed:YES];
        [noticiaTextViewController setMyNewRss:[sectionArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:noticiaTextViewController animated:YES];
        [noticiaTextViewController release];   
    }
}


@end