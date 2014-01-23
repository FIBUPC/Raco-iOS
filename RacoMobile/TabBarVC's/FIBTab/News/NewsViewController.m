//
//  NewsViewController.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 03/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "NewsViewController.h"
#import "NewRss.h"
#import "NoticiaTextViewController.h"
#import "Defines.h"
#import "RacoMobileAppDelegate.h"
#import "MVYImageView.h"
#import "NewCell.h"


@implementation NewsViewController

@synthesize newsArray, newsTableView;
@synthesize noResultsView, noResultsLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarController.tabBar.hidden = YES;
    }
    return self;
}

- (void)dealloc
{
    [self setNoResultsView:nil];
    [self setNoResultsLabel:nil];
    [self setNewsArray:nil];
    [self setNewsTableView:nil];
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
    self.navigationItem.title = NSLocalizableString(@"_NewsNavTitle");
    
    //Set noResultsLabel text
    [noResultsLabel setText:NSLocalizableString(@"_noNews")];
    
    
    //Retrieve news
    newsArray = [[NSMutableArray alloc] initWithArray:[[NewsHandler sharedHandler] news]];
    
    if ([self.newsArray count]==0) {
        //Show no resultsView
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
    return [newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifierMail = @"NewCell";
	NewCell *cell = (NewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierMail];
    
	if (cell == nil) {
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"NewCell" bundle:nil];
		cell = (NewCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	}
	
	//Customize cell
    
    NewRss *aNew = [newsArray objectAtIndex:indexPath.row];    
    cell.titleLabel.text = [aNew title];
    cell.descriptionLabel.text = [aNew description];
    if (![aNew mediaUrl]) {
        [cell.thumbnailImage setImage:[UIImage imageNamed:@"comun_listados_img_standar.png"]];
    } else {
        CGRect rect = CGRectMake(.0f, .0f, cell.thumbnailImage.frame.size.width, cell.thumbnailImage.frame.size.height);   
        MVYImageView *remoteImage = [[MVYImageView alloc] initWithFrame: rect ];
        [remoteImage setBackgroundColor:[UIColor whiteColor]];
        [remoteImage setContentMode:UIViewContentModeScaleAspectFit];
        [remoteImage loadImageFromURL:[NSURL URLWithString: [aNew mediaUrl]] loadingImage:[UIImage imageNamed:@"comun_listados_img_standar.png"]];   
        [cell.thumbnailImage addSubview:remoteImage];
        [remoteImage release];
    }
    
	return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(NewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Mod 2 par/impar
    if (indexPath.row % 2)
    {
        [cell.myBackgroundImage setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]];
    }
    else [cell.myBackgroundImage setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticiaTextViewController *noticiaTextViewController = [[NoticiaTextViewController alloc]init];
	[noticiaTextViewController setMyNewRss:[newsArray objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:noticiaTextViewController animated:YES];
	[noticiaTextViewController release];
    
    //Deselect Row
    [newsTableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
