//
//  AvisosDetailViewController.h
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 17/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Avis.h"


@interface AvisosDetailViewController : UIViewController {
    
    Avis        *avisDetail;
    
    UITextView  *titleText;
    UILabel     *dateLabel;
    UILabel     *descriptionLabel;
    UIWebView   *descriptionWebView;
    UIImageView *imageView;
    
    UILabel     *goToWebLabel;
}

@property (nonatomic, retain) Avis *avisDetail;

@property (nonatomic, retain) IBOutlet UITextView  *titleText;
@property (nonatomic, retain) IBOutlet UILabel     *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel     *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIWebView   *descriptionWebView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) IBOutlet UILabel     *goToWebLabel;

- (IBAction)openWebView:(id)sender;

@end
