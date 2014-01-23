//
//  FibSubjectDetailViewController.h
//  iRaco
//
//  Created by Marcel Arbó on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"
#import <MessageUI/MessageUI.h>

@interface FibSubjectDetailViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
    UIScrollView    *subjectScrollView;
    
    Subject         *fibSubjectDetail;    
    NSString        *subjectTag;
    NSString        *subjectId;
    
    UILabel         *name;
    UILabel         *description;
    UILabel         *credits;
    UILabel         *numCredits;
    UILabel         *objectius;
    UITextView      *objectiusText;
    UILabel         *bilbiografia;
    UITextView      *bilbiografiaText;
    UILabel         *bilbiografiaComplementaria;
    UITextView      *bilbiografiaComplementariaText;

    UILabel         *professors;
    
    UIView          *noResultsView;
    UILabel         *noResultsLabel;
    CGFloat         verticalScrollSize;
    
    NSMutableArray  *teacherEmailsArray;
    NSString        *selectedTeacher;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *subjectScrollView;

@property (nonatomic, retain) Subject               *fibSubjectDetail;
@property (nonatomic, retain) NSString              *subjectTag;
@property (nonatomic, retain) NSString              *subjectId;

@property (nonatomic, retain) IBOutlet UILabel      *name;
@property (nonatomic, retain) IBOutlet UILabel      *description;
@property (nonatomic, retain) IBOutlet UILabel      *credits;
@property (nonatomic, retain) IBOutlet UILabel      *numCredits;
@property (nonatomic, retain) IBOutlet UILabel      *objectius;
@property (nonatomic, retain) IBOutlet UITextView   *objectiusText;
@property (nonatomic, retain) IBOutlet UILabel      *bilbiografia;
@property (nonatomic, retain) IBOutlet UITextView   *bilbiografiaText;
@property (nonatomic, retain) IBOutlet UILabel      *bilbiografiaComplementaria;
@property (nonatomic, retain) IBOutlet UITextView   *bilbiografiaComplementariaText;
@property (nonatomic, retain) IBOutlet UILabel      *professors;

@property (nonatomic, retain) IBOutlet UIView       *noResultsView;
@property (nonatomic, retain) IBOutlet UILabel      *noResultsLabel;

@property (nonatomic, retain) NSMutableArray        *teacherEmailsArray;

- (IBAction)openMailComposer:(id)sender;

@end
