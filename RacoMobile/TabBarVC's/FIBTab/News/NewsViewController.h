//
//  NewsViewController.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 03/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    UITableView     *newsTableView;
    NSMutableArray  *newsArray;
    
    UIView          *noResultsView;
    UILabel         *noResultsLabel;
}

@property (nonatomic, retain) IBOutlet UITableView  *newsTableView;
@property (nonatomic, retain) NSMutableArray        *newsArray;

@property (nonatomic, retain) IBOutlet UIView       *noResultsView;
@property (nonatomic, retain) IBOutlet UILabel      *noResultsLabel;

@end
