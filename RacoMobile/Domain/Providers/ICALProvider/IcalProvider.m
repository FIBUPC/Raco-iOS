//
//  IcalProvider.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 23/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "IcalProvider.h"


@implementation IcalProvider

@synthesize delegate;
@synthesize currentEvent, currentEventValue, icalEvents;

- (id)initWithUrl:(NSString *)_url method:(NSString *)_method parameters:(NSString *)_parameters {
	if(!(self=[super init])){
		return nil;
	}
    
    icalParser = [[ICALParser alloc] initWithUrl:_url method:_method parameters:_parameters];
    icalParser.delegate = self;
    
	return self;
}

-(void)dealloc{
    [icalParser release];
    [self setCurrentEvent:nil];
    [self setCurrentEventValue:nil];
    [self setIcalEvents:nil];
    [self setDelegate:nil];
    [super dealloc];
}

#pragma mark - ICALParser Protocol methods

- (void)parseDidStartCalendar {
    icalEvents = [[NSMutableArray alloc] init];
}

- (void)parseDidBeginEvent {
    currentEvent = [[NSMutableDictionary alloc] init];
}

- (void)parseDidFoundProperty:(NSDictionary *)propertyDict {
    
    NSString *veventTag = [propertyDict objectForKey:@"vevenTag"];
    NSString *value     = [propertyDict objectForKey:@"value"];
        
    currentEventValue = value;
    
    //Add currentEventValue to currentEvent
    [currentEvent setObject:currentEventValue forKey:veventTag];
}

- (void)parseDidEndEvent {
    //Add currentEvent Dictionary to icalEvent Array
    [icalEvents addObject:currentEvent];
    [currentEvent release];
}

- (void)parseDidEndCalendar {
    [(id)[self delegate] performSelectorOnMainThread:@selector(ProcessCompleted:)
                                          withObject:(NSMutableArray *)icalEvents
                                       waitUntilDone:NO];
}

- (void)parseErrorOccurred:(NSError *)parseError {
    [(id)[self delegate] performSelectorOnMainThread:@selector(ProcessHasErrors:)
										  withObject:(NSError *)parseError
									   waitUntilDone:NO];
}

@end

