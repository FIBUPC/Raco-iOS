//
//  Initial2ViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InitialViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UITabBarDelegate> {
    UITableView     *itemsTableView;
    NSMutableArray  *itemsArray;
    
    NSMutableArray  *mailsArray;
    NSMutableArray  *newsArray;
    NSMutableArray  *noticeArray;
    
    bool logged;
}

@property (nonatomic, retain) IBOutlet UITableView  *itemsTableView;
@property (nonatomic, retain) NSMutableArray        *itemsArray;
@property (nonatomic, retain) NSMutableArray        *mailsArray;
@property (nonatomic, retain) NSMutableArray        *newsArray;
@property (nonatomic, retain) NSMutableArray        *noticeArray;

- (void)refreshTableView;
- (void)insertItemsToArrayWithPriority;
- (void)setPrioriyToTableItems;

@end
