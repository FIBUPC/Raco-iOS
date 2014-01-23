//
//  FreePlaceOccupationCell.m
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 01/10/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "FreePlaceOccupationCell.h"


@implementation FreePlaceOccupationCell

@synthesize backgroundImage, classNameLabel, placesLabel, subjectLabel, freePlacesNumberLabel, subjectNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)dealloc
{
    [self setBackgroundImage:nil];
    [self setClassNameLabel:nil];
    [self setPlacesLabel:nil];
    [self setSubjectLabel:nil];
    [self setFreePlacesNumberLabel:nil];
    [self setSubjectNameLabel:nil];
    [super dealloc];
}


@end
