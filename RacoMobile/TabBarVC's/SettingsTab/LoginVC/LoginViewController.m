//
//  LoginViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "Defines.h"
#import "JSON.h"
#import "RacoMobileAppDelegate.h"
#import "RacoMobileAppDelegate+ActivityView.h"

#define kUserTag        1
#define kPasswordTag    2

@interface LoginViewController ()
- (void)saveSecurePreferences;
- (void)closeAndLoadAllData;
- (void)showHideLogoutButton;
- (void)deleteUserKeys;
- (void)reloadAllData;
- (void)logoutWithDismiss:(BOOL)dismiss;
- (void)showIncorrectStatus;
@end

@implementation LoginViewController

@synthesize usernameTextField, passwordTextField;
@synthesize status;
@synthesize loginToolBar, closeButton;
@synthesize logoutButton, logoutLabel;

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
    [self setLogoutLabel:nil];
    [self setLogoutButton:nil];
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setStatus:nil];
    [self setLoginToolBar:nil];
    [self setCloseButton:nil];
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
    loginToolBar.topItem.title = NSLocalizableString(@"_LoginNavTitle");
    closeButton.title = NSLocalizableString(@"_closeLoginView");
    
    //Set logutButton text
    [logoutLabel setText:NSLocalizableString(@"_logout")];
    
    //Initialize status label
    [status setHidden:YES];
    [status setBackgroundColor:[UIColor clearColor]];
    
    //BecomeFirstResponder -> Show Keyboard
    [usernameTextField becomeFirstResponder];
    
    [usernameTextField setTag:kUserTag];
    [passwordTextField setTag:kPasswordTag];
    
    [usernameTextField setPlaceholder:NSLocalizableString(@"usernameKey")];
    [passwordTextField setPlaceholder:NSLocalizableString(@"passwordKey")];
    
    [usernameTextField setReturnKeyType:UIReturnKeyNext];
    [passwordTextField setReturnKeyType:UIReturnKeyDone];
    
    NSString *usernamePref = [[NSUserDefaults standardUserDefaults] objectForKey:@"usernamePref"];
    [usernameTextField setText:usernamePref];
    NSString *passwordPref = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordPref"];
    [passwordTextField setText:passwordPref];
    
    [self showHideLogoutButton];

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

- (void)checkLogin:(id)sender{
    //Check for login
    
    //ResignFirstResponder -> Hide Keyboard
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    //Show NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //Show ActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate showActivityViewer:NSLocalizableString(@"_cheking")];
    
    NSString *parameters = [NSString stringWithFormat:@"username=%@&password=%@",[usernameTextField text],[passwordTextField text]];
    NSString *url = kLoginViewControllerUrl;
    NSString *method = kGetMethod;
    
    jsonData = [[JSONProvider alloc] initWithUrl:url method:method parameters:parameters];
    jsonData.delegate = self;
}

- (void)closeLoginVC:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)logoutPressed:(id)sender {
    [self logoutWithDismiss:YES];
}

- (void)logoutWithDismiss:(BOOL)dismiss {
    [usernameTextField setText:@""];
    [passwordTextField setText:@""];
    
    //Call Save Secure Preferences
    [self saveSecurePreferences];    
    
    //Set user status not_logged
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:kNotLoggedKey forKey:kisLoggedKey];
    [userDefaults synchronize];
    
    [self showHideLogoutButton];
    [self deleteUserKeys];
    
    if (dismiss) {
        [self closeAndLoadAllData];
    }
    else {
        [self reloadAllData];
    }
}

- (void)saveSecurePreferences {
    //Save Secure Preferences
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DLog(@"user: %@",usernameTextField.text);
    DLog(@"pass: %@",passwordTextField.text);
    [userDefaults setObject:usernameTextField.text forKey:@"usernamePref"];
    [userDefaults setObject:passwordTextField.text forKey:@"passwordPref"];
    [userDefaults synchronize];
}

- (void)closeAndLoadAllData {
    [self dismissModalViewControllerAnimated:YES];
    [self reloadAllData];
}

