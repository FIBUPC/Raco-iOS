//
//  ICALParser.m
//  iRaco
//
//  Created by Marcel Arbó on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ICALParser.h"


@interface ICALParser ()
- (void)parseIcsStringData:(NSString *)icsData;
- (NSString *)getTagFromVevent:(NSString *)vevent;
- (NSString *)getValueFromVevent:(NSString *)vevent;
@end


@implementation ICALParser

@synthesize delegate;

- (id)initWithUrl:(NSString *)_url method:(NSString *)_method parameters:(NSString *)_parameters {
	if(!(self=[super init])){
		return nil;
	}
    urlRequest = [[UrlRequest alloc] initWithUrl:_url method:_method parameters:_parameters];
    urlRequest.delegate = self;
    
	return self;
}

-(void)dealloc{
    [urlRequest release];
    [self setDelegate:nil];
    [super dealloc];
}

#pragma mark - UrlRequest Protocol methods

- (void)RequestHasErrors:(NSError *)error{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[(id)[self delegate] performSelectorOnMainThread:@selector(parseErrorOccurred:)
										  withObject:(NSError *)error
									   waitUntilDone:NO];
}

- (void)RequestCompleted:(NSString *)responseString {
    //Parse ics string Data
    [self parseIcsStringData:responseString];
}

#pragma mark - Private Methods

- (void)parseIcsStringData:(NSString *)icsData {
    NSArray *linesArray = [icsData componentsSeparatedByString:@"\r\n"];
    
    NSString *line      = nil;
    NSString *veventTag = nil;
    NSString *value     = nil;
    for (int i = 0; i < [linesArray count]; i++) {
        line = [linesArray objectAtIndex:i];
        if ([line isEqualToString:@"BEGIN:VCALENDAR"]) {
            //call start ical
            [(id)[self delegate] performSelectorOnMainThread:@selector(parseDidStartCalendar)
                                                  withObject:nil
                                               waitUntilDone:NO];
        }
        else if ([line isEqualToString:@"END:VCALENDAR"]) {
            //cal end ical
            [(id)[self delegate] performSelectorOnMainThread:@selector(parseDidEndCalendar)
                                                  withObject:nil
                                               waitUntilDone:NO];
        }
        else if ([line isEqualToString:@"BEGIN:VEVENT"]) {
            
            [(id)[self delegate] performSelectorOnMainThread:@selector(parseDidBeginEvent)
                                                  withObject:nil
                                               waitUntilDone:NO];
            
            i++;    //Acces to first element of an VEVENT
            for (int j = i; j < [linesArray count]; j++) {
                line = [linesArray objectAtIndex:j];
                veventTag = [self getTagFromVevent:line];
                if (![veventTag isEqualToString:@"NONE"]) {     //getValueFromEvent only if is Valid TAG
                    value = [self getValueFromVevent:line];
                }
                
                NSMutableDictionary *propertyDict = [[NSMutableDictionary alloc] init];
                [propertyDict setObject:veventTag forKey:@"vevenTag"];
                [propertyDict setObject:value forKey:@"value"];
                
                [(id)[self delegate] performSelectorOnMainThread:@selector(parseDidFoundProperty:)
                                                      withObject:(NSDictionary *)propertyDict
                                                   waitUntilDone:NO];
                [propertyDict release];
                
                if ([veventTag isEqualToString:@"END"]) {
                    [(id)[self delegate] performSelectorOnMainThread:@selector(parseDidEndEvent)
                                                          withObject:nil
                                                       waitUntilDone:NO];
                    
                    i = j;
                    break;
                }
            }
        }
    }
    
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

- (NSString *)getValueFromVevent:(NSString *)vevent {
    
    NSString *value;
    
//    //Check for ";" case
//    int separatorIndexSemiColon = [vevent rangeOfString:@";"].location;
//    if ( (separatorIndexSemiColon == 7) || (separatorIndexSemiColon == 5) ) {
//        //Case DTSTART;VALUE=DATE:20110506 || DEND;VALUE=DATE:20110506
//        int separatorIndexDATE = [vevent rangeOfString:@"DATE:"].location;
//        value = [vevent substringFromIndex:separatorIndexDATE+5];
//    }
//    else {
        int separatorIndex = [vevent rangeOfString:@":"].location;
        value = [vevent substringFromIndex:separatorIndex+1];
//    }
    return value;
}


@end
