//
//  Mail.m
//  iRaco
//
//  Created by Marcel Arbó on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Mail.h"


@implementation Mail

@synthesize from, subject, date, unseen, url, deleted;

- (id)initWithDictionary:(NSDictionary *)aDict {
    
    // Return nil if aDict is nil
    if (!aDict) return nil;
    
    if ( (self = [super init]) ) {
        
        //Replace some html tags from "from"
        NSString *htmlFrom = [aDict objectForKey:kMailFrom];
        htmlFrom = [htmlFrom stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        htmlFrom = [htmlFrom stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        NSString *newFrom = htmlFrom;
        
        NSString *newSubject = [aDict objectForKey:kMailSubject];
        NSString *newDate = [aDict objectForKey:kMailDate];
        NSString *newUnseen = [aDict objectForKey:kMailUnseen];
        NSString *newUrl = [aDict objectForKey:kMailUrl];
        NSString *newDeleted = [aDict objectForKey:kMailDeleted];
        
        if (newFrom) [self setFrom:newFrom];
        if (newSubject) [self setSubject:newSubject];
        if (newDate) [self setDate:newDate];
        if (newUnseen) [self setUnseen:newUnseen];
        if (newUrl) [self setUrl:newUrl];        
        if (newDeleted) [self setDeleted:newDeleted];
    }
    
    return self;
}

- (void)dealloc {
    [self setFrom:nil];
    [self setSubject:nil];
    [self setDate:nil];
    [self setUnseen:nil];
    [self setUrl:nil];
    [self setDeleted:nil];
    [super dealloc];
}

#pragma mark - Protocol methods

- (NSString *)commonItemTitle {
    return [self subject];
}

- (NSString *)commonItemDescription {
    return [self from];
}

- (NSString *)commonItemDate {
    return [self date];
}

- (NSString *)commonItemImageUrl {
    return [self url];
}

- (NSString *)commonItemIcon {
    return @"headlines_icon_email_blue.png";
}

- (UIColor *)commonItemBackground {
    return [UIColor blackColor];
}

@end