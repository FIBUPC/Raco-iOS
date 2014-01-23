//
//  AvisosViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AvisosViewController.h"
#import "Avis.h"
#import "AvisCell.h"
#import "RacoMobileAppDelegate.h"
#import "Defines.h"
#import "AvisosDetailViewController.h"


@implementation AvisosViewController

@synthesize avisosTableView, avisosArray;
@synthesize avisTag;
@synthesize noResultsView, noNoticesLabel;

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
    [self setNoResultsView:nil];
    [self setNoNoticesLabel:nil];
    [self setAvisosTableView:nil];
    [self setAvisosArray:nil];
    [self setAvisTag:nil];
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
    self.navigationItem.title = NSLocalizableString(@"_AvisosNavTitle");
    
    //Set noNoticesLabel text
    [noNoticesLabel setText:NSLocalizableString(@"_noAvisos")];
    
    //Retrieve avisos
    avisosArray = [[NSMutableArray alloc] initWithArray:[[AvisosHandler sharedHandler] retrieveAvisosArrayWithTag:avisTag]];
    
    [avisosTableView reloadData];
    if ([self.avisosArray count]==0) {
        //Show noResultsView
        [noResultsView setHidden:NO];
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

#pragma mark tableView

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [avisosArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifierAvis = @"AvisCell";
	AvisCell *cell = (AvisCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierAvis];
    
	if (cell == nil) {
		//IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"AvisCell" bundle:nil];
		cell = (AvisCell*)ctl.view;
		[ctl release];
        
        cell.myNoticeImage.image = [UIImage imageNamed:@"headlines_icon_notice.png"];
        [cell.myNoticeImage setContentMode:UIViewContentModeScaleAspectFit];
	}
	
	//Customize cell
    
    Avis *anAvis = [avisosArray objectAtIndex:indexPath.row];
    
    cell.myTitleLabel.text = [anAvis title];
    cell.myDateLabel.text = [anAvis pubDate];
    
	return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AvisCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Mod 2 par/impar
    if (indexPath.row % 2)
    {
        [cell.myBackgroundImage setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]];
    }
    else [cell.myBackgroundImage setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Avis *selectedAvis = [avisosArray objectAtIndex:indexPath.row];
    
    AvisosDetailViewController *avisosDetailViewController = [[AvisosDetailViewController alloc] initWithNibName:@"AvisosDetailViewController" bundle:nil];
    [avisosDetailViewController setAvisDetail:selectedAvis];
    [self.navigationController pushViewController:avisosDetailViewController animated:YES];
    [avisosDetailViewController release];
    
    //Deselect Row
    [avisosTableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
