//
//  CommonTableCell.h
//  RacoMobile
//
//  Created by Marcel Arbó on 19/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommonTableCell : UITableViewCell {
    UIImageView     *backgroundImage;
    UIImageView     *iconImage;
    UILabel         *titleLabel;
    NSString        *iconImageName;
    NSString        *iconImageNameSelected;
}

@property (nonatomic, retain) IBOutlet UIImageView  *backgroundImage;
@property (nonatomic, retain) IBOutlet UIImageView  *iconImage;
@property (nonatomic, retain) IBOutlet UILabel      *titleLabel;
@property (nonatomic, retain) NSString              *iconImageName;
@property (nonatomic, retain) NSString              *iconImageNameSelected;

@end
