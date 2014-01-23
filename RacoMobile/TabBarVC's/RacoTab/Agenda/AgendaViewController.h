//
//  AgendaViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AgendaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView     *agendaTableView;
    NSMutableArray  *agendaItems;
    UIView          *underButtonView;
    UIButton        *syncronizeButton;
    UILabel         *syncronizeLabel;
    
    UIBarButtonItem *todayButton;
    UILabel         *updatedLabel;
    
    int             todayIndex;
}

@property (nonatomic, retain) IBOutlet UITableView      *agendaTableView;
@property (nonatomic, retain) IBOutlet NSMutableArray   *agendaItems;
@property (nonatomic, retain) IBOutlet UIView           *underButtonView;
@property (nonatomic, retain) IBOutlet UIButton         *syncronizeButton;
@property (nonatomic, retain) IBOutlet UILabel          *syncronizeLabel;

@property (nonatomic, retain) UIBarButtonItem           *todayButton;
@property (nonatomic, retain) IBOutlet UILabel          *updatedLabel;

@property (nonatomic, assign) int                       todayIndex;

- (IBAction)SynchronizeAgenda:(id)sender;
- (IBAction)refreshAgenda:(id)sender;

@end
