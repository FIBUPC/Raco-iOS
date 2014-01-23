//
//  OcupattionDetailViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OcupattionDetailViewController.h"
#import "Place.h"
#import "RacoMobileAppDelegate.h"
#import "Defines.h"
#import "RacoMobileAppDelegate+ActivityView.h"
#import "Utils.h"
#import "FreePlaceOccupationCell.h"

@interface  OcupattionDetailViewController()
- (void)refreshOccupation;
- (void)reloadUpdateLabelText;
@end

@implementation OcupattionDetailViewController

@synthesize occupationView, ocuppationWebView, ocuppationTableView;
@synthesize segmentedControl, updatedLabel;
@synthesize freePlacesArray;
@synthesize placeTag;

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
    [self setUpdatedLabel:nil];
    [self setOccupationView:nil];
    [self setSegmentedControl:nil];
    [self setOcuppationTableView:nil];
    [self setOcuppationWebView:nil];
    [self setFreePlacesArray:nil];
    [self setPlaceTag:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"occupationSubjectDataLoaded" object:nil];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"occupationSubjectDataLoaded" object:nil];
    
    //Set updatedLabel
    [self reloadUpdateLabelText];
    
    //Add refresh button to navigationBar
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshOccupation)];
    [self.navigationItem setRightBarButtonItem:refreshButton];
    [refreshButton release];
    
    //Retrieve occupation
    freePlacesArray = [[NSMutableArray alloc] initWithArray:[[OccupationHandler sharedHandler] retrieveOccupationArrayWithTag:placeTag]];
    
    [ocuppationTableView reloadData];
    if ([self.freePlacesArray count]==0) {
        //No results..
    }
    
    //First time show WebView
    [self.view addSubview:occupationView];
    
    //Set the segmentedControl titles
    [segmentedControl setTitle:NSLocalizableString(@"_segmentControlImage") forSegmentAtIndex:0];
    [segmentedControl setTitle:NSLocalizableString(@"_segmentControlPlaces") forSegmentAtIndex:1];
    
    //Set WebView clear color
	self.ocuppationWebView.backgroundColor = [UIColor clearColor];
    self.ocuppationWebView.opaque = NO;
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

- (void)viewWillDisappear:(BOOL)animated
{	
	ocuppationWebView.delegate = nil;    // disconnect the delegate as the webview is hidden
	
	//Amagar roda de carrega al sortir
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}    

#pragma mark - Private Methods

- (void)refreshOccupation {
    
    //Reload occupation free places
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];    
    //ShowActivityViewer
    [delegate showActivityViewer];
    
    //Refresh FibSubjectsData
    [delegate refreshOccupationSubjectDataAlways];
    
    //Reload updatedLabel text
    NSDate *updatedDate = [NSDate date];
    [updatedLabel setText:[NSString stringWithFormat:@" %@: %@",NSLocalizableString(@"_lastUpdate"),[Utils stringWithHourFromDate:updatedDate]]];
}

- (void)reloadTableView {
    //Retrieve occupation
    freePlacesArray = [[NSMutableArray alloc] initWithArray:[[OccupationHandler sharedHandler] retrieveOccupationArrayWithTag:placeTag]];
    
    [ocuppationTableView reloadData];
}

- (void)reloadUpdateLabelText {
    NSDate *updatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"OccupationUpdatedDate"];
    [updatedLabel setText:[NSString stringWithFormat:@" %@: %@",NSLocalizableString(@"_lastUpdate"),[Utils stringWithHourFromDate:updatedDate]]];
}

- (void)changeImageUrl:(NSString *)url {
	
	NSString *header = @"<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=4.0; user-scalable=1;\">";
	
	NSMutableString *html = [NSMutableString stringWithFormat:@"<html>%@<body style='background-color: #fff; text-align:center;'><img style=\"width:300;margin-top:100px;\" src='%@'/><body/></html>",header,url];
	
	[ocuppationWebView loadHTMLString:html baseURL:nil];
	
}

- (void)changeType:(id)sender{
    DLog(@"change");
	if(segmentedControl.selectedSegmentIndex==0){
        //[self.view addSubview:ocuppationWebView];
        [self.view bringSubviewToFront:occupationView];
	}
	else if (segmentedControl.selectedSegmentIndex==1){
        //[ocuppationWebView removeFromSuperview];
        [self.view bringSubviewToFront:ocuppationTableView];
        [ocuppationTableView setDelegate:self];
	}
}

#pragma mark - UIWebView Delegate Methods

- (void)webView:(UIWebView *)ocuppationWebView didFailLoadWithError:(NSError *)error{
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if ([error code] != -999) {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:[error localizedDescription]
							  message:[error localizedFailureReason]
							  delegate:self cancelButtonTitle:NSLocalizableString(@"_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)webViewDidFinishLoad:ocuppationWebView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void)webViewDidStartLoad:ocuppationWebView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark - TableView Delgates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [freePlacesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"FreePlaceOccupationCell";
	FreePlaceOccupationCell *cell = (FreePlaceOccupationCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil) {
		//IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"FreePlaceOccupationCell" bundle:nil];
		cell = (FreePlaceOccupationCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.placesLabel setText:[NSString stringWithFormat:@"%@: ",NSLocalizableString(@"_segmentControlPlaces")]];
        [cell.subjectLabel setText:[NSString stringWithFormat:@"%@: ",NSLocalizableString(@"_subject")]];
	}
	
    // Configure the cell.
    
    Place *aPlace = [freePlacesArray objectAtIndex:indexPath.row];
    
    [cell.classNameLabel setText:[aPlace name]];
    [cell.freePlacesNumberLabel setText:[aPlace places]];
    
    if (![[aPlace subject] isEqualToString:@""]) {
        [cell.subjectNameLabel setText:[aPlace subject]];
    }
    else {
        [cell.subjectNameLabel setTextColor:[UIColor colorWithRed:0/255.0 green:102/255.0 blue:0/255.0 alpha:1]];
        [cell.subjectNameLabel setText:NSLocalizableString(@"_freeClass")];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(FreePlaceOccupationCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Mod 2 par/impar
    if (indexPath.row % 2)
    {
        [cell.backgroundImage setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]];
    }
    else [cell.backgroundImage setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
}


@end
