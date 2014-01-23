//
//  FibSubjectsViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FibSubjectsViewController.h"
#import "Subject.h"
#import "FibSubjectDetailViewController.h"
#import "RacoMobileAppDelegate.h"
#import "Defines.h"
#import "RacoMobileAppDelegate+ActivityView.h"
#import "FibSubjectCell.h"

@interface FibSubjectsViewController()
- (void)refreshFibSubjects;
@end

@implementation FibSubjectsViewController

@synthesize fibSubjectsTableView, fibSubjectsArray;

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
    [self setFibSubjectsTableView:nil];
    [self setFibSubjectsArray:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"allFibSubjectsLoaded" object:nil];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"allFibSubjectsLoaded" object:nil];
    
    //Add refresh button to navigationBar
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFibSubjects)];
    [self.navigationItem setRightBarButtonItem:refreshButton];
    [refreshButton release];
    
    //Retrieve FibSubjects
    [[FibSubjectsHandler sharedHandler] sortFibSubjects];
    fibSubjectsArray = [[NSMutableArray alloc] initWithArray:[[FibSubjectsHandler sharedHandler] fibSubjects]];
    
    if ([self.fibSubjectsArray count]==0) {
        //No results..
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Deselect Row
    [fibSubjectsTableView deselectRowAtIndexPath:[fibSubjectsTableView indexPathForSelectedRow] animated:YES];
    
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_grauEnginyInfor");
}

#pragma mark - Private Methods

- (void)refreshFibSubjects {
    
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];    
    //ShowActivityViewer
    [delegate showActivityViewer];
    
    //Refresh FibSubjectsData
    [delegate refreshFibSubjectsDataAlways];
}

- (void)reloadTableView {
    //Retrieve FibSubjects
    [[FibSubjectsHandler sharedHandler] sortFibSubjects];
    fibSubjectsArray = [[NSMutableArray alloc] initWithArray:[[FibSubjectsHandler sharedHandler] fibSubjects]];
    
    [fibSubjectsTableView reloadData];
}

#pragma mark - TableView Delegates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fibSubjectsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"FibSubjectCell";
	FibSubjectCell *cell = (FibSubjectCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil) {
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"FibSubjectCell" bundle:nil];
		cell = (FibSubjectCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	
	//Customize cell
    
    Subject *aSubject = [fibSubjectsArray objectAtIndex:indexPath.row];
    
    [cell.titleLabel setText:[aSubject idAssig]];
    [cell.descriptionLabel setText:[aSubject nom]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set the NavigationBar title back to make short the back button on next view
    [[self navigationItem] setTitle:NSLocalizableString(@"_back")];
    
    Subject *aSubject = [[self fibSubjectsArray]objectAtIndex:indexPath.row];
	
	FibSubjectDetailViewController *fibSubjectDetailViewController = [[FibSubjectDetailViewController alloc]init];
    [fibSubjectDetailViewController setSubjectTag:[aSubject codi_upc]];
    [fibSubjectDetailViewController setSubjectId:[aSubject idAssig]];
	[self.navigationController pushViewController:fibSubjectDetailViewController animated:YES];
	[fibSubjectDetailViewController release];
}


@end
