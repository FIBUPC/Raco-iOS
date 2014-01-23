//
//  AgendaCell.m
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 01/10/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "AgendaCell.h"


@implementation AgendaCell

@synthesize backgroundImage, titleLabel, dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Custom initialization
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
    [self setTitleLabel:nil];
    [self setDateLabel:nil];
    [super dealloc];
}


@end
