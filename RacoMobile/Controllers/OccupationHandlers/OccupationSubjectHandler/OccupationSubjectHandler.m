//
//  OccupationSubjectHandler.m
//  iRaco
//
//  Created by Marcel Arbó on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OccupationSubjectHandler.h"
#import "IcalEvent.h"
#import "Utils.h"
#import "Defines.h"

@implementation OccupationSubjectHandler

@synthesize placesSubject, placesSubjectDict;
@synthesize delegate;

static OccupationSubjectHandler *sharedInstance = nil;

#pragma mark - Public Methods

- (void)startProcess {
    
    //Call for IcalProvider
    NSString *url = kOccupationSubjectParserUrl;
    NSString *parameters = nil;
    NSString *method = kGetMethod;
    
    icalProvider = [[IcalProvider alloc] initWithUrl:url method:method parameters:parameters];
    icalProvider.delegate = self;
    
}

- (void)savePlacesSubjectDict:(NSDictionary *)_placesSubjectDict {
    [sharedInstance setPlacesSubjectDict:_placesSubjectDict];
}

- (void)saveplacesSubjectObjects:(NSDictionary *)_placesSubjectArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aDic in _placesSubjectArray) {
        IcalEvent *anEvent = [[IcalEvent alloc] initWithDictionary:aDic];
        [tempArray addObject:anEvent];
        [anEvent release];
    }
    
    [sharedInstance setPlacesSubject:tempArray];
    [tempArray release];

}

- (NSString *)getActualSubjectFromPlace:(Place *)aPlace {
    NSString *subject       = @"";
    NSDate *actualDate      = [NSDate date];
    NSString *actualStringDate = [NSDateFormatter localizedStringFromDate:actualDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]; //05/05/2011 18:21:15
    NSDate *eventStartDate  = nil;
    NSDate *eventEndDate    = nil;
    NSString *placeName     = [aPlace name];    //A5s102
    
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier] autorelease];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:enUSPOSIXLocale];
    [dateFormat setDateFormat:@"dd/MM/y HH:mm:ss"];  //"06/04/2011 13:15:34"
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:kTimeZoneName]];
    
    for (IcalEvent *event in placesSubject) {
        if([[[event location] lowercaseString] isEqualToString:[placeName lowercaseString]]) {      //C6s102 == C6S102
            eventStartDate  = [dateFormat dateFromString:[event dateStart]];
            eventEndDate    = [dateFormat dateFromString:[event dateEnd]];
            actualDate      = [dateFormat dateFromString:actualStringDate];
            //DLog(@"Event amb location:%@- start:%@- end:%@- sum:%@",[event location],eventStartDate,eventEndDate,[event summary]);
            
            if ([Utils date:actualDate isBetweenDate:eventStartDate andDate:eventEndDate]) {
                subject = [event summary];
                break;
            }
            
        }
        
    }
    
    [dateFormat release];
    
    return subject;
}

#pragma mark - Delegate Methods

-(void)ProcessCompleted:(NSDictionary *)results {
    
    //Save array of dictionaris
    [self savePlacesSubjectDict:results];
    
    //Save array of class instances
    [self saveplacesSubjectObjects:results];
        
    [(id)[self delegate] performSelectorOnMainThread:@selector(OccupationSubjectProcessCompleted:)
                                          withObject:(NSMutableArray *)placesSubject
                                       waitUntilDone:NO];
}

-(void)ProcessHasErrors:(NSError *)error {
    [(id)[self delegate] performSelectorOnMainThread:@selector(OccupationSubjectProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
}

#pragma mark - Singleton

+ (OccupationSubjectHandler *)sharedHandler
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

