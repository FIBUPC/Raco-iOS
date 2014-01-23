//
//  FibSubjectCell.h
//  RacoMobile
//
//  Created by Marcel Arbó on 27/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FibSubjectCell : UITableViewCell {
    UIImageView *backgroundImage;
    UILabel     *titleLabel;
    UILabel     *descriptionLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView  *backgroundImage;
@property (nonatomic, retain) IBOutlet UILabel      *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel      *descriptionLabel;

@end