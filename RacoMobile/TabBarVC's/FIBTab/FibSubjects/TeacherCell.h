//
//  TeacherCell.h
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 10/10/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeacherCell : UIViewController {
    UILabel *nameLabel;
    UILabel *emailLabel;
    
    UILabel *emailTextLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;

@property (nonatomic, retain) IBOutlet UILabel *emailTextLabel;

- (void)initializeCellwithName:(NSString *)name andEmail:(NSString *)email;

@end
