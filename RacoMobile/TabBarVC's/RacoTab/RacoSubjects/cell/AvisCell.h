//
//  AvisCell.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 18/06/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AvisCell : UITableViewCell {
    UIImageView *myBackgroundImage;
    UIImageView *myNoticeImage;
    UILabel     *myDateLabel;
    UILabel     *myTitleLabel;    
}

@property (nonatomic, retain) IBOutlet UIImageView *myBackgroundImage;
@property (nonatomic, retain) IBOutlet UIImageView *myNoticeImage;
@property (nonatomic, retain) IBOutlet UILabel     *myDateLabel;
@property (nonatomic, retain) IBOutlet UILabel     *myTitleLabel;

@end
