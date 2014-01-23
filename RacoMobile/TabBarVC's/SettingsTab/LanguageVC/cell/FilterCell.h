//
//  FilterCell.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 28/03/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FilterCell : UITableViewCell {
    
    UILabel     *filterLabel;
    UIImageView *checkImage;
}

@property (nonatomic, retain) IBOutlet UILabel      *filterLabel;
@property (nonatomic, retain) IBOutlet UIImageView  *checkImage;
@end
