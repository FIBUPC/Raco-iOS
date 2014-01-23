//
//  Utils.m
//  iRaco
//
//  Created by Marcel Arbó on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "Defines.h"
#import "Reachability.h"


@implementation Utils

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending) 
        return NO;
    
    return YES;
}

+ (NSString *)convertDateFormat:(NSString *)oldStringDate{
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier] autorelease];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:enUSPOSIXLocale];
    [dateFormat setDateFormat:@"EEE, dd MMM y HH:mm:ss zzzzz"];  //"Wed, 06 Apr 2011 13:15:34 +0200"
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:kTimeZoneName]];
    
    NSDate *LargePubDate = [dateFormat dateFromString:oldStringDate];
    [dateFormat setDateFormat:@"dd/MM/YYYY HH:mm:ss"];              //"06/04/2011 13:15:34"
    NSString *newStringDateDate = [dateFormat stringFromDate:LargePubDate];
    [dateFormat release];
    
    return newStringDateDate;    
}

+ (NSString *)stringFromDate:(NSDate *)_date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:_date];
    [dateFormatter release];
    
    return dateString;
}

+ (NSString *)stringWithHourFromDate:(NSDate *)_date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:_date];
    [dateFormatter release];
    
    return dateString;
}

+ (NSDate *)getDateFromString:(NSString *)stringDate {
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier] autorelease];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:enUSPOSIXLocale];
    [dateFormat setDateFormat:@"dd'/'MM'/'y' 'HH:mm:ss"];  //"12/03/2011 10:00:00"
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:kTimeZoneName]];    
    
    NSDate *globalDate = [dateFormat dateFromString:stringDate];
    [dateFormat release];
    return globalDate;
}

+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;                 
        // find end of tag         
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@" "];
    }
    // trim off whitespace
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

@end
