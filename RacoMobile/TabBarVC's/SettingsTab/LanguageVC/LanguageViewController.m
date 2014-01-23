//
//  LanguageViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LanguageViewController.h"
#import "Defines.h"
#import "FilterCell.h"
#import "RacoMobileAppDelegate.h"

@interface LanguageViewController ()
- (void)setBackBarButtonItemNewLocalizedText;
- (void)goBack;
@end

@implementation LanguageViewController

@synthesize languageTableView;
@synthesize languageItems;
@synthesize backBarButtonItem;

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
    [self setLanguageItems:nil];
    [self setLanguageTableView:nil];
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
    self.navigationItem.title = NSLocalizableString(@"_LanguageNavTitle");
    
    //Set custom BackBarButton
    [self setBackBarButtonItemNewLocalizedText];
    
    //Initialize Table items
    NSDictionary *catalanItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Català",@"ca",nil]  
                                                             forKeys:[NSArray arrayWithObjects:@"Name",@"Lang",nil]];
    NSDictionary *englishItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"English",@"en",nil]  
                                                                 forKeys:[NSArray arrayWithObjects:@"Name",@"Lang",nil]];
    NSDictionary *spanishItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Español",@"es",nil]  
                                                          forKeys:[NSArray arrayWithObjects:@"Name",@"Lang",nil]];
    
    self.languageItems = [[[NSMutableArray alloc] initWithObjects:catalanItem, englishItem, spanishItem, nil] autorelease];
    [catalanItem release];
    [englishItem release];
    [spanishItem release];
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

#pragma mark - Private Methods

- (void)setBackBarButtonItemNewLocalizedText {
    
    self.navigationItem.leftBarButtonItem = nil;
    
    //Set BackBarButton 
    UIButton *customBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 35)];
    [customBackButton setBackgroundImage:[UIImage imageNamed:@"comun_btn_atras.png"] forState:UIControlStateNormal];
    [customBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 62, 35)];
    [backLabel setText:NSLocalizableString(@"_back")];
    [backLabel setTextAlignment:UITextAlignmentCenter];
    [backLabel setTextColor:[UIColor whiteColor]];
    [backLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    [backLabel setBackgroundColor:[UIColor clearColor]];
    
    UIView *customBackButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 35)];
    [customBackButtonView addSubview:customBackButton];
    [customBackButtonView addSubview:backLabel];
    [customBackButton release];
    [backLabel release];
    
    backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBackButtonView];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    [customBackButtonView release];
    [backBarButtonItem release];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [languageItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *CellIdentifier = @"FilterCell";
	
	FilterCell *cell = (FilterCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		//IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"FilterCell" bundle:nil];        
		cell = (FilterCell*)ctl.view;
		[ctl release];
	}
	
    // Configure the cell.
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *actualLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguagePrefKey];
    UIColor *blue = [UIColor colorWithRed:13.0/255 green:128.0/255 blue:190.0/255 alpha:1];
    
    NSDictionary *anItem = [languageItems objectAtIndex:indexPath.row];
    [[cell filterLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    [[cell filterLabel] setText:[anItem objectForKey:@"Name"]];
    
    if ([[anItem objectForKey:@"Lang"] isEqualToString:actualLanguage]) {
        [[cell checkImage] setAlpha:1];
        [[cell filterLabel] setTextColor:blue];
    }
    else {
        [[cell checkImage] setAlpha:0];
        [[cell filterLabel] setTextColor:[UIColor blackColor]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Save the new language to UserDefaults and refreshTable    
    NSDictionary *anItem = [languageItems objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:[anItem objectForKey:@"Lang"] forKey:kLanguagePrefKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[self languageTableView] reloadData];
    
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_LanguageNavTitle");
    
    //Set backBarButtonItem ne localized text
    [self setBackBarButtonItemNewLocalizedText];
    
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate setLocalizedTitlesForTabBarItems];
}


@end
