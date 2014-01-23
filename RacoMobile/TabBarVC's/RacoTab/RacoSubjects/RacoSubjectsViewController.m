//
//  RacoSubjectsViewController.m
//  iRaco
//
//  Created by LCFIB on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RacoSubjectsViewController.h"
#import "Defines.h"
#import "Subject.h"
#import "AvisosViewController.h"


@implementation RacoSubjectsViewController

@synthesize racoSubjectsTableView, racoSubjectsArray;

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
    [self setRacoSubjectsTableView:nil];
    [self setRacoSubjectsArray:nil];
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
    
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_RacoSubjectsNavTitle");
    
    //Retrieve RacoSubjects
    racoSubjectsArray = [[NSMutableArray alloc] initWithArray:[[RacoSubjectsHandler sharedHandler] racoSubjects]];
    
    if ([self.racoSubjectsArray count]==0) {
        //No results..
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Set the NavigationBarTitle to @"_RacoSubjectsNavTitle" when view apperar after back button on popviewcontroller
    self.navigationItem.title = NSLocalizableString(@"_RacoSubjectsNavTitle");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView Delegates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [racoSubjectsArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Configure the cell.
    
    Subject *aSubject = [racoSubjectsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [aSubject idAssig];
    cell.detailTextLabel.text = [aSubject nom];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Subject *aSubject = [[self racoSubjectsArray]objectAtIndex:indexPath.row];
	
	AvisosViewController *avisosViewController = [[AvisosViewController alloc]init];
    //Set the NavigationBarTitle to @"Back" for automatic backbutton i pushviewcontroller
    self.navigationItem.title = @"Back";
    [avisosViewController setAvisTag:[aSubject idAssig]];
	[self.navigationController pushViewController:avisosViewController animated:YES];
	[avisosViewController release];
    
    //Deselect Row
    [racoSubjectsTableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
