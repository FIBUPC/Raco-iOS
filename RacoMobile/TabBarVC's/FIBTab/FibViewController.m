//
//  FibViewController.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 25/03/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "FibViewController.h"
#import "Defines.h"
#import "OcuppationViewController.h"
#import "NewsViewController.h"
#import "MapFibViewController.h"
#import "FibSubjectsTypeViewController.h"
#import "RacoMobileAppDelegate.h"
#import "CommonTableCell.h"


@implementation FibViewController

@synthesize fibTableView;
@synthesize fibItems;

static NSString *fibRowItemNameKey = @"Name";
static NSString *fibRowItemImageKey = @"Image";
static NSString *fibRowItemImageSelectedKey = @"ImageSelected";
static NSString *fibRowItemViewKey = @"View";

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
    [self setFibTableView:nil];
    [self setFibItems:nil];
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
    DLog(@"I'm in fib vc appear");
    
    //Deselect Row
    [fibTableView deselectRowAtIndexPath:[fibTableView indexPathForSelectedRow] animated:YES];
    
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_FibNavTitle");
    
    //Initialize Table items
    NSDictionary *noticeItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToNews"),
                                                                      @"fib_icon_news.png",
                                                                      @"fib_icon_news_.png",
                                                                      @"NewsViewController",nil]  
                                                             forKeys:[NSArray arrayWithObjects:fibRowItemNameKey,
                                                                      fibRowItemImageKey,
                                                                      fibRowItemImageSelectedKey,
                                                                      fibRowItemViewKey,nil]];
    
    NSDictionary *subjectItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToFIBSubjects"),
                                                                       @"fib_icon_subjects.png",
                                                                       @"fib_icon_subjects_.png",
                                                                       @"FibSubjectsTypeViewController",nil]  
                                                              forKeys:[NSArray arrayWithObjects:fibRowItemNameKey,
                                                                       fibRowItemImageKey,
                                                                       fibRowItemImageSelectedKey,
                                                                       fibRowItemViewKey,nil]];
    
    NSDictionary *occupationItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToOccupation"),
                                                                          @"fib_icon_classrooms.png",
                                                                          @"fib_icon_classrooms_.png",
                                                                          @"OcuppationViewController",nil]  
                                                                 forKeys:[NSArray arrayWithObjects:fibRowItemNameKey,
                                                                          fibRowItemImageKey,
                                                                          fibRowItemImageSelectedKey,
                                                                          fibRowItemViewKey,nil]];
    
    NSDictionary *mapItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToFIB"),
                                                                   @"fib_icon_where_is.png",
                                                                   @"fib_icon_where_is_.png",
                                                                   @"MapFibViewController",nil]  
                                                          forKeys:[NSArray arrayWithObjects:fibRowItemNameKey,
                                                                   fibRowItemImageKey,
                                                                   fibRowItemImageSelectedKey,
                                                                   fibRowItemViewKey,nil]];
 
    NSDictionary *bilbioItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToBiblioteca"),
                                                                       @"fib_icon_subjects.png",
                                                                       @"fib_icon_subjects_.png",
                                                                       @"BibliotecaRunBrowser",nil]  
                                                              forKeys:[NSArray arrayWithObjects:fibRowItemNameKey,
                                                                       fibRowItemImageKey,
                                                                       fibRowItemImageSelectedKey,
                                                                       fibRowItemViewKey,nil]];
    
    self.fibItems = [[[NSMutableArray alloc] initWithObjects:noticeItem, subjectItem, occupationItem, mapItem, bilbioItem, nil] autorelease];
    [noticeItem release];
    [occupationItem release];
    [mapItem release];
    [subjectItem release];
    
    //Reload all Data if lagunage has changed
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([delegate languageHasChanged]) {
        [fibTableView reloadData];
    }
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
    return [fibItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifierFIB = @"CommonTableCell";
	CommonTableCell *cell = (CommonTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierFIB];
    
    NSDictionary *anItem = [fibItems objectAtIndex:indexPath.row];
    
	if (cell == nil) {
		//IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"CommonTableCell" bundle:nil];
		cell = (CommonTableCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //Set name from iconImage for selected style
        cell.iconImageName = [anItem objectForKey:fibRowItemImageKey];
        cell.iconImageNameSelected = [anItem objectForKey:fibRowItemImageSelectedKey];
	}
	
	//Customize cell
    
    [cell.titleLabel setText:[anItem objectForKey:fibRowItemNameKey]];
    
    [cell.iconImage setContentMode:UIViewContentModeScaleAspectFit];
    [cell.iconImage setImage:[UIImage imageNamed:[anItem objectForKey:fibRowItemImageKey]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the nib name
    NSDictionary *anItem = [fibItems objectAtIndex:indexPath.row];
    NSString *nibName = [anItem objectForKey:fibRowItemViewKey];
    
    if ([nibName isEqualToString:@"OcuppationViewController"]) {
        OcuppationViewController *ocuppationViewController = [[OcuppationViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [ocuppationViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:ocuppationViewController animated:YES];
        [ocuppationViewController release];
    }
    else if ([nibName isEqualToString:@"NewsViewController"]) {
        NewsViewController *newsViewController = [[NewsViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [newsViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:newsViewController animated:YES];
        [newsViewController release];
    }
    else if ([nibName isEqualToString:@"MapFibViewController"]) {
        MapFibViewController *mapFibViewController = [[MapFibViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [mapFibViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:mapFibViewController animated:YES];
        [mapFibViewController release];
    }
    else if ([nibName isEqualToString:@"FibSubjectsTypeViewController"]) {
        FibSubjectsTypeViewController *fibSubjectsTypeViewController = [[FibSubjectsTypeViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [fibSubjectsTypeViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:fibSubjectsTypeViewController animated:YES];
        [fibSubjectsTypeViewController release];
    }
    else if([nibName isEqualToString:@"BibliotecaRunBrowser"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: kBibliotecaUrl]];
    }
}


@end
