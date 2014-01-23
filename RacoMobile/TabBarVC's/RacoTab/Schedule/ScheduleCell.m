//
//  ScheduleCell.m
//  RacoMobile
//
//  Created by Marcel Arbó on 28/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "ScheduleCell.h"


@implementation ScheduleCell

@synthesize backgroundImage, hourLabel, subjectLabel, classLabel;

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

- (void)dealloc {
    [self setBackgroundImage:nil];
    [self setHourLabel:nil];
    [self setSubjectLabel:nil];
    [self setClassLabel:nil];
    [super dealloc];
}

@end
