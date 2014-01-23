//
//  NoticiaTextViewController.h
//  iRaco
//
//  Created by LCFIB on 17/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewRss.h"


@interface NoticiaTextViewController : UIViewController {
	UITextView  *titleTextView;
	UITextView  *descriptionTextView;
    UIImageView *imageView;
    UILabel     *dateLabel;
	UIToolbar   *toolbar;
	NSString    *urlWeb;
	NSString    *titol;
    NSString    *image;
    
    UILabel     *goToWebLabel;
    UIButton    *goToWebButton;
    
    NewRss      *myNewRss;
    
    
}

@property (nonatomic, retain) IBOutlet UITextView   *titleTextView;
@property (nonatomic, retain) IBOutlet UITextView   *descriptionTextView;
@property (nonatomic, retain) IBOutlet UIImageView  *imageView;
@property (nonatomic, retain) IBOutlet UILabel      *dateLabel;
@property (nonatomic, retain) IBOutlet UIToolbar    *toolbar;
@property (nonatomic, retain) NSString              *urlWeb;
@property (nonatomic, retain) NSString              *titol;
@property (nonatomic, retain) NSString              *image;

@property (nonatomic, retain) IBOutlet UILabel      *goToWebLabel;
@property (nonatomic, retain) IBOutlet UIButton     *goToWebButton;

@property (nonatomic, retain) NewRss                *myNewRss;

- (IBAction) openWebView:(id)sender;

@end
