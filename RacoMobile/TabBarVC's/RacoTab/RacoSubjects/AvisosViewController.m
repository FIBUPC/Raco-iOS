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


@implementation AvisosViewController

@synthesize avisosTableView, avisosArray;
@synthesize avisTag;
@synthesize selectedAvisTitle, selectedAvisIndex;
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
    [self setSelectedAvisTitle:nil];
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
    return 90;
}

/* 
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 //Not used for one section
 }
 */

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
        
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        cell.myNoticeImage.image = [UIImage imageNamed:@"notice-icon.png"];
	}
	
	//Customize cell
    
    Avis *anAvis = [avisosArray objectAtIndex:indexPath.row];
    
    cell.myTitleLabel.text = [anAvis title];
    cell.myDateLabel.text = [anAvis pubDate];
    
    //Scroll to selectedMail position if exist and show selected
    if ([selectedAvisTitle isEqualToString:[anAvis title]]) {
        [cell.myBackgroundImage setBackgroundColor:[UIColor lightGrayColor]];
        [avisosTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
	return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert)
 {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

/*
 -(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 //Mod 2 par/impar
 if (indexPath.row % 2)
 {
 [cell setBackgroundColor:[UIColor colorWithRed:.85 green:.85 blue:.85 alpha:1]];
 }
 else [cell setBackgroundColor:[UIColor clearColor]];
 }
 */

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 return @"...";
 }
 */


@end
