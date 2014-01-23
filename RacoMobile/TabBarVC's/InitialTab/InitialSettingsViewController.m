//
//  InitialSettingsViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InitialSettingsViewController.h"
#import "Defines.h"


@implementation InitialSettingsViewController

@synthesize initialSettingsTableView, initialItems;
@synthesize initialSettingsToolBar;
@synthesize parentVC;

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
    [self setInitialSettingsTableView:nil];
    [self setInitialItems:nil];
    [self setInitialSettingsToolBar:nil];
    [self setParentVC:nil];
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
    initialSettingsToolBar.topItem.title = NSLocalizableString(@"_initialSettingsNavTitle");
    
    //Initialize Table items
    initialItems = [[NSMutableArray alloc] initWithCapacity:3];
    NSDictionary *mail = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:kMailKey,NSLocalizableString(@"_mails"),nil]  
                                                       forKeys:[NSArray arrayWithObjects:@"Key",@"Name",nil]];
    NSDictionary *notices = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:kNoticesKey,NSLocalizableString(@"_notices"),nil]  
                                                          forKeys:[NSArray arrayWithObjects:@"Key",@"Name",nil]];
    NSDictionary *news = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:kNewsKey,NSLocalizableString(@"_news"),nil]  
                                                       forKeys:[NSArray arrayWithObjects:@"Key",@"Name",nil]];    
    
    //Insert Arrays to initialItems with priority
    [[self initialItems] removeAllObjects];
    
    int mailIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kMailKey] intValue];
    int noticesIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kNoticesKey] intValue];
    int newsIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewsKey] intValue];
    
    if ( (mailIndex == 0) && (noticesIndex == 1) ) {
        [[self initialItems] addObject:mail];
        [[self initialItems] addObject:notices];
        [[self initialItems] addObject:news];
    }
    else if ( (mailIndex == 0) && (newsIndex == 1) ) {
        [[self initialItems] addObject:mail];
        [[self initialItems] addObject:news];
        [[self initialItems] addObject:notices];
    }
    else if ( (noticesIndex == 0) && (newsIndex == 1) ) {
        [[self initialItems] addObject:notices];
        [[self initialItems] addObject:news];
        [[self initialItems] addObject:mail];
    }
    else if ( (noticesIndex == 0) && (mailIndex == 1) ) {
        [[self initialItems] addObject:notices];
        [[self initialItems] addObject:mail];
        [[self initialItems] addObject:news];
    }
    else if ( (newsIndex == 0) && (mailIndex == 1) ) {
        [[self initialItems] addObject:news];
        [[self initialItems] addObject:mail];
        [[self initialItems] addObject:notices];
    }
    else if ( (newsIndex == 0) && (noticesIndex == 1) ) {
        [[self initialItems] addObject:news];
        [[self initialItems] addObject:notices];
        [[self initialItems] addObject:mail];
    }
    
    [mail release];
    [notices release];
    [news release];
    
    //Set Editing mode for tableView
    [initialSettingsTableView setEditing:YES animated:YES];
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

#pragma mark private Methods

- (void)closeViewInitialSettingsViewController:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    DLog(@"\n\n******* dismiss called *********\n\n");
    
    //Set new positions for Items
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[[initialItems objectAtIndex:0] objectForKey:@"Key"]];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[[initialItems objectAtIndex:1] objectForKey:@"Key"]];
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:[[initialItems objectAtIndex:2] objectForKey:@"Key"]];
    
    for (int i = 0; i < 3; i++) {
        if ([[[initialItems objectAtIndex:i] objectForKey:@"Key"] isEqualToString:kMailKey]) {
            [[NSUserDefaults standardUserDefaults] setObject:kMailKey forKey:[NSString stringWithFormat:@"section%i",i]];
        }
        else if ([[[initialItems objectAtIndex:i] objectForKey:@"Key"] isEqualToString:kNoticesKey]) {
            [[NSUserDefaults standardUserDefaults] setObject:kNoticesKey forKey:[NSString stringWithFormat:@"section%i",i]];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:kNewsKey forKey:[NSString stringWithFormat:@"section%i",i]];
        }
    }
    
    //Call to ParenViewController and setPriority to TableItems
    [(id)parentVC setPrioriyToTableItems];
}

-(void) moveFromOriginal:(NSInteger)indexOriginal toNew:(NSInteger)indexNew {
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:initialItems];
    id tempObject = [tempArray objectAtIndex:indexOriginal];
    [tempArray removeObjectAtIndex:indexOriginal];
    [tempArray insertObject:tempObject atIndex:indexNew];
    initialItems = tempArray;
}

#pragma mark tableView

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [initialItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comun_white_cell.png"]];
    }
	
    // Configure the cell.
    cell.textLabel.text = [[initialItems objectAtIndex:indexPath.row] objectForKey:@"Name"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath { 
    return NO;
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath { 
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //Call method to swap cells
    [self moveFromOriginal:fromIndexPath.row toNew:toIndexPath.row];
}

@end
