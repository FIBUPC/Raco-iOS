//
//  WifiProfileViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WifiProfileViewController.h"
#import "Defines.h"


@implementation WifiProfileViewController

@synthesize wifiButton, getProfileLabel;
@synthesize usernameTextField;
@synthesize wifiTextView;

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
    [self setGetProfileLabel:nil];
    [self setWifiButton:nil];
    [self setUsernameTextField:nil];
    [self setWifiTextView:nil];
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
    self.navigationItem.title = NSLocalizableString(@"_WifiNavTitle");
    [getProfileLabel setText:NSLocalizableString(@"_getWifiProfile")];
    
    //Set the wifiTextView text
    [wifiTextView setText:NSLocalizableString(@"_wifiTextView")];
    
    //Set usernameTextField placeholder
    [usernameTextField setPlaceholder:NSLocalizableString(@"usernameKey")];
    [usernameTextField setReturnKeyType:UIReturnKeyDone];
    
    NSString *usernamePref = [[NSUserDefaults standardUserDefaults] objectForKey:@"usernamePref"];
    [usernameTextField setText:usernamePref];
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

- (void)getWifiProfile:(id)sender {
    
    //Check for username textfield
    if (![usernameTextField.text isEqualToString:@""]) {
        NSString *urlWifi = [NSString stringWithFormat:@"%@%@",kWifiProfileURL,usernameTextField.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlWifi]];
    }
    else {
        //Show alert to enter a username
        UIAlertView *usernameAlert = [[UIAlertView alloc] initWithTitle:@"iRaco" message:NSLocalizableString(@"_usernameNeeded") delegate:self cancelButtonTitle:NSLocalizableString(@"_ok") otherButtonTitles:nil];
        [usernameAlert show];
        [usernameAlert release];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
