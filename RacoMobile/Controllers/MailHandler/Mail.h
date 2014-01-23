//
//  Mail.h
//  iRaco
//
//  Created by Marcel Arbó on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemProtocol.h"


#pragma mark - constants
#define kMailFrom       @"from"
#define kMailSubject    @"subject"
#define kMailDate       @"date"
#define kMailUnseen     @"unseen"
#define kMailUrl        @"url"
#define kMailDeleted    @"deleted"
#pragma mark -


@interface Mail : NSObject <ItemProtocol> {
    NSString    *subject;
    NSString    *from;
    NSString    *date;
    NSString    *unseen; 
    NSString    *url;
    NSString    *deleted; 
}

@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *from;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *unseen;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *deleted;

- (id)initWithDictionary:(NSDictionary *)aDict;

@end
