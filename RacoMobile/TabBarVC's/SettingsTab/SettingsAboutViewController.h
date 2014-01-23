//
//  SettingsAboutViewController.h
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 09/09/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsAboutViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    UINavigationBar *settingsAboutToolBar;
    UILabel         *rateButtonLabel;
    UILabel         *contactLabel;
    UILabel         *contactButtonLabel;
    UILabel         *versionLabel;
    
    UILabel         *authorLabel;
    UILabel         *directorLabel;
    UILabel         *coDirectorLabel;
    UILabel         *designLabel;
    UILabel         *rightsReservedLabel;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *settingsAboutToolBar;
@property (nonatomic, retain) IBOutlet UILabel         *rateButtonLabel;
@property (nonatomic, retain) IBOutlet UILabel         *contactLabel;
@property (nonatomic, retain) IBOutlet UILabel         *contactButtonLabel;
@property (nonatomic, retain) IBOutlet UILabel         *versionLabel;

@property (nonatomic, retain) IBOutlet UILabel         *authorLabel;
@property (nonatomic, retain) IBOutlet UILabel         *directorLabel;
@property (nonatomic, retain) IBOutlet UILabel         *coDirectorLabel;
@property (nonatomic, retain) IBOutlet UILabel         *designLabel;
@property (nonatomic, retain) IBOutlet UILabel         *rightsReservedLabel;


- (IBAction)closeAboutView:(id)sender;
- (IBAction)rateAppplication:(id)sender;
- (IBAction)composeMail:(id)sender;

@end
