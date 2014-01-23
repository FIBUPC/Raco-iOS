//
//  OccupationDetailViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONProvider.h"


@interface OcupattionDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIView              *occupationView;
    UIWebView           *ocuppationWebView;
    UITableView         *ocuppationTableView;
    UISegmentedControl  *segmentedControl;
    UILabel             *updatedLabel;
    
    NSMutableArray      *freePlacesArray;
    NSString            *placeTag;
}

@property (nonatomic, retain) IBOutlet UIView               *occupationView; 
@property (nonatomic, retain) IBOutlet UIWebView            *ocuppationWebView;
@property (nonatomic, retain) IBOutlet UITableView          *ocuppationTableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentedControl;
@property (nonatomic, retain) IBOutlet UILabel              *updatedLabel;
@property (nonatomic, retain) NSMutableArray                *freePlacesArray;
@property (nonatomic, retain) NSString                      *placeTag;

- (IBAction)changeImageUrl:(NSString *)url;
- (IBAction)changeType:(id)sender;

@end
