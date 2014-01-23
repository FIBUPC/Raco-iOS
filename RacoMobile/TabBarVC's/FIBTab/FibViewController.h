//
//  FibViewController.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 25/03/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FibViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITabBarDelegate> {
    UITableView     *fibTableView;
    NSMutableArray  *fibItems;
}

@property (nonatomic, retain) IBOutlet UITableView  *fibTableView;
@property (nonatomic, retain) NSMutableArray        *fibItems;

@end
