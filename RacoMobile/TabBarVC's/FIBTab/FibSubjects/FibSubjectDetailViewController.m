//
//  FibSubjectDetailViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FibSubjectDetailViewController.h"
#import "RacoMobileAppDelegate.h"
#import "RacoMobileAppDelegate+ActivityView.h"
#import "Defines.h"
#import "TeacherCell.h"

#pragma mark - Constants
#define kSCROLL_CONTENT_SIZE CGSizeMake(320, 480)
#define kINITIAL_VERTICAL_Y 163
#define kBOX_VERTICAL_Y_PLUS 70
#define kTEACHER_BORDER_X 11

@interface FibSubjectDetailViewController ()
- (void)loadSubjectDetail;
- (NSString *)createMessage;
- (void)displayComposerSheet;
- (void)launchMailAppOnDevice;
@end

@implementation FibSubjectDetailViewController

@synthesize subjectScrollView;
@synthesize fibSubjectDetail;
@synthesize subjectTag, subjectId;
@synthesize name, description, credits, numCredits, objectius, objectiusText, professors, bilbiografia, bilbiografiaText, bilbiografiaComplementaria, bilbiografiaComplementariaText;
@synthesize noResultsView, noResultsLabel;
@synthesize teacherEmailsArray;

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
    [self setNoResultsLabel:nil];
    [self setName:nil];
    [self setDescription:nil];
    [self setCredits:nil];
    [self setNumCredits:nil];
    [self setObjectius:nil];
    [self setObjectiusText:nil];
    [self setProfessors:nil];
    [self setSubjectTag:nil];
    [self setSubjectId:nil];
    [self setSubjectScrollView:nil];
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
    self.navigationItem.title = subjectId;
    
    //Set the noResultsLabel text
    [noResultsLabel setText:NSLocalizableString(@"_noResultsText")];
    
    //Set Fixed Labels title
    [[self credits] setText:NSLocalizableString(@"_SubjectDetailCredits")];
    [[self objectius] setText:NSLocalizableString(@"_SubjectDetailObjectius")];
    [[self bilbiografia] setText:NSLocalizableString(@"_SubjectDetailBibliografia")];
    [[self bilbiografiaComplementaria] setText:NSLocalizableString(@"_SubjectDetailBibliografiaComplementaria")];
    [[self professors] setText:NSLocalizableString(@"_SubjectDetailProfessors")];
    
    //Set scrollView Size
    [subjectScrollView setContentSize:kSCROLL_CONTENT_SIZE];
    
    //loadSubjectDetail
    [self loadSubjectDetail];
    
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

#pragma mark private methods

- (void)loadSubjectDetail {
    
    //Retrieve fibSubjectDetail
    fibSubjectDetail = [[FibSubjectDetailHandler sharedHandler] retrieveFibSubjectDetailWithTag:subjectId];
    
    //HideActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideActivityViewer];
    //Hide NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([fibSubjectDetail idAssig]) {
        //Hide NoResultsView
        [[self noResultsView] setHidden:YES];
        
        //Load all labels    
        [[self name] setText:[fibSubjectDetail idAssig]];
        [[self description] setText:[fibSubjectDetail nom]];
        [[self numCredits] setText:[fibSubjectDetail credits]];
        
        if (!teacherEmailsArray) {
            teacherEmailsArray = [[NSMutableArray alloc] init];
        }
        else [teacherEmailsArray removeAllObjects];
        
        //Set professorsText from Dictionary
        verticalScrollSize = kINITIAL_VERTICAL_Y;
        int i = 0;
        for (NSDictionary *aDict in [fibSubjectDetail professors]) {
            
            //Check if valid values
            NSString *nom = [aDict objectForKey:@"nom"];
            if ([nom isKindOfClass:(id)[NSNull class]]) {
                nom = @"";
            }
            NSString *email = [aDict objectForKey:@"email"];
            if ([email isKindOfClass:(id)[NSNull class]]) {
                email = @"";
            }
            
            //Add teacher email to teacherEmailsArray
            [teacherEmailsArray addObject:email];
            
            TeacherCell *teacherBox = [[TeacherCell alloc] initWithNibName:@"TeacherCell" bundle:nil];
            [teacherBox loadView];
            
            UIView *teacherBoxView = [[UIView alloc] initWithFrame:CGRectMake(kTEACHER_BORDER_X, verticalScrollSize, 297, 60)];
            
            [teacherBox initializeCellwithName:nom andEmail:email];
            
            [teacherBoxView addSubview:teacherBox.view];
            
            UIButton *boxButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 297, 60)];
            [boxButton setBackgroundColor:[UIColor clearColor]];
            [boxButton addTarget:self action:@selector(openMailComposer:) forControlEvents:UIControlEventTouchUpInside];
            [boxButton setTag:i];
            [teacherBoxView addSubview:boxButton];
            [boxButton release];
            
            [subjectScrollView addSubview:teacherBoxView];
            [teacherBox release];
            [teacherBoxView release];
            
            //Plus dinamicVertical_Y
            verticalScrollSize += kBOX_VERTICAL_Y_PLUS;
            i++;
        }
        
        //Set descriptionText from Dictionary
        [[self objectiusText] setText:@""];
        NSString *text = @"";
        for (NSDictionary *aDict in [fibSubjectDetail descripcio]) {
            text = [text stringByAppendingString:@"* "];
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",aDict]];
            text = [text stringByAppendingString:@"\n\n"];
        }
        [[self objectiusText] setText:text];
        
        
        //Set descriptionText from Dictionary
        [[self bilbiografiaText] setText:@""];
        text = @"";
        for (NSDictionary *aDict in [fibSubjectDetail bibliografia]) {
            text = [text stringByAppendingString:@"- "];
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",[aDict objectForKey:kSubjectBibliografiaText ]]];
            if([aDict objectForKey:kSubjectBibliografiaLink ] != nil && [aDict objectForKey:kSubjectBibliografiaLink ] != NULL){
                text = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@",[aDict objectForKey:kSubjectBibliografiaLink ]]];
            }
            text = [text stringByAppendingString:@"\n\n"];
        }
        [[self bilbiografiaText] setText:text];

        //Set descriptionText from Dictionary
        [[self bilbiografiaComplementariaText] setText:@""];
        text = @"";
        for (NSDictionary *aDict in [fibSubjectDetail bibliografiaComplementaria]) {
            text = [text stringByAppendingString:@"- "];
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",[aDict objectForKey:kSubjectBibliografiaText ]]];
            if([aDict objectForKey:kSubjectBibliografiaLink ] != nil && [aDict objectForKey:kSubjectBibliografiaLink ] != NULL){
                text = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@",[aDict objectForKey:kSubjectBibliografiaLink ]]];
            }
            text = [text stringByAppendingString:@"\n\n"];
        }
        [[self bilbiografiaComplementariaText] setText:text];
        
        //Relocate description Label and TextView
        verticalScrollSize += 5;
        UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fib_todas_las_asignaturas_detalle_linea_divisoria.png"]];
        [separatorLine setFrame:CGRectMake(29, verticalScrollSize, 263, 5)];
        [subjectScrollView addSubview:separatorLine];
        [separatorLine release];
        
        verticalScrollSize += 10;
        [objectius setFrame:CGRectMake(objectius.frame.origin.x, verticalScrollSize + 10, 150, 20)];
        
        verticalScrollSize += 30;
        [objectiusText setFrame:CGRectMake(objectius.frame.origin.x, verticalScrollSize, 280, 200)];
        CGRect frame = objectiusText.frame;
        frame.size.height = objectiusText.contentSize.height;
        objectiusText.frame = frame;
        verticalScrollSize += objectiusText.contentSize.height;
        
        verticalScrollSize += 5;
        separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fib_todas_las_asignaturas_detalle_linea_divisoria.png"]];
        [separatorLine setFrame:CGRectMake(29, verticalScrollSize, 263, 5)];
        [subjectScrollView addSubview:separatorLine];
        [separatorLine release];
        
        verticalScrollSize += 10;
        [bilbiografia setFrame:CGRectMake(bilbiografia.frame.origin.x, verticalScrollSize + 10, 200, 20)];
        
        verticalScrollSize += 30;
        [bilbiografiaText setFrame:CGRectMake(bilbiografiaText.frame.origin.x, verticalScrollSize, 280, 200)];
        frame = bilbiografiaText.frame;
        frame.size.height = bilbiografiaText.contentSize.height;
        bilbiografiaText.frame = frame;
        verticalScrollSize += bilbiografiaText.contentSize.height;
        
        verticalScrollSize += 5;
        separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fib_todas_las_asignaturas_detalle_linea_divisoria.png"]];
        [separatorLine setFrame:CGRectMake(29, verticalScrollSize, 263, 5)];
        [subjectScrollView addSubview:separatorLine];
        [separatorLine release];
        
        verticalScrollSize += 10;
        [bilbiografiaComplementaria setFrame:CGRectMake(bilbiografiaComplementaria.frame.origin.x, verticalScrollSize + 10, 200, 20)];
        
        verticalScrollSize += 30;
        [bilbiografiaComplementariaText setFrame:CGRectMake(bilbiografiaComplementariaText.frame.origin.x, verticalScrollSize, 280, 200)];
        frame = bilbiografiaComplementariaText.frame;
        frame.size.height = bilbiografiaComplementariaText.contentSize.height;
        bilbiografiaComplementariaText.frame = frame;
        verticalScrollSize += bilbiografiaComplementariaText.contentSize.height;
    }
    
    //Set scrollview contentSize
    [subjectScrollView setContentSize:CGSizeMake(subjectScrollView.frame.size.width, verticalScrollSize)];
    
}

#pragma mark - Public Methods

- (void)openMailComposer:(id)sender {
    int tid = ((UIControl*)sender).tag;
    selectedTeacher = [teacherEmailsArray objectAtIndex:tid];
    
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

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (NSString *)createMessage {
    
    NSString *message = [NSString stringWithFormat:@"\n\n %@",NSLocalizableString(@"_sentFromRacoMobile")];
    
    return message;
}

- (void)displayComposerSheet {
    
    MFMailComposeViewController *mailComposerViewController = [[MFMailComposeViewController alloc] init];
	mailComposerViewController.mailComposeDelegate = self;
    
    NSString *message = [self createMessage];
	
	// Fill out the email body text
	[mailComposerViewController setMessageBody:message isHTML:NO];
    [mailComposerViewController setSubject:@""];
    [mailComposerViewController setToRecipients:[NSArray arrayWithObject:selectedTeacher]];
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
    
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@?",selectedTeacher];
	NSString *subject = @"";
    NSString *body = [NSString stringWithFormat:@"&body=%@",message];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, subject, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

@end
