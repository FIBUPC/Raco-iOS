//
//  SettingsViewController.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 28/03/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "SettingsViewController.h"
#import "Defines.h"
#import "LoginViewController.h"
#import "LanguageViewController.h"
#import "WifiProfileViewController.h"
#import "SettingsAboutViewController.h"
#import "RacoMobileAppDelegate.h"
#import "CommonTableCell.h"

@interface SettingsViewController()
- (void)showAboutView;
@end

@implementation SettingsViewController

@synthesize settingsTableView, settingsArray;
@synthesize aboutButton;

static NSString *settingsRowItemNameKey = @"Name";
static NSString *settingsRowItemImageKey = @"Image";
static NSString *settingsRowItemImageSelectedKey = @"ImageSelected";
static NSString *settingsRowItemViewKey = @"View";

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
    [self setSettingsArray:nil];
    [self setSettingsTableView:nil];
    [self setAboutButton:nil];
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
    
    //Add info  About Button to navigationBar
    UIView *infoButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    aboutButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [aboutButton setFrame:CGRectMake(0, 0, 40, 40)];
    [aboutButton addTarget:self action:@selector(showAboutView) forControlEvents:UIControlEventTouchUpInside];
    [infoButtonView addSubview:aboutButton];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButtonView] autorelease];
    [infoButtonView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    //Deselect Row
    [settingsTableView deselectRowAtIndexPath:[settingsTableView indexPathForSelectedRow] animated:YES];
    
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_SettingsNavTitle");
    
    //Initialize Table items
    NSDictionary *loginItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToLogin"),
                                                                     @"setings_icon_login.png",
                                                                     @"setings_icon_login_.png",
                                                                     @"LoginViewController",nil]  
                                                            forKeys:[NSArray arrayWithObjects:settingsRowItemNameKey,
                                                                     settingsRowItemImageKey,
                                                                     settingsRowItemImageSelectedKey,
                                                                     settingsRowItemViewKey,nil]];
    NSDictionary *languageItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToLanguage"),
                                                                        @"setings_icon_language.png",
                                                                        @"setings_icon_language_.png",
                                                                        @"LanguageViewController",nil]  
                                                               forKeys:[NSArray arrayWithObjects:settingsRowItemNameKey,
                                                                        settingsRowItemImageKey,
                                                                        settingsRowItemImageSelectedKey,
                                                                        settingsRowItemViewKey,nil]];
    NSDictionary *wifiItem = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:NSLocalizableString(@"_goToWifi"),
                                                                    @"setings_icon_wifi.png",
                                                                    @"setings_icon_wifi_.png",
                                                                    @"WifiProfileViewController",nil]  
                                                            forKeys:[NSArray arrayWithObjects:settingsRowItemNameKey,
                                                                     settingsRowItemImageKey,
                                                                     settingsRowItemImageSelectedKey,
                                                                     settingsRowItemViewKey,nil]];

    //Add all sections to sectionsArray
    self.settingsArray = [[[NSMutableArray alloc] initWithObjects:loginItem, languageItem, wifiItem, nil] autorelease];
    [loginItem release];
    [languageItem release];
    [wifiItem release];
    
    
    //Reload TableView Data if lagunage has changed
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([delegate languageHasChanged]) {
        [settingsTableView reloadData];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}

#pragma mark - Provate Methods
- (void)showAboutView {
    SettingsAboutViewController *settingsAboutViewController = [[SettingsAboutViewController alloc] initWithNibName:@"SettingsAboutViewController" bundle:nil];
    //HidesBottomBarWhenPushed
    [settingsAboutViewController setHidesBottomBarWhenPushed:YES];
    // Pass the selected object to the new view controller.
    settingsAboutViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [settingsAboutViewController view];//viewDidLoad fired!
    [self presentModalViewController:settingsAboutViewController animated:YES];
    [settingsAboutViewController release];
}

#pragma mark tableView

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [settingsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifierFIB = @"CommonTableCell";
	CommonTableCell *cell = (CommonTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierFIB];
    
    NSDictionary *anItem = [settingsArray objectAtIndex:indexPath.row];
    
	if (cell == nil) {
		//IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"CommonTableCell" bundle:nil];
		cell = (CommonTableCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //Set name from iconImage for selected style
        cell.iconImageName = [anItem objectForKey:settingsRowItemImageKey];
        cell.iconImageNameSelected = [anItem objectForKey:settingsRowItemImageSelectedKey];
	}
	
	//Customize cell
    
    [cell.titleLabel setText:[anItem objectForKey:settingsRowItemNameKey]];
    
    [cell.iconImage setContentMode:UIViewContentModeScaleAspectFit];
    [cell.iconImage setImage:[UIImage imageNamed:[anItem objectForKey:settingsRowItemImageKey]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the nib name
    NSDictionary *anItem = [settingsArray objectAtIndex:indexPath.row];
    NSString *nibName = [anItem objectForKey:settingsRowItemViewKey];
    
    if ([nibName isEqualToString:@"LoginViewController"]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [loginViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [loginViewController view];//viewDidLoad fired!
        [self presentModalViewController:loginViewController animated:YES];
        [loginViewController release];
    }
    else if ([nibName isEqualToString:@"LanguageViewController"]) {
        LanguageViewController *languageViewController = [[LanguageViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [languageViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:languageViewController animated:YES];
        [languageViewController release];
    }
    else if ([nibName isEqualToString:@"WifiProfileViewController"]) {
        WifiProfileViewController *wifiProfileViewController = [[WifiProfileViewController alloc] initWithNibName:nibName bundle:nil];
        //HidesBottomBarWhenPushed
        [wifiProfileViewController setHidesBottomBarWhenPushed:YES];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:wifiProfileViewController animated:YES];
        [wifiProfileViewController release];
    }
}


@end
