//
//  Avis.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 17/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "Avis.h"
#import "Utils.h"


@implementation Avis

@synthesize title, link, description, pubDate, category;

- (id)initWithDictionary:(NSDictionary *)aDict {
    
    // Return nil if aDict is nil
    if (!aDict) return nil;
    
    if ( (self = [super init]) ) {
        
        NSString *newTitle = [Utils flattenHTML:[aDict objectForKey:kAvisTitle] trimWhiteSpace:YES];
        NSString *newLink = [Utils flattenHTML:[aDict objectForKey:kAvisLink] trimWhiteSpace:YES];
        NSString *newDescription = [Utils flattenHTML:[aDict objectForKey:kAvisDescription] trimWhiteSpace:YES];
        NSString *newPubDate = [Utils flattenHTML:[aDict objectForKey:kAvisPubDate] trimWhiteSpace:YES];
        NSString *newCategory = [aDict objectForKey:kAvisCategory];
        
        //Convert pubDate from "Wed, 06 Apr 2011 13:15:34 +0200" to "06/04/2011 13:15:34"
        newPubDate = [Utils convertDateFormat:newPubDate];
        
        if (newTitle) [self setTitle:newTitle];
        if (newLink) [self setLink:newLink];
        if (newDescription) [self setDescription:newDescription];
        if (newPubDate) [self setPubDate:newPubDate];
        if (newCategory) [self setCategory:newCategory];
    } 
    
    return self;
}

- (void)dealloc{
    [self setTitle:nil];
    [self setLink:nil];
    [self setDescription:nil];
    [self setPubDate:nil];
    [self setCategory:nil];
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
    return [self pubDate];
}

- (NSString *)commonItemImageUrl {
    return [self link];
}

- (NSString *)commonItemIcon {
    return @"headlines_icon_notice.png";
}

- (UIColor *)commonItemBackground {
    return [UIColor grayColor];
}

@end
