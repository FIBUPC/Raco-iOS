//
//  ScheduleCell.h
//  RacoMobile
//
//  Created by Marcel Arbó on 28/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScheduleCell : UITableViewCell {
    UIImageView *backgroundImage;
    UILabel     *hourLabel;
    UILabel     *subjectLabel;
    UILabel     *classLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UILabel     *hourLabel;
@property (nonatomic, retain) IBOutlet UILabel     *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel     *classLabel;

@end
