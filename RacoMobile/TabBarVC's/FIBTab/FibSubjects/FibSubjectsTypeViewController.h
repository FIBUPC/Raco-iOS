//
//  FibSubjectsTypeViewController.h
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 17/11/11.
//  Copyright (c) 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FibSubjectsTypeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
	UITableView     *subjectsTableView;	
	NSMutableArray  *subjectsType;
}

@property (nonatomic,retain) IBOutlet UITableView   *subjectsTableView;
@property (nonatomic, retain) NSMutableArray        *subjectsType;

@end
