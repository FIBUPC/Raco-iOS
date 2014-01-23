//
//  FilterCell.m
//  softonic
//
//  Created by Victor L. Fernandez Rodrigo on 09/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilterCell.h"


@implementation FilterCell

@synthesize filterLabel,checkImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)dealloc {
    [self setFilterLabel:nil];
    [self setCheckImage:nil];
    [super dealloc];
}


@end
