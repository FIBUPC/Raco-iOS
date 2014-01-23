//
//  LoginViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONProvider.h"


@interface LoginViewController : UIViewController <JSONProviderDelegate, UITextFieldDelegate>{
    UITextField     *usernameTextField;
    UITextField     *passwordTextField;
    UILabel         *status;
    NSMutableData   *responseData;
    
    UINavigationBar *loginToolBar;
    UIBarButtonItem *closeButton;
    
    UIButton        *logoutButton;
    UILabel         *logoutLabel;
    BOOL            logged;
    
    JSONProvider    *jsonData;
}

@property (nonatomic, retain) IBOutlet UITextField      *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField      *passwordTextField;
@property (nonatomic, retain) IBOutlet UILabel          *status;

@property (nonatomic, retain) IBOutlet UINavigationBar  *loginToolBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem  *closeButton;

@property (nonatomic, retain) IBOutlet UIButton         *logoutButton;
@property (nonatomic, retain) IBOutlet UILabel          *logoutLabel;

- (IBAction)checkLogin:(id)sender;
- (IBAction)closeLoginVC:(id)sender;
- (IBAction)logoutPressed:(id)sender;

@end
