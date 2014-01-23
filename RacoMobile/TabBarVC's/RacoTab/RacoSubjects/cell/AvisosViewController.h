//
//  AvisosViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AvisosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView     *avisosTableView;
    NSMutableArray  *avisosArray;
    
    NSString        *avisTag;
    
    UIView          *noResultsView;
    UILabel         *noNoticesLabel;
}

@property (nonatomic, retain) IBOutlet UITableView  *avisosTableView;
@property (nonatomic, retain) NSMutableArray        *avisosArray;

@property (nonatomic, retain) NSString              *avisTag;

@property (nonatomic, retain) IBOutlet UIView       *noResultsView;
@property (nonatomic, retain) IBOutlet UILabel      *noNoticesLabel;

@end
