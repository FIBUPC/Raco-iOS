//
//  MailsViewController.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 04/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "MailsViewController.h"
#import "Defines.h"
#import "Mail.h"
#import "MailCell.h"
#import "RacoMobileAppDelegate.h"


@implementation MailsViewController

@synthesize mailsTableView, mailsArray;
@synthesize underButtonView, syncronizeButton, syncronizeLabel;
@synthesize selectedMailSubject, selectedMailDate, selectedMailIndex;
@synthesize noResultsView, noMailsLabel;

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
    [self setNoMailsLabel:nil];
    [self setSelectedMailDate:nil];
    [self setSelectedMailSubject:nil];
    [self setUnderButtonView:nil];
    [self setSyncronizeButton:nil];
    [self setSyncronizeLabel:nil];
    [self setMailsTableView:nil];
    [self setMailsArray:nil];
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
    self.navigationItem.title = NSLocalizableString(@"_MailsNavTitle");
    
    //Set noMailsLabel text
    [noMailsLabel setText:NSLocalizableString(@"_noMails")];
    
    //Set syncronizeLabel localized text 
    [syncronizeLabel setText:NSLocalizableString(@"_synchronizeMail")];
    
    //Retrieve mails
    mailsArray = [[NSMutableArray alloc] initWithArray:[[MailHandler sharedHandler] mails]];
    
    if ([self.mailsArray count]==0) {
        //Show no resultsView
        [noResultsView setHidden:NO];
    }
    else {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [[self mailsTableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

#pragma mark - Private Methods

- (void)SynchronizeMail:(id)sender{
	
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"usernamePref"];
	NSString *urlCorreu = [NSString stringWithFormat:@"https://raco.fib.upc.edu/iphone/perfil-mail?username=%@",username];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlCorreu]];
}

#pragma mark - TableView Delegates

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mailsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 70;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifierMail = @"MailCell";
	MailCell *cell = (MailCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierMail];
    
	if (cell == nil) {
		//IB engineer approved
		UIViewController *ctl = [[UIViewController alloc] initWithNibName:@"MailCell" bundle:nil];
		cell = (MailCell*)ctl.view;
		[ctl release];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.myMailImage.image = [UIImage imageNamed:@"headlines_icon_email_blue.png"];
        [cell.myMailImage setContentMode:UIViewContentModeScaleAspectFit];
	}
	
	//Customize cell
    
    Mail *aMail = [mailsArray objectAtIndex:indexPath.row];
    
    cell.myDateLabel.text = [aMail date];
    cell.myTitleLabel.text = [aMail subject];
    cell.myFromLabel.text = [NSString stringWithFormat:@"%@ ",NSLocalizableString(@"_fromMail")];
    
    [cell.myFromTextLabel setFrame:CGRectMake(42+[cell.myFromLabel.text sizeWithFont:[[cell myFromLabel] font]].width, 44, 146, 21)];
    cell.myFromTextLabel.text = [aMail from];
    
    //Scroll to selectedMail position if exist
    if ([selectedMailSubject isEqualToString:[aMail subject]] && [selectedMailDate isEqualToString:[aMail date]]) {
        [mailsTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
	return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(MailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Mod 2 par/impar
    if (indexPath.row % 2)
    {
        [cell.myBackgroundImage setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    }
    else [cell.myBackgroundImage setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]];
    
    //Sho selected if exist
    Mail *aMail = [mailsArray objectAtIndex:indexPath.row];
    if ([selectedMailSubject isEqualToString:[aMail subject]] && [selectedMailDate isEqualToString:[aMail date]]) {
        [cell.myBackgroundImage setBackgroundColor:[UIColor colorWithRed:3/255.0 green:146/255.0 blue:208/255.0 alpha:0.4]];
    }
}



@end
