//
//  MVYCrashReport.m
//  softonic
//
//  Created by Xavi Dolcet on 8/9/11.
//  Copyright 2011 Mobivery. All rights reserved.
//

//  Some code belongs to the UncaughtExceptions project by Matt Gallagher
//  More details: http://cocoawithlove.com/2010/05/handling-unhandled-exceptions-and.html

#import "MVYCrashReport.h"
#import "Util.h"
#import "Defines.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#include <signal.h>

// Exception and signal handlers
#pragma mark Exception handlers

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

void uncaughtExceptionHandler(NSException *exception) {
    
    NSArray *backtrace = [exception callStackSymbols];
    NSString *model = [[UIDevice currentDevice] model];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *message = [NSString stringWithFormat:@"Device: %@. OS: %@.\nMessage: %@\n Backtrace:\n%@",
                         model,
                         version,
                         [exception description],
                         backtrace];
    
    [[MVYCrashReport sharedInstance] saveCrashReport:message];
    //[Util registerExceptionEventWithMessage:message andException:exception];
}

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

void signalHandler(int signal) {    
	NSArray *callStack = [[MVYCrashReport sharedInstance] getBacktrace];
    NSString *model = [[UIDevice currentDevice] model];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *message = [NSString stringWithFormat:@"Device: %@. OS: %@. Backtrace:\n%@",
                         model,
                         version,
                         callStack];
	
    NSString *reason = [[NSString alloc] initWithFormat:@"Signal %d was raised",signal];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:signal],UncaughtExceptionHandlerSignalKey,callStack,UncaughtExceptionHandlerAddressesKey,nil];
    
    //NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason:reason userInfo:userInfo];
    [reason release];
    [userInfo release];
    
    [[MVYCrashReport sharedInstance] saveCrashReport:message];
    //[Util registerExceptionEventWithMessage:message andException:exception];
}

#pragma mark MVYCrashReport

@interface MVYCrashReport ()

- (void)fetchPendingCrashReports;
- (void)sendPendingCrashReports;
- (void)clearReports;
- (void)displayMailComposerWithMessage:(NSString *)message;
- (void)launchMailAppWithMessage:(NSString *)message;

@property (nonatomic, retain) NSArray *pendingReports;
@property (nonatomic, assign) id<CrashReportDelegate> delegate;

@end

@implementation MVYCrashReport

static MVYCrashReport *sharedInstance = nil;

static NSString *alertTitle;
static NSString *alertMessage;
static NSString *messageSubject;
static NSArray *messageRecipients;

@synthesize pendingReports, delegate;

- (id)init {
    if ( (self = [super init]) ) {
        signal(SIGABRT, signalHandler);
        signal(SIGILL, signalHandler);
        signal(SIGSEGV, signalHandler);
        signal(SIGFPE, signalHandler);
        signal(SIGBUS, signalHandler);
        signal(SIGPIPE, signalHandler);
        
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    }
    
    return self;
}

- (void)startCrashLoggingWithDelegate:(id<CrashReportDelegate>)aDelegate {
    [self setDelegate:aDelegate];
}

- (void)checkPendingCrashReport {
    
    [self fetchPendingCrashReports];
    BOOL unhandledReports = pendingReports && [pendingReports count] > 0;
    
    if (unhandledReports) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:NSLocalizableString(@"_no") otherButtonTitles:NSLocalizableString(@"_yes"),nil];
        [alert show];
        [alert release];
    }
}

- (NSArray *)getBacktrace {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = UncaughtExceptionHandlerSkipAddressCount; i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount;i++) {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)mailSentSuccessfully {
    [self clearReports];
}

- (void)saveCrashReport:(NSString *)message {
    // Save the crash reports in the temporary directory
    NSString *tempPath = NSTemporaryDirectory();
    
    // We use a uncaughtexception+timestamp to identify crashreports
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *filename = [[NSString alloc] initWithFormat:@"uncaughtexception-%d", timestamp];
    NSString *filePath = [tempPath stringByAppendingString:filename];
    
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filePath atomically:YES];
    
    [filename release];
}

#pragma mark Private methods

- (void)fetchPendingCrashReports {
    NSString *tempPath = NSTemporaryDirectory();
    
    NSError *error;
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:tempPath error:&error];
    
    NSMutableArray *fileNames = [[NSMutableArray alloc] init];
    
    if (contents) {
        for (NSString *element in contents) {
            if ([element rangeOfString:@"uncaughtexception"].location != NSNotFound) {
                NSString *fullPath = [[NSString alloc] initWithFormat:@"%@%@",tempPath,element];
                [fileNames addObject:fullPath];
                [fullPath release];
            }
        }
    }
    
    [self setPendingReports:[NSArray arrayWithArray:fileNames]];
    [fileNames release];
}

- (void)sendPendingCrashReports {
    
    if (pendingReports && [pendingReports count] > 0) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        NSString *timestamp;
        NSString *formattedTime;
        NSMutableString *message = [[NSMutableString alloc] init];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        for (NSString *element in pendingReports) {
            
            timestamp = [[element componentsSeparatedByString:@"-"] lastObject];
            double timeInterval = [timestamp doubleValue];
            
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
            formattedTime = [dateFormatter stringFromDate:date];
            [message appendFormat:@"Exception caught on %@\n", formattedTime];
            [date release];
            
            NSString *contentString = [[NSString alloc] initWithContentsOfFile:element 
                                                                      encoding:NSUTF8StringEncoding error:NULL];
            [message appendFormat:@"%@\n\n",contentString];
            [contentString release];
        }
        [pool drain];
        
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil && [mailClass canSendMail]) {
            [self displayMailComposerWithMessage:message];
        } else {
            [self launchMailAppWithMessage:message];
        }
        
        [dateFormatter release];
        [message release];
    }
}

- (void)clearReports {
    
    NSError *error;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if (pendingReports && [pendingReports count] > 0) {
        for (NSString *element in pendingReports) {
                [fileManager removeItemAtPath:element error:&error];
        }
    }
    
    [fileManager release];
}

- (void)displayMailComposerWithMessage:(NSString *)message {
    MFMailComposeViewController *messager = [[MFMailComposeViewController alloc] init];
    
    [messager setToRecipients:messageRecipients];
    [messager setSubject:messageSubject];
    [messager setMessageBody:message isHTML:NO];
    
    [delegate displayMailComposer:messager];
    
    [messager release];
}

- (void)launchMailAppWithMessage:(NSString *)message {
    
    NSString *address = [messageRecipients componentsJoinedByString:@","];
    
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@&subject=%@",address,messageSubject];
	NSString *body = [NSString stringWithFormat:@"&body=%@",message];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self clearReports];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark Delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizableString(@"_yes")]) {
        [self sendPendingCrashReports];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizableString(@"_no")]) {
        [self clearReports];
    }
    else {
        // Do nothing: we keep the files
    }
}

#pragma mark Singleton methods

+ (MVYCrashReport *)sharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[MVYCrashReport alloc] init];
		}
	}
	return sharedInstance;
}

+ (void)reportCrashesUsingTitle:(NSString *)title message:(NSString *)message andSubject:(NSString *)subject toRecipients:(NSArray *)recipients {
    alertTitle = [title retain];
    alertMessage = [message retain];
    messageSubject = [subject retain];
    messageRecipients = [recipients retain];
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];            
			return sharedInstance;  // assignment and return on first allocation
		}
	}
	return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;
}

- (id)autorelease {
	return self;
}

@end