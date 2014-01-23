//
//  AvisosDetailViewController.m
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 17/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "AvisosDetailViewController.h"
#import "Defines.h"
#import "NoticiaWebViewController.h"

@interface AvisosDetailViewController ()
- (void)loadDescriptionWebView;
@end

@implementation AvisosDetailViewController

@synthesize avisDetail;
@synthesize titleText, dateLabel, descriptionLabel, descriptionWebView, imageView;
@synthesize goToWebLabel;

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
    [self setGoToWebLabel:nil];
    [self setTitleText:nil];
    [self setDateLabel:nil];
    [self setDescriptionLabel:nil];
    [self setDescriptionWebView:nil];
    [self setImageView:nil];
    [self setAvisDetail:nil];
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
    
    //Set goToWebLabel text
    [[self goToWebLabel] setText:NSLocalizableString(@"_goToWeb")];
    
    //Set image
    [imageView setImage:[UIImage imageNamed:@"portada_avisos_img_detalle.png"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    //Set title, description and date labels
    [titleText setText:[avisDetail title]];
    [dateLabel setText:[avisDetail pubDate]];
    [descriptionLabel setText:NSLocalizableString(@"_avisDescriptionLabel")];
    
    [self loadDescriptionWebView];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Set the NavigationBar title
    self.navigationItem.title = NSLocalizableString(@"_AvisosDetailNavTitle");
}

#pragma mark - Private methods

- (IBAction)openWebView:(id)sender{
    
    //Set the NavigationBar title back to make short the back button on next view
    [[self navigationItem] setTitle:NSLocalizableString(@"_back")];
	
	NoticiaWebViewController *noticiaWebViewController = [[NoticiaWebViewController alloc]init];
	//noticiaWebViewController.title = @"Noticia web";
	noticiaWebViewController.title = [avisDetail title];
	[self.navigationController pushViewController:noticiaWebViewController animated:YES];
	[noticiaWebViewController changeWebUrl:[avisDetail link]];
	[noticiaWebViewController release];
}

#pragma mark - Private Methods

- (void)loadDescriptionWebView {
    
    [descriptionWebView setBackgroundColor:[UIColor clearColor]];
    
    NSString *description = [avisDetail description];
    
    if ([description isEqualToString:@""]) {
        description = NSLocalizableString(@"_withoutDescription");
    }
    
    [descriptionWebView loadHTMLString:description baseURL:nil];
}


@end
