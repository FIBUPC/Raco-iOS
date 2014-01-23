//
//  FibSubjectsViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FibSubjectsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView     *fibSubjectsTableView;
    NSMutableArray  *fibSubjectsArray;
}

@property (nonatomic, retain) IBOutlet UITableView      *fibSubjectsTableView;
@property (nonatomic, retain) IBOutlet NSMutableArray   *fibSubjectsArray;

@end
