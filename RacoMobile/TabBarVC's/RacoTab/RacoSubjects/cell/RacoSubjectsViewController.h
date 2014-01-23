//
//  RacoSubjectsViewController.h
//  iRaco
//
//  Created by LCFIB on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONProvider.h"


@interface RacoSubjectsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView     *racoSubjectsTableView;
    NSMutableArray  *racoSubjectsArray;
}

@property (nonatomic, retain) IBOutlet UITableView      *racoSubjectsTableView;
@property (nonatomic, retain) IBOutlet NSMutableArray   *racoSubjectsArray;

@end