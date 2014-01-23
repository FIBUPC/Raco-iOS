//
//  MailCell.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 18/06/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MailCell : UITableViewCell {
    UIImageView *myBackgroundImage;
    UIImageView *myMailImage;
    UILabel     *myDateLabel;
    UILabel     *myTitleLabel;
    UILabel     *myFromLabel;
    UILabel     *myFromTextLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *myBackgroundImage;
@property (nonatomic, retain) IBOutlet UIImageView *myMailImage;
@property (nonatomic, retain) IBOutlet UILabel     *myDateLabel;
@property (nonatomic, retain) IBOutlet UILabel     *myTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel     *myFromLabel;
@property (nonatomic, retain) IBOutlet UILabel     *myFromTextLabel;

@end
