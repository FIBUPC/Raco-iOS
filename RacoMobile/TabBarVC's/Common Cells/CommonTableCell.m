//
//  CommonTableCell.m
//  RacoMobile
//
//  Created by Marcel Arbó on 19/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "CommonTableCell.h"


@implementation CommonTableCell

@synthesize backgroundImage, iconImage, titleLabel, iconImageName, iconImageNameSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    // Configure the view for the hightlighted state.
    
    if (highlighted) {
        [backgroundImage setImage:[UIImage imageNamed:@"comun_cell_.png"]];
        [iconImage setImage:[UIImage imageNamed:iconImageNameSelected]];
        [titleLabel setTextColor:[UIColor whiteColor]];
    }
    else {                
        [backgroundImage setImage:[UIImage imageNamed:@"comun_cell.png"]];
        [iconImage setImage:[UIImage imageNamed:iconImageName]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
    
    if (selected) {
        [backgroundImage setImage:[UIImage imageNamed:@"comun_cell_.png"]];
        [iconImage setImage:[UIImage imageNamed:iconImageNameSelected]];
        [titleLabel setTextColor:[UIColor whiteColor]];
    }
    else {                
        [backgroundImage setImage:[UIImage imageNamed:@"comun_cell.png"]];
        [iconImage setImage:[UIImage imageNamed:iconImageName]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
    }
}

- (void)dealloc
{
    [self setIconImageNameSelected:nil];
    [self setIconImageName:nil];
    [self setBackgroundImage:nil];
    [self setIconImage:nil];
    [self setTitleLabel:nil];
    [super dealloc];
}

@end
