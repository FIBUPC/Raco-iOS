//
//  WifiProfileViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WifiProfileViewController : UIViewController <UITextFieldDelegate> {
    
    UIButton    *wifiButton;
    UILabel     *getProfileLabel;
    
    UITextField *usernameTextField;
    UITextView  *wifiTextView;
}

@property (nonatomic, retain) IBOutlet UIButton     *wifiButton;
@property (nonatomic, retain) IBOutlet UILabel     *getProfileLabel;

@property (nonatomic, retain) IBOutlet UITextField  *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextView   *wifiTextView;

- (IBAction)getWifiProfile:(id)sender;

@end
