//
//  LanguageViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LanguageViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    UITableView     *languageTableView;
    NSMutableArray  *languageItems;
    
    UIBarButtonItem *backBarButtonItem;
}

@property (nonatomic, retain) IBOutlet UITableView  *languageTableView;
@property (nonatomic, retain) NSMutableArray        *languageItems;

@property (nonatomic, retain) UIBarButtonItem       *backBarButtonItem;

@end