//
//  MailCell.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 18/06/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "MailCell.h"


@implementation MailCell

@synthesize myBackgroundImage, myMailImage, myDateLabel, myTitleLabel, myFromLabel, myFromTextLabel;

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
    [self setMyMailImage:nil];
    [self setMyDateLabel:nil];
    [self setMyTitleLabel:nil];
    [self setMyFromLabel:nil];
    [self setMyFromTextLabel:nil];
    [super dealloc];
}

@end
