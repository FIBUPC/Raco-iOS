//
//  SettingsViewController.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 28/03/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITabBarDelegate> {
    UITableView     *settingsTableView;
    NSMutableArray  *settingsArray;
    
    UIButton        *aboutButton;
}

@property (nonatomic, retain) IBOutlet UITableView  *settingsTableView;
@property (nonatomic, retain) NSMutableArray        *settingsArray;

@property (nonatomic, retain) UIButton              *aboutButton;

@end