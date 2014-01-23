//
//  OcuppationViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OcuppationViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
	UITableView     *occupationTableView;	
	NSMutableArray  *aulas;
}

@property (nonatomic,retain) IBOutlet UITableView   *occupationTableView;
@property (nonatomic, retain) NSMutableArray        *aulas;

@end