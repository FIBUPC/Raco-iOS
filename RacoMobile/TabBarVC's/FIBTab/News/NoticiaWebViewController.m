//
//  NoticiaWebViewController.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 03/01/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "NoticiaWebViewController.h"
#import "RacoMobileAppDelegate.h"
#import "RacoMobileAppDelegate+ActivityView.h"
#import "Defines.h"


@implementation NoticiaWebViewController

@synthesize noticiaWebView;
@synthesize toolbar;

- (void)dealloc {
    [noticiaWebView release];
    [toolbar release];
    [urlWeb release];
    [super dealloc];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	//Ajustar el tamany 100% de la pagina web
	noticiaWebView.scalesPageToFit = YES;
	
	//[noticiaWebView addSubview:activityView];
	[self.view addSubview:noticiaWebView];
	[self.view addSubview:toolbar];
	
    [super viewDidLoad];
}

- (void)viewDidUnload {
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
	noticiaWebView.delegate = nil;    // disconnect the delegate as the webview is hidden
	
    //HideActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideActivityViewer];
    //Hide NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - UIWebView Delegate Methods

- (void)webView:(UIWebView *)noticiaWebView didFailLoadWithError:(NSError *)error{
    
	//HideActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideActivityViewer];
    //Hide NetworkActivityIndicator
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

- (void)webViewDidFinishLoad:noticiaWebView
{
	//HideActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideActivityViewer];
    //Hide NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void)webViewDidStartLoad:noticiaWebView
{
	//Show ActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate showActivityViewer:NSLocalizableString(@"_loadingWebView")];
    //Show NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark - Public Methods

- (IBAction) changeWebUrl:(NSString *)url {
	[noticiaWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


@end
