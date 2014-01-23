//
//  InitialSettingsViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitialViewController.h"


@interface InitialSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView         *initialSettingsTableView;
    NSMutableArray      *initialItems;
    
    UINavigationBar     *initialSettingsToolBar;
    
    UIViewController    *parentVC;
}

@property (nonatomic, retain) IBOutlet UITableView      *initialSettingsTableView;
@property (nonatomic, retain) NSMutableArray            *initialItems;

@property (nonatomic, retain) IBOutlet UINavigationBar  *initialSettingsToolBar;

@property (nonatomic,retain) UIViewController           *parentVC;

- (IBAction)closeViewInitialSettingsViewController:(id)sender;

@end
