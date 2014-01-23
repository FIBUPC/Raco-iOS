//
//  MVYCrashReport.h
//  softonic
//
//  Created by Xavi Dolcet on 8/9/11.
//  Copyright 2011 Mobivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

// Since MVYCrashReport is a NSObject but we need to show a MFMailComposer
// we need a delegate who's able to present it inside a modal view.
// We enforce this using the CrashReportDelegate protocol 
@protocol CrashReportDelegate

@required
- (void)displayMailComposer:(MFMailComposeViewController *)mailViewController;

@end

@interface MVYCrashReport : NSObject<UIAlertViewDelegate> {
    NSArray *pendingReports;
    id<CrashReportDelegate> delegate;
}

// Starts the signal/exception logging for a delegate.
- (void)startCrashLoggingWithDelegate:(id<CrashReportDelegate>)delegate;

// Check if we have unsent crash reports.
// Will display an alert asking the user what to do with these reports.
- (void)checkPendingCrashReport;

// Utility method to construct a backtrace manually.
- (NSArray *)getBacktrace;

// This method will be called by the delegate when the mail has been sent.
- (void)mailSentSuccessfully;

- (void)saveCrashReport:(NSString *)message;

// Create a singleton object of MVYCrashReport.
+ (MVYCrashReport *)sharedInstance;

// Configure the messages and emails that MVYCrashReport will generate.
// Recipients is an Array of email addresses (NSString)
+ (void)reportCrashesUsingTitle:(NSString *)title message:(NSString *)message andSubject:(NSString *)subject toRecipients:(NSArray *)recipients;

@end