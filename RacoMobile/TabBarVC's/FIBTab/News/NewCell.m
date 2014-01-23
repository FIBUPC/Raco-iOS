//
//  NewCell.m
//  RacoMobile
//
//  Created by Marcel Arbó on 27/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "NewCell.h"


@implementation NewCell

@synthesize myBackgroundImage, thumbnailImage, titleLabel, descriptionLabel;

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
    [self setMyBackgroundImage:nil];
    [self setThumbnailImage:nil];
    [self setTitleLabel:nil];
    [self setDescriptionLabel:nil];
    [super dealloc];
}

@end

