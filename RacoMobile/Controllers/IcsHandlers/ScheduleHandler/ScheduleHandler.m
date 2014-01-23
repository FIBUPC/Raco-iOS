//
//  ScheduleHandler.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 23/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "ScheduleHandler.h"
#import "Utils.h"
#import "Defines.h"


@implementation ScheduleHandler

@synthesize scheduleEventsWithDate;
@synthesize schedule, scheduleDict; 
@synthesize delegate;

static ScheduleHandler *sharedInstance = nil; 

#pragma mark - Public Methods

- (void)startProcess {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *icalHorariIcsKey = [userDefaults objectForKey:kIcalHorariIcsKey];
    NSString *urlBase = kScheduleParserUrl;    
    NSString *url = [urlBase stringByAppendingString:icalHorariIcsKey];
    
    //Call for IcalProvider
    NSString *parameters = nil;
    NSString *method = kGetMethod;
    
    icalProvider = [[IcalProvider alloc] initWithUrl:url method:method parameters:parameters];
    icalProvider.delegate = self;
}

- (void)saveScheduleDict:(NSDictionary *)_scheduleDict {
    [sharedInstance setScheduleDict:_scheduleDict];
}

- (void)saveScheduleObjects:(NSDictionary *)_scheduleArray {
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    NSDate *dateKey;
    NSString *stringDateKey;
    
    for (NSDictionary *aDic in _scheduleArray) {
        IcalEvent *anEvent = [[IcalEvent alloc] initWithDictionary:aDic];
        
        //Add each event to the correlative date key on dictionary. (Each day has an array of events)
        dateKey = [Utils getDateFromString:[anEvent dateStart]];
        stringDateKey = [Utils stringFromDate:dateKey];
        if ([tempDict objectForKey:stringDateKey]) {
            [[tempDict objectForKey:stringDateKey] addObject:anEvent];
        }
        else {
            NSMutableArray *dateArray = [[NSMutableArray alloc] initWithObjects:anEvent, nil];
            [tempDict setObject:dateArray forKey:stringDateKey];
            [dateArray release];
        }
        
        [anEvent release];
    }
    
    [sharedInstance setSchedule:tempDict];
    [tempDict release];
}

- (NSString *)getTagFromVevent:(NSString *)vevent {
    
    NSString *tag = @"NONE";
    
    //Check for ";" case
    int separatorIndexSemiColon = [vevent rangeOfString:@";"].location;
    if ( (separatorIndexSemiColon == 7) || (separatorIndexSemiColon == 5) ) {
        //Case DTSTART;VALUE=DATE:20110506 || DEND;VALUE=DATE:20110506
        tag = [vevent substringToIndex:separatorIndexSemiColon];
    }
    else {
        int separatorIndex = [vevent rangeOfString:@":"].location;
        if (separatorIndex < 100) {
            tag = [vevent substringToIndex:separatorIndex];
        }
    }
    
    return tag;
}

- (void)saveEventsFromScheduleWithDate:(NSDate *)_date {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (IcalEvent *anEvent in schedule) {
        //if have same date that _date
        if (true) {
            [tempArray addObject:anEvent];
        }
        [anEvent release];
    }
    
    [sharedInstance setScheduleEventsWithDate:tempArray];
    [tempArray release];
}

- (NSMutableArray *)getEventWithInterval:hourTime date:(NSDate *)selectedDate fromEvents:(NSArray *)events {
    
    NSMutableArray *icalEventsArray = [[[NSMutableArray alloc] init] autorelease];
    
    //Get start and end interval hour
    int separatorIndex = [hourTime rangeOfString:@"-"].location;    //08:00-09:00
    
    NSString *startString = [hourTime substringToIndex:separatorIndex];
    int separatorStartIndex = [startString rangeOfString:@":"].location;
    int startHour = [[startString substringToIndex:separatorStartIndex] intValue];
    
    NSString *endString = [hourTime substringFromIndex:separatorIndex+1];
    int separatorEndIndex = [endString rangeOfString:@":"].location;
    int endHour = [[endString substringToIndex:separatorEndIndex] intValue];
    
    unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:units fromDate:selectedDate];
    [gregorian release];
    
    NSDateComponents *startComponents = [[[NSDateComponents alloc] init] autorelease];
    [startComponents setDay:[components day]];
    [startComponents setMonth:[components month]];
    [startComponents setYear:[components year]];
    [startComponents setHour:startHour];
    [startComponents setMinute:1];  //to get 08:01 and compared later than 08:00
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startComponents]; 
    
    NSDateComponents *endComponents = [[[NSDateComponents alloc] init] autorelease];
    [endComponents setDay:[components day]];
    [endComponents setMonth:[components month]];
    [endComponents setYear:[components year]];
    [endComponents setHour:endHour-1];
    [endComponents setMinute:59];  //to get 07:59 and compared earlier than 08:00
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endComponents];
    
    for (IcalEvent *event in events) {
        
        NSDate *eventStartDate = [Utils getDateFromString:[event dateStart]];
        NSDate *eventEndDate = [Utils getDateFromString:[event dateEnd]];
        
        //if startDate is later than eventStartDate && endDate is earlier than eventEndDate
        if ( ([startDate compare:eventStartDate] == NSOrderedDescending) && ([endDate compare:eventEndDate] == NSOrderedAscending) ) {
            //For example 08:01 is later than 08:00 and 08:59 is earlier than 10:00
            [icalEventsArray addObject:event];
        }
    }
    
    return icalEventsArray;
}

- (NSArray *)getEventsWithDate:(NSDate *)selectedDate { 
    return [schedule objectForKey:[Utils stringFromDate:selectedDate]];
}

- (void)deleteData {
    [schedule removeAllObjects];
    NSDictionary *emtyDict = [[NSDictionary alloc] initWithObjectsAndKeys:nil];
    [self saveScheduleDict:emtyDict];
    [emtyDict release];
}

#pragma mark - Delegate Methods

-(void)ProcessCompleted:(NSDictionary *)results {
    
    //Save array of dictionaris
    [self saveScheduleDict:results];
    
    //Save array of class instances
    [self saveScheduleObjects:results];
    
    [(id)[self delegate] performSelectorOnMainThread:@selector(scheduleProcessCompleted:)
                                          withObject:(NSMutableArray *)schedule
                                       waitUntilDone:NO];
}

-(void)ProcessHasErrors:(NSError *)error {
    [(id)[self delegate] performSelectorOnMainThread:@selector(scheduleProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
}

#pragma mark - Singleton

+ (ScheduleHandler *)sharedHandler 
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
