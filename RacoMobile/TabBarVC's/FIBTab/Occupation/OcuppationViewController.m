//
//  OcuppationViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OcuppationViewController.h"
#import "OcupattionDetailViewController.h"
#import "Aula.h"
#import "Defines.h"
#import "OccupationCell.h"


@implementation OcuppationViewController

@synthesize occupationTableView;
@synthesize aulas;

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
    [self setOccupationTableView:nil];
    [self setAulas:nil];
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
    self.navigationItem.title = NSLocalizableString(@"_OccupationNavTitle");
	
	Aula *A5 = [[[Aula alloc] initWithName:NSLocalizableString(@"_occupationA5") url:kA5PNGUrl tag:KA5Tag] autorelease];
	Aula *B5 = [[[Aula alloc] initWithName:NSLocalizableString(@"_occupationB5") url:kB5PNGUrl tag:KB5Tag] autorelease];
	Aula *C6 = [[[Aula alloc] initWithName:NSLocalizableString(@"_occupationC6") url:kC6PNGUrl tag:KC6Tag] autorelease];
	
	self.aulas = [[[NSMutableArray alloc] initWithObjects:A5,B5,C6,nil] autorelease];
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
    [occupationTableView deselectRowAtIndexPath:[occupationTableView indexPathForSelectedRow] animated:YES];
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
    return [aulas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"OccupationCell";
	OccupationCell *cell = (OccupationCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil) {
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"OccupationCell" bundle:nil];
		cell = (OccupationCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	
	//Customize cell
    
    [cell.titleLabel setText:[[[self aulas]objectAtIndex:indexPath.row]name]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Aula *aula = [[self aulas]objectAtIndex:indexPath.row];
	
	OcupattionDetailViewController *ocupattionDetailViewController = [[OcupattionDetailViewController alloc]init];
	ocupattionDetailViewController.title = aula.name;
    [ocupattionDetailViewController setPlaceTag:[aula tag]];
	[self.navigationController pushViewController:ocupattionDetailViewController animated:YES];
	[ocupattionDetailViewController changeImageUrl:aula.url];
	[ocupattionDetailViewController release];
}

@end
