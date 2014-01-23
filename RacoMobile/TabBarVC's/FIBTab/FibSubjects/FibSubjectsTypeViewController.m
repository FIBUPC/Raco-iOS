//
//  FibSubjectsTypeViewController.m
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 17/11/11.
//  Copyright (c) 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "FibSubjectsTypeViewController.h"
#import "Defines.h"
#import "OccupationCell.h"
#import "FibSubjectsViewController.h"

@implementation FibSubjectsTypeViewController

@synthesize subjectsTableView;
@synthesize subjectsType;

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
    [self setSubjectsTableView:nil];
    [self setSubjectsType:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.subjectsType = [[[NSMutableArray alloc] initWithObjects:NSLocalizableString(@"_grauEnginyInfor"),nil] autorelease];
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
    [subjectsTableView deselectRowAtIndexPath:[subjectsTableView indexPathForSelectedRow] animated:YES];
    
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_FibSubjectsTypeNavTitle");
}



#pragma mark - TableView Delegates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [subjectsType count];
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
    
    [cell.titleLabel setText:[[self subjectsType]objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the view name
    NSString *viewName = [subjectsType objectAtIndex:indexPath.row];
    
    //Set the NavigationBar title back to make short the back button on next view
    [[self navigationItem] setTitle:NSLocalizableString(@"_back")];
    
    if ([viewName isEqualToString:NSLocalizableString(@"_grauEnginyInfor")]) {
        FibSubjectsViewController *fibSubjectsViewController = [[FibSubjectsViewController alloc] initWithNibName:@"FibSubjectsViewController" bundle:nil];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:fibSubjectsViewController animated:YES];
        [fibSubjectsViewController release];
    }
}


@end
