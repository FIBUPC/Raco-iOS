//
//  MailHandler.m
//  iRaco
//
//  Created by LCFIB on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MailHandler.h"
#import "Mail.h"
#import "JSON.h"
#import "Defines.h"


@implementation MailHandler

@synthesize mails, mailsDict;
@synthesize delegate;
@synthesize username,password;

static MailHandler *sharedInstance = nil;

#pragma mark - Public Methods

- (void)startProcess{
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.username = [userDefaults objectForKey:@"usernamePref"];
	self.password = [userDefaults objectForKey:@"passwordPref"];
    int  maxEmails = [kMailParserMaxEmails intValue];
    
    NSString *parameters = [NSString stringWithFormat:@"max_emails=%i&username=%@&password=%@",maxEmails,username,password];
    NSString *url = kMailParserUrl;
    NSString *method = kPostMethod;
    
    jsonProvider = [[JSONProvider alloc] initWithUrl:url method:method parameters:parameters];
    jsonProvider.delegate = self;
}

- (void)saveMailDict:(NSDictionary *)_mailsDict {
    [sharedInstance setMailsDict:_mailsDict];
}

- (void)saveMailsObjects:(NSDictionary *)_mailsArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in _mailsArray) {
        Mail *mail = [[Mail alloc] initWithDictionary:dict];
        [tempArray addObject:mail];
        [mail release];
    }
    
    [sharedInstance setMails:tempArray];
    [tempArray release];
}

- (NSMutableArray *)retrieveMailsArrayWithNumber:(int)numMax {
    NSMutableArray *numMaxMailsArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < numMax; i++) {
        if ([mails count] > i+1) {
            [numMaxMailsArray addObject:[mails objectAtIndex:i]];
        }
        else break;
    }
	return numMaxMailsArray;
}

#pragma mark - Delegate Methods

-(void)ProcessCompleted:(NSDictionary *)results {
	
	//Control if "status" = "0" -> call processHasErrors.
	DLog(@"Status es: %@",[results objectForKey:@"status"]);
	if ([[results objectForKey:@"status"] isEqualToString:[NSString stringWithFormat:@"0"]]) {
        
        //Remove old mails
        [mails removeAllObjects];
        mailsDict = nil;
        
		[(id)[self delegate] performSelectorOnMainThread:@selector(mailProcessHasErrors:)
											  withObject:nil
										   waitUntilDone:NO];
	}
	else {

        //Save array of dictionaris
        NSDictionary *dictOfMails = [results objectForKey:@"mails"];
        [self saveMailDict:dictOfMails];
        
        //Save array of class instances        
        NSDictionary *arrayOfMailsDict = [results objectForKey:@"mails"];
        [self saveMailsObjects:arrayOfMailsDict];
        
		[(id)[self delegate] performSelectorOnMainThread:@selector(mailProcessCompleted:)
											  withObject:(NSMutableArray *)mails
										   waitUntilDone:NO];		
	}

	
}

-(void)ProcessHasErrors:(NSError *)error {
    DLog(@"Mails parser: has error");
    [(id)[self delegate] performSelectorOnMainThread:@selector(mailProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
    DLog(@"selector sent");
}

#pragma mark - Singleton

+ (MailHandler*)sharedHandler
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedHandler] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
