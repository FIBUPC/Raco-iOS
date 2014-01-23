//
//  MapFibViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class DisplayMap; 

@interface MapFibViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView           *mapView;
    UIToolbar           *toolBar;
    UISegmentedControl  *mapType;
    
    CLLocationManager   *locationManager;
}

@property (nonatomic, retain) IBOutlet MKMapView            *mapView;
@property (nonatomic, retain) IBOutlet UIToolbar            *toolBar;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *mapType;

@property (nonatomic, retain) IBOutlet CLLocationManager    *locationManager;

- (IBAction)changeType:(id)sender;
- (IBAction)locateMe:(id)sender;

//Defines for MapView Annotations
#define kLongitudeDelta 0.005f
#define kLatitudeDelta 0.005f

#define kFIBTitle @"FIB";
#define kFIBSubtitle @"Facultat d'informàtica de Barcelona"; 
#define kFIBRegionLatitude 41.389411
#define kFIBRegionLongitude 2.113323

#define kA5Title @"A5";
#define kA5Subtitle @"Edifici A5";
#define kA5RegionLatitude 41.388858
#define kA5RegionLongitude 2.113212

#define kB5Title @"B5";
#define kB5Subtitle @"Edifici B5";
#define kB5RegionLatitude 41.389094
#define kB5RegionLongitude 2.112896

#define kB6Title @"C6";
#define kB6Subtitle @"Edifici C6"; 
#define kC6RegionLatitude 41.389488
#define kC6RegionLongitude 2.113032

@end
