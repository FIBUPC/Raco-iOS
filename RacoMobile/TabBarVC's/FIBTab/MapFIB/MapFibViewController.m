//
//  MapFibViewController.m
//  iRaco
//
//  Created by Marcel Arbó on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapFibViewController.h"
#import "DisplayMap.h"
#import "Defines.h"


@interface MapFibViewController ()
- (void)initializeMapViewAnnotations;
@end

@implementation MapFibViewController

@synthesize mapView, mapType;
@synthesize toolBar;
@synthesize locationManager;

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
    [self setMapView:nil];
    [self setToolBar:nil];
    [self setMapType:nil];
    [self setLocationManager:nil];
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
    self.navigationItem.title = NSLocalizableString(@"_MapFibNavTitle");
    
    //Add "locate me" button
    UIImage *locateMeImage = [UIImage imageNamed:@"locateMe.png"];
    UIButton *locateMeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locateMeButton setImage:locateMeImage forState:UIControlStateNormal];
    locateMeButton.frame = CGRectMake(0.0, 0.0, locateMeImage.size.width, locateMeImage.size.height);
    // Initialize the UIBarButtonItem
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locateMeButton];
    // Set the Target and Action for aButton
    [locateMeButton addTarget:self action:@selector(locateMe:) forControlEvents:UIControlEventTouchUpInside];
    [[self navigationItem] setRightBarButtonItem:aBarButtonItem];
    [aBarButtonItem release];
    
    
    //Initialize MapView parameters
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    
    //Initialize MapView Annotations
    [self initializeMapViewAnnotations];
    
    //Allow show user location
    mapView.showsUserLocation = YES;
    
    [self.view addSubview:toolBar];
    
    //Initi Location Manager
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
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

- (void)initializeMapViewAnnotations {
    //Initialize and Add FIB primary region to MapView
    MKCoordinateRegion FIBRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
    FIBRegion.center.latitude = kFIBRegionLatitude;
    FIBRegion.center.longitude = kFIBRegionLongitude;
    FIBRegion.span.longitudeDelta = kLongitudeDelta;
    FIBRegion.span.latitudeDelta = kLatitudeDelta; 
    
    DisplayMap *adpFIB = [[DisplayMap alloc] init]; 
    adpFIB.title = kFIBTitle;
    adpFIB.subtitle = kFIBSubtitle; 
    adpFIB.coordinate = FIBRegion.center; 
    [mapView addAnnotation:adpFIB];
    [adpFIB release];
    
    //Initialize and Add A5 region to Mapview
    MKCoordinateRegion A5region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    A5region.center.latitude = kA5RegionLatitude;
    A5region.center.longitude = kA5RegionLongitude;
    A5region.span.longitudeDelta = kLongitudeDelta;
    A5region.span.latitudeDelta = kLatitudeDelta;
    
    DisplayMap *adpA5 = [[DisplayMap alloc] init]; 
    adpA5.title = kA5Title;
    adpA5.subtitle = kA5Subtitle; 
    adpA5.coordinate = A5region.center; 
    [mapView addAnnotation:adpA5];
    [adpA5 release];
    
    //Initialize and Add B5 region to Mapview
    MKCoordinateRegion B5Region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    B5Region.center.latitude = kB5RegionLatitude;
    B5Region.center.longitude = kB5RegionLongitude;
    B5Region.span.longitudeDelta = kLongitudeDelta;
    B5Region.span.latitudeDelta = kLatitudeDelta;
    
    DisplayMap *adpB5 = [[DisplayMap alloc] init]; 
    adpB5.title = kB5Title;
    adpB5.subtitle = kB5Subtitle; 
    adpB5.coordinate = B5Region.center; 
    [mapView addAnnotation:adpB5];
    [adpB5 release];

    //Initialize and Add C6 region to Mapview
    MKCoordinateRegion C6Region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    C6Region.center.latitude = kC6RegionLatitude;
    C6Region.center.longitude = kC6RegionLongitude;
    C6Region.span.longitudeDelta = kLongitudeDelta;
    C6Region.span.latitudeDelta = kLatitudeDelta;
    
    DisplayMap *adpC6 = [[DisplayMap alloc] init]; 
    adpC6.title = kB6Title;
    adpC6.subtitle = kB6Subtitle; 
    adpC6.coordinate = C6Region.center; 
    [mapView addAnnotation:adpC6];
    [adpC6 release];
    
    //Set FIBRegion as initial region for MapView
    [mapView setRegion:FIBRegion animated:YES];
}

#pragma mark - MapView Methods

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil; 
    if(annotation != mapView.userLocation) 
    {
        static NSString *defaultPinID = @"myPinId";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        
        if ([annotation.title isEqualToString:@"FIB"]) {
            pinView.pinColor = MKPinAnnotationColorRed;
        }
        else pinView.pinColor = MKPinAnnotationColorPurple;
        
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    } 
    else {
        [mapView.userLocation setTitle:NSLocalizableString(@"_IamHere")];
    }
    return pinView;
}

- (void)locateMe:(id)sender {
    self.locationManager.distanceFilter = 1000;
    [self.locationManager startUpdatingLocation];
}

- (void)changeType:(id)sender{
	if(mapType.selectedSegmentIndex==0){
		mapView.mapType=MKMapTypeStandard;
	}
	else if (mapType.selectedSegmentIndex==1){
		mapView.mapType=MKMapTypeSatellite;
	}
	else if (mapType.selectedSegmentIndex==2){
		mapView.mapType=MKMapTypeHybrid;
	}
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
    CLLocationCoordinate2D coords;
    coords.latitude = kFIBRegionLatitude;
    coords.longitude = kFIBRegionLongitude;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(10,10);
	CLLocationCoordinate2D myLocation;
	myLocation.latitude  = newLocation.coordinate.latitude;
	myLocation.longitude = newLocation.coordinate.longitude;
    
    span.latitudeDelta = fabs(coords.latitude - newLocation.coordinate.latitude)*2.0;
    span.longitudeDelta = fabs(coords.longitude - newLocation.coordinate.longitude)*2.0;
    if (span.latitudeDelta == 0 || span.longitudeDelta == 0) {
        span.latitudeDelta = 0.02;
        span.longitudeDelta = 0.02;
    }
    
    MKCoordinateRegion myRegion = MKCoordinateRegionMake(newLocation.coordinate, span);
	[mapView regionThatFits:myRegion];
    
    @try {
		[mapView setRegion:myRegion animated:YES];
		[mapView setShowsUserLocation:YES];
	}
	@catch (NSException * e) {
		DLog(@"Warning: Invalid region!");
	}
}


@end
