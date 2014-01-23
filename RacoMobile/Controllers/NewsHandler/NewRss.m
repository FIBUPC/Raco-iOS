//
//  NewRss.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 17/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "NewRss.h"
#import "Utils.h"


@implementation NewRss

@synthesize title, description, linkUrl, guidUrl, pubDate, mediaUrl, appIcon;

- (id)initWithDictionary:(NSDictionary *)aDict {
    
    // Return nil if aDict is nil
    if (!aDict) return nil;
    
    if ( (self = [super init]) ) {
        
        NSString *newTitle = [Utils flattenHTML:[aDict objectForKey:kNewTitle] trimWhiteSpace:YES];
        NSString *newDescription = [Utils flattenHTML:[aDict objectForKey:kNewDescription] trimWhiteSpace:YES];
        NSString *newLinkUrl = [Utils flattenHTML:[aDict objectForKey:kNewLink] trimWhiteSpace:YES];
        NSString *newGuidUrl = [aDict objectForKey:kNewTGuid];
        NSString *newPubDate = [Utils flattenHTML:[aDict objectForKey:kNewPubDate] trimWhiteSpace:YES];
        NSString *newMediaUrl = [Utils flattenHTML:[aDict objectForKey:kNewThumb] trimWhiteSpace:YES];
        
        //Replace " " from images
        if (newMediaUrl) {
            newMediaUrl = [newMediaUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        }
        
        //Convert pubDate from "Wed, 06 Apr 2011 13:15:34 +0200" to "06/04/2011 13:15:34"
        newPubDate = [Utils convertDateFormat:newPubDate];
         
        if (newTitle) [self setTitle:newTitle];
        if (newDescription) [self setDescription:newDescription];
        if (newLinkUrl) [self setLinkUrl:newLinkUrl];
        if (newGuidUrl) [self setGuidUrl:newGuidUrl];
        if (newPubDate) [self setPubDate:newPubDate];
        if (newMediaUrl) [self setMediaUrl:newMediaUrl];
    } 
    
    return self;
}

- (void)dealloc{
    [self setTitle:nil];
    [self setDescription:nil];
    [self setLinkUrl:nil];
    [self setGuidUrl:nil];
    [self setPubDate:nil];
    [self setMediaUrl:nil];
    [self setAppIcon:nil];
	[super dealloc];
}

#pragma mark - Protocol methods

- (NSString *)commonItemTitle {
    return [self title];
}

- (NSString *)commonItemDescription {
    return [self description];
}

- (NSString *)commonItemDate {
    return  [self pubDate];
}

- (NSString *)commonItemImageUrl {
    return [self mediaUrl];
}

- (NSString *)commonItemIcon {
    return @"headlines_icon_news.png";
}

- (UIColor *)commonItemBackground {
    return [UIColor grayColor];
}

@end
