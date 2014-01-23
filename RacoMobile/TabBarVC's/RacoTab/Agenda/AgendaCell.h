//
//  AgendaCell.h
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 01/10/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AgendaCell : UITableViewCell {
    UIImageView *backgroundImage;
    UILabel     *titleLabel;
    UILabel     *dateLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UILabel     *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel     *dateLabel;

@end
