//
//  SettingsAboutViewController.m
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 09/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "SettingsAboutViewController.h"
#import "Defines.h"

#define kMAIL_MESSAGE_RECIPIENT     @"lcfib@fib.upc.edu"
#define kAPPSTORE_APPLICATION_URL   @"http://itunes.com/app/RacoMobile" //TODO: verify web adress

@interface SettingsAboutViewController ()
- (NSString *)createMessage;
- (void)displayComposerSheet;
- (void)launchMailAppOnDevice;
@end

@implementation SettingsAboutViewController

@synthesize settingsAboutToolBar;
@synthesize rateButtonLabel, contactLabel, contactButtonLabel, versionLabel;
@synthesize authorLabel, directorLabel, coDirectorLabel, designLabel, rightsReservedLabel;

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
    [self setRightsReservedLabel:nil];
    [self setAuthorLabel:nil];
    [self setCoDirectorLabel:nil];
    [self setDirectorLabel:nil];
    [self setDesignLabel:nil];
    [self setRateButtonLabel:nil];
    [self setContactLabel:nil];
    [self setContactButtonLabel:nil];
    [self setVersionLabel:nil];
    [self setSettingsAboutToolBar:nil];
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
    settingsAboutToolBar.topItem.title = NSLocalizableString(@"_settingsAboutNavTitle");
    
    //Set other Localized Labels
    [rateButtonLabel setText:NSLocalizableString(@"_rateButtonLabel")];
    [contactLabel setText:NSLocalizableString(@"_contactLabel")];
    [contactButtonLabel setText:NSLocalizableString(@"_contactButtonLabel")];
    NSString * versio =  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    [versionLabel setText: [NSString stringWithFormat:NSLocalizableString(@"_versionLabel"), versio]];
    
    [authorLabel setText:NSLocalizableString(@"_appAuthor")];
    [directorLabel  setText:NSLocalizableString(@"_appDirector")];
    [coDirectorLabel setText:NSLocalizableString(@"_appCoDirector")];
    [designLabel setText:NSLocalizableString(@"_appDesign")];
    [rightsReservedLabel setText:NSLocalizableString(@"_rightsReserved")];
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

#pragma mark - IBActions

- (void)closeAboutView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)rateAppplication:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAPPSTORE_APPLICATION_URL]];
}

- (void)composeMail:(id)sender {
    //Control if its possible to send an email
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

#pragma mark - Private Methods

- (NSString *)createMessage {
    
    NSString *message = [NSString stringWithFormat:@"\n\n %@",NSLocalizableString(@"_sentFromRacoMobile")];
    
    return message;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)displayComposerSheet {
    
    MFMailComposeViewController *mailComposerViewController = [[MFMailComposeViewController alloc] init];
	mailComposerViewController.mailComposeDelegate = self;
    
    NSString *message = [self createMessage];
	
	// Fill out the email body text
	[mailComposerViewController setMessageBody:message isHTML:NO];
    [mailComposerViewController setSubject:NSLocalizableString(@"_mailMessageSubject")];
    [mailComposerViewController setToRecipients:[NSArray arrayWithObject:kMAIL_MESSAGE_RECIPIENT]];
	[self presentModalViewController:mailComposerViewController animated:YES];
    [mailComposerViewController release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	// Notifies users about errors associated with the interface
    NSString *message;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = NSLocalizableString(@"_email_canceled");
			break;
		case MFMailComposeResultSaved:
			message = NSLocalizableString(@"_email_saved");
			break;
		case MFMailComposeResultSent:
			message = NSLocalizableString(@"_email_sent");
			break;
		case MFMailComposeResultFailed:
			message = NSLocalizableString(@"_email_failed");
			break;
		default:
			message = NSLocalizableString(@"_email_not_sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
    
    //Show alertView with result
    UIAlertView *mailResultAlert = [[UIAlertView alloc] initWithTitle:NSLocalizableString(@"_emailTitle")
                                                              message:message 
                                                             delegate:self 
                                                    cancelButtonTitle:NSLocalizableString(@"_ok") 
                                                    otherButtonTitles:nil];
    [mailResultAlert show];
    [mailResultAlert release];
}

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
    NSString *message = [self createMessage];
    
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@?",kMAIL_MESSAGE_RECIPIENT];
	NSString *subject = [NSString stringWithFormat:@"subject=%@",NSLocalizableString(@"_mailMessageSubject")];
    NSString *body = [NSString stringWithFormat:@"&body=%@",message];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, subject, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


@end
