//
//  FreePlaceOccupationCell.h
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 01/10/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FreePlaceOccupationCell : UITableViewCell {
    UIImageView *backgroundImage;
    UILabel     *classNameLabel;
    UILabel     *placesLabel;
    UILabel     *subjectLabel;
    UILabel     *freePlacesNumberLabel;
    UILabel     *subjectNameLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UILabel     *classNameLabel;
@property (nonatomic, retain) IBOutlet UILabel     *placesLabel;
@property (nonatomic, retain) IBOutlet UILabel     *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel     *freePlacesNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel     *subjectNameLabel;

@end
