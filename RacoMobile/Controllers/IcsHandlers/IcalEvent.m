//
//  AgendaEvent.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 23/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "IcalEvent.h"
#import "Utils.h"
#import "Defines.h"

@interface IcalEvent ()
- (NSString *)convertDateFormat:(NSString *)oldStringDate;
- (NSString *)getHourFromStringDate:(NSString *)stringDate;
- (NSDate *)getGlobalDateFromVevent:(NSString *)veventDate;
@end

@implementation IcalEvent

@synthesize summary, dateStamp, dateStart, dateEnd, uid, startHour, endHour, location, compareDate;

- (id)initWithDictionary:(NSDictionary *)aDict {
    
    // Return nil if aDict is nil
    if (!aDict) return nil;
    
    if ( (self = [super init]) ) {
        
        NSString *newDateStamp = [self convertDateFormat:[aDict objectForKey:@"DTSTAMP"]];
        NSString *newDateStart = [self convertDateFormat:[aDict objectForKey:@"DTSTART"]];
        NSString *newStartHour = [self getHourFromStringDate:[aDict objectForKey:@"DTSTART"]];
        NSDate *newCompareDate = [self getGlobalDateFromVevent:[aDict objectForKey:@"DTSTART"]];
        NSString *newDateEnd = [self convertDateFormat:[aDict objectForKey:@"DTEND"]];
        NSString *newEndHour = [self getHourFromStringDate:[aDict objectForKey:@"DTEND"]];
        NSString *newSummary = [Utils flattenHTML:[aDict objectForKey:@"SUMMARY"] trimWhiteSpace:YES];
        NSString *newUid = [aDict objectForKey:@"UID"];
        NSString *newLocation = [aDict objectForKey:@"LOCATION"];
        
        if (newDateStamp) [self setDateStamp:newDateStamp];
        if (newDateStart) [self setDateStart:newDateStart];
        if (newStartHour) [self setStartHour:newStartHour];
        if (newCompareDate) [self setCompareDate:newCompareDate];
        if (newDateEnd) [self setDateEnd:newDateEnd];
        if (newEndHour) [self setEndHour:newEndHour];
        if (newSummary) [self setSummary:newSummary];
        if (newUid) [self setUid:newUid];
        if (newLocation) [self setLocation:newLocation];
    } 
    
    return self;
}

- (void)dealloc{
    [self setSummary:nil];
    [self setDateStamp:nil];
    [self setDateStart:nil];
    [self setDateEnd:nil];
    [self setUid:nil];
    [self setStartHour:nil];
    [self setEndHour:nil];
    [self setLocation:nil];
    [self setCompareDate:nil];
	[super dealloc];
}

#pragma mark - Private Methods

- (NSString *)convertDateFormat:(NSString *)oldStringDate{
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier] autorelease];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *LargePubDate;
    if ([oldStringDate length]>8) {
        //Case "20110527T203933Z"
        [dateFormat setLocale:enUSPOSIXLocale];
        [dateFormat setDateFormat:@"YYYYMMdd'T'HHmmss'Z'"];  //"20110422T095308Z"
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:kTimeZoneName]];    
        LargePubDate = [dateFormat dateFromString:oldStringDate];
    }
    else {
        //case  "20110504" short DATE.
        [dateFormat setLocale:enUSPOSIXLocale];
        [dateFormat setDateFormat:@"YYYYMMdd"];  //"20110504"
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:kTimeZoneName]];
        LargePubDate = [dateFormat dateFromString:oldStringDate];
    }    
    
    [dateFormat setDateFormat:@"dd/MM/YYYY HH:mm:ss"];              //"06/04/2011 13:15:34"
    NSString *newStringDate = [dateFormat stringFromDate:LargePubDate];
    [dateFormat release];
    
    return newStringDate;
}

- (NSString *)getHourFromStringDate:(NSString *)stringDate {
    
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier] autorelease];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:enUSPOSIXLocale];
    [dateFormat setDateFormat:@"YYYYMMdd'T'HHmmss'Z'"];  //"20110422T095308Z"
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:kTimeZoneName]];
    
    NSDate *LargePubDate = [dateFormat dateFromString:stringDate];
    [dateFormat setDateFormat:@"HH:mm"];                //"13:00"
    NSString *hour = [dateFormat stringFromDate:LargePubDate];
    [dateFormat release];
    
    return hour;
}

- (NSDate *)getGlobalDateFromVevent:(NSString *)veventDate {
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier] autorelease];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if ([veventDate length]>8) {
        //Case "20110527T203933Z"
        [dateFormat setLocale:enUSPOSIXLocale];
        [dateFormat setDateFormat:@"YYYYMMdd'T'HHmmss'Z'"];  //"20110422T095308Z"
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:kTimeZoneName]];    
    }
    else {
        //case  "20110504" short DATE.
        [dateFormat setLocale:enUSPOSIXLocale];
        [dateFormat setDateFormat:@"YYYYMMdd"];  //"20110504"
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:kTimeZoneName]];    
    }    
    
    NSDate *globalDate = [dateFormat dateFromString:veventDate];
    [dateFormat release];
    return globalDate;
}

@end
