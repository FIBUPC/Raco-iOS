//
//  AvisCell.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 18/06/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "AvisCell.h"


@implementation AvisCell
@synthesize myBackgroundImage, myNoticeImage, myTitleLabel, myDateLabel;

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
    [self setMyNoticeImage:nil];
    [self setMyDateLabel:nil];
    [self setMyTitleLabel:nil];
    [super dealloc];
}

@end