- (void)reloadAllData {
    //Remove needed information before if other user was logged before
    [[AgendaIcsHandler sharedHandler] deleteData];
    [[ScheduleHandler sharedHandler] deleteData];
    
    //Reload all Data for NewUser -> Call downloadInitialServices method from AppDelegate
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate downloadInitialServices];
}

- (void)showHideLogoutButton {
    //Show/Hide LogoutButton
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    logged = [delegate userIsLogged];
    if (logged) {
        [logoutButton setEnabled:YES];
        [logoutButton setHidden:NO];
        [logoutLabel setHidden:NO];
    }
    else {
        [logoutButton setEnabled:NO];
        [logoutButton setHidden:YES];
        [logoutLabel setHidden:YES];
    }
}

- (void)deleteUserKeys {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kIcalPortadaIcsKey];
    [userDefaults removeObjectForKey:kIcalHorariIcsKey];
    [userDefaults removeObjectForKey:kRssAvisosAssignaturesKey];
    [userDefaults removeObjectForKey:kRacoSubjectsKey];
}

- (void)showIncorrectStatus {
    //Show incorrect status
    [status setHidden:NO];
    [status setText:NSLocalizableString(@"_userAndPassIncorrect")];
    [status setTextColor:[UIColor redColor]];
    
    //Set user status not_logged
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:kNotLoggedKey forKey:kisLoggedKey];
    [userDefaults synchronize];
    
    [self logoutWithDismiss:NO];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [passwordTextField becomeFirstResponder];
    }
    else {
        //Call to checkLogin
        [self checkLogin:(self)];
    }
    return YES;
}
 
#pragma mark - DelegateMethods

-(void)ProcessCompleted:(NSDictionary *)results {
	//HideActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideActivityViewer];
    
    //Hide NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //BecomeFirstResponder -> Show Keyboard
    [usernameTextField becomeFirstResponder];
    
    //Call Save Secure Preferences
    [self saveSecurePreferences];
    
    //Check if results is not nill
	if (results) { 
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //Get User Keys for webservices
        NSString *icalPortadaIcs = [results objectForKey:kIcalPortadaIcs];
        NSString *icalHorariIcs = [results objectForKey:kIcalHorariIcs];
        NSString *rssAvisosAssignatures = [results objectForKey:KRssAvisosAssignatures];
        NSString *racoSubjects   = [results objectForKey:kRacoSubjects];
        //Add more keys if needed...
        
        //Check if all value OK
        if (icalPortadaIcs && icalHorariIcs && rssAvisosAssignatures && racoSubjects) {
            if (icalPortadaIcs) [userDefaults setObject:icalPortadaIcs forKey:kIcalPortadaIcsKey];
            if (icalHorariIcs) [userDefaults setObject:icalHorariIcs forKey:kIcalHorariIcsKey];
            if (rssAvisosAssignatures) [userDefaults setObject:rssAvisosAssignatures forKey:kRssAvisosAssignaturesKey];
            if (racoSubjects) [userDefaults setObject:racoSubjects forKey:kRacoSubjectsKey];
            
            //Show correct status
            [status setHidden:NO];
            [status setText:NSLocalizableString(@"_userAndPassCorrect")];
            [status setTextColor:[UIColor greenColor]];
            
            //Set user status logged
            [userDefaults setObject:kLoggedKey forKey:kisLoggedKey];
            [userDefaults synchronize];
            
            //IF logged, close and load Dataevern
            [self closeAndLoadAllData];
        }
        else {
            [self showIncorrectStatus];
        }
	}
	else {
        [self showIncorrectStatus];
	}	
}

-(void)ProcessHasErrors:(NSError *)error {
    
    //HideActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideActivityViewer];
    
    //Hide NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //BecomeFirstResponder -> Show Keyboard
    [usernameTextField becomeFirstResponder];
    
    //Show Alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error localizedDescription] 
                                                    message:[error localizedFailureReason]
												   delegate:nil cancelButtonTitle:NSLocalizableString(@"_ok") otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

@end
