//
//  OccupationCell.h
//  RacoMobile
//
//  Created by Marcel Arbó on 27/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OccupationCell : UITableViewCell {
    UIImageView  *backgroundImage;
    UILabel      *titleLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView  *backgroundImage;
@property (nonatomic, retain) IBOutlet UILabel      *titleLabel;

@end
