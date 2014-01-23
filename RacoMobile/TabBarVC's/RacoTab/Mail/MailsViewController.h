//
//  MailsViewController.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 04/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView     *mailsTableView;
    NSMutableArray  *mailsArray;
    UIView          *underButtonView;
    UIButton        *syncronizeButton;
    UILabel         *syncronizeLabel;
    
    NSString        *selectedMailSubject;
    NSString        *selectedMailDate;
    int             selectedMailIndex;
    
    UIView          *noResultsView;
    UILabel         *noMailsLabel;
}

@property (nonatomic, retain) IBOutlet UITableView  *mailsTableView;
@property (nonatomic, retain) NSMutableArray        *mailsArray;
@property (nonatomic, retain) IBOutlet UIView       *underButtonView;
@property (nonatomic, retain) IBOutlet UIButton     *syncronizeButton;
@property (nonatomic, retain) IBOutlet UILabel      *syncronizeLabel;

@property (nonatomic, retain) NSString              *selectedMailSubject;
@property (nonatomic, retain) NSString              *selectedMailDate;
@property (nonatomic, assign) int                   selectedMailIndex;

@property (nonatomic, retain) IBOutlet UIView       *noResultsView;
@property (nonatomic, retain) IBOutlet UILabel      *noMailsLabel;

- (IBAction)SynchronizeMail:(id)sender;

@end
