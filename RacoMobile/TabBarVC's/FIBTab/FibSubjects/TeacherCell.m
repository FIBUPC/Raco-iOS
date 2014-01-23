//
//  TeacherCell.m
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 10/10/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "TeacherCell.h"
#import "Defines.h"


@implementation TeacherCell

@synthesize nameLabel, emailLabel, emailTextLabel;

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
    [self setNameLabel:nil];
    [self setEmailLabel:nil];
    [self setEmailTextLabel:nil];
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

#pragma mark - Public Methods

- (void)initializeCellwithName:(NSString *)name andEmail:(NSString *)email {
    [nameLabel setText:name];
    [emailLabel setText:email];
    
    [emailTextLabel setText:NSLocalizableString(@"_email")];
}

@end
