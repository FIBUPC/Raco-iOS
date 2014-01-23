//
//  MailHandler.h
//  iRaco
//
//  Created by LCFIB on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONProvider.h"

@protocol MailHandlerDelegate;

@interface MailHandler : NSObject <JSONProviderDelegate> {
    
    NSString                *username;
	NSString                *password;
    
	id<MailHandlerDelegate> delegate;    
    JSONProvider            *jsonProvider;
    
    NSMutableArray          *mails;
    NSDictionary            *mailsDict;
}

@property (nonatomic, retain) NSString                  *username;
@property (nonatomic, retain) NSString                  *password;

@property(nonatomic, assign) id<MailHandlerDelegate>    delegate;

@property (nonatomic, retain) NSMutableArray            *mails;
@property (nonatomic, retain) NSDictionary              *mailsDict;

+ (MailHandler*)sharedHandler;

- (void)startProcess;
- (void)saveMailDict:(NSDictionary *)_mailsDict;
- (void)saveMailsObjects:(NSDictionary *)_mailsArray;
- (NSMutableArray *)retrieveMailsArrayWithNumber:(int)numMax;

@end

@protocol MailHandlerDelegate <NSObject>

- (void)mailProcessCompleted:(NSMutableArray *)mails;
- (void)mailProcessHasErrors:(NSError *)error;

@end
