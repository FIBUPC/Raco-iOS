//
//  RacoViewController.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 25/03/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RacoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITabBarDelegate> {
    UITableView     *racoTableView;
    NSMutableArray  *racoItems;
    bool logged;    
    UIImageView     *backgroundImage;
    UIButton        *loginButton;
    UIView          *needLoginView;
    UILabel         *needLoginLabel;
}

@property (nonatomic, retain) IBOutlet UITableView  *racoTableView;
@property (nonatomic, retain) NSMutableArray        *racoItems;
@property (nonatomic, retain) IBOutlet UIImageView  *backgroundImage;
@property (nonatomic, retain) IBOutlet UIButton     *loginButton;
@property (nonatomic, retain) IBOutlet UIView       *needLoginView;
@property (nonatomic, retain) IBOutlet UILabel      *needToLoginLabel;

- (IBAction)needToLoginImagePressed:(id)sender;
- (void)openLoginViewController;

@end