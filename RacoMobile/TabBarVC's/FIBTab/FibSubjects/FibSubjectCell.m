//
//  FibSubjectCell.m
//  RacoMobile
//
//  Created by Marcel Arbó on 27/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "FibSubjectCell.h"


@implementation FibSubjectCell

@synthesize backgroundImage, titleLabel, descriptionLabel;

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
        [titleLabel setTextColor:[UIColor whiteColor]];
        [descriptionLabel setTextColor:[UIColor whiteColor]];
    }
    else {                
        [backgroundImage setImage:[UIImage imageNamed:@"comun_cell.png"]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [descriptionLabel setTextColor:[UIColor darkGrayColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
    
    if (selected) {
        [backgroundImage setImage:[UIImage imageNamed:@"comun_cell_.png"]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [descriptionLabel setTextColor:[UIColor whiteColor]];
    }
    else {                
        [backgroundImage setImage:[UIImage imageNamed:@"comun_cell.png"]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [descriptionLabel setTextColor:[UIColor darkGrayColor]];
    }
}

- (void)dealloc
{
    [self setDescriptionLabel:nil];
    [self setBackgroundImage:nil];
    [self setTitleLabel:nil];
    [super dealloc];
}

@end
