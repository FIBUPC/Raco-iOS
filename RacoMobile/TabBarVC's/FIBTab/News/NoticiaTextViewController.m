//
//  NoticiaTextViewController.m
//  iRaco
//
//  Created by LCFIB on 17/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoticiaTextViewController.h"
#import "NoticiaWebViewController.h"
#import "Defines.h"
#import "MVYImageView.h"


@implementation NoticiaTextViewController

@synthesize urlWeb, titol, image, dateLabel, goToWebButton, goToWebLabel;
@synthesize titleTextView, descriptionTextView, imageView, toolbar;
@synthesize myNewRss;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [self setTitleTextView:nil];
    [self setDescriptionTextView:nil];
    [self setImage:nil];
    [self setDateLabel:nil];
    [self setToolbar:nil];
    [self setUrlWeb:nil];
    [self setTitol:nil];
    [self setImage:nil];
    [self setGoToWebLabel:nil];
    [self setGoToWebButton:nil];
    [self setMyNewRss:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Set goToWebLabel text
    [[self goToWebLabel] setText:NSLocalizableString(@"_goToWeb")];
    
    //Set all NewRss data
    [[self titleTextView] setText:[myNewRss title]];
    [[self descriptionTextView] setText:[myNewRss description]];
    [[self dateLabel] setText:[myNewRss pubDate]];
    
    if (![myNewRss mediaUrl]) {
        [[self imageView] setImage:[UIImage imageNamed:@"comun_detalle_img_standar.png"]];
    } else {
        CGRect rect = CGRectMake(.0f, .0f, imageView.frame.size.width, imageView.frame.size.height);   
        MVYImageView *remoteImage = [[MVYImageView alloc] initWithFrame: rect ];
        [remoteImage setBackgroundColor:[UIColor whiteColor]];
        [remoteImage setContentMode:UIViewContentModeScaleAspectFit];
        [remoteImage loadImageFromURL:[NSURL URLWithString: [myNewRss mediaUrl]] loadingImage:[UIImage imageNamed:@"comun_detalle_img_standar.png"]];   
        [imageView addSubview:remoteImage];
        [remoteImage release];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Set the NavigationBar title
    [[self navigationItem] setTitle:[myNewRss title]];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}
#pragma mark - Private methods

- (IBAction)openWebView:(id)sender{
    
    //Set the NavigationBar title back to make short the back button on next view
    [[self navigationItem] setTitle:NSLocalizableString(@"_back")];
	
	NoticiaWebViewController *noticiaWebViewController = [[NoticiaWebViewController alloc]init];
	//noticiaWebViewController.title = @"Noticia web";
	noticiaWebViewController.title = [myNewRss title];
	[self.navigationController pushViewController:noticiaWebViewController animated:YES];
	[noticiaWebViewController changeWebUrl:[myNewRss linkUrl]];
	[noticiaWebViewController release];
}

@end
