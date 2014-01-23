//
//  AgendaIcsHandler.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 22/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "AgendaIcsHandler.h"
#import "IcalEvent.h"
#import "Defines.h"

@implementation AgendaIcsHandler

@synthesize agenda, agendaDict;
@synthesize delegate;

static AgendaIcsHandler *sharedInstance = nil;

#pragma mark - Public Methods

- (void)startProcess {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *icalPortadaIcsKey = [userDefaults objectForKey:kIcalPortadaIcsKey];
    NSString *urlBase = kAgendaIcsParserUrl; 
    NSString *url = [urlBase stringByAppendingString:icalPortadaIcsKey];
    
    //Call for IcalProvider
    NSString *parameters = nil;
    NSString *method = kGetMethod;
    
    icalProvider = [[IcalProvider alloc] initWithUrl:url method:method parameters:parameters];
    icalProvider.delegate = self;
    
}

- (void)saveAgendaDict:(NSDictionary *)_agendaDict {
    [sharedInstance setAgendaDict:_agendaDict];
}

- (void)saveAgendaObjects:(NSDictionary *)_agendaArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aDic in _agendaArray) {
        IcalEvent *anEvent = [[IcalEvent alloc] initWithDictionary:aDic];
        [tempArray addObject:anEvent];
        [anEvent release];
    }
    
    [sharedInstance setAgenda:tempArray];
    [tempArray release];
}

- (void)sortAgendaEvents {
    NSMutableArray *noSortedArray = [[NSMutableArray alloc] initWithArray:agenda];
    
    NSSortDescriptor *sortDescriptor; 
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"compareDate" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor]; 
    NSArray *sortedArray = [noSortedArray sortedArrayUsingDescriptors:sortDescriptors];
    [noSortedArray release];
    
    [[sharedInstance agenda] removeAllObjects];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (IcalEvent *anEvent in sortedArray) {
        [tempArray addObject:anEvent];
    }
    
    [sharedInstance setAgenda:tempArray];
    [tempArray release];
}

- (void)deleteData {
    [agenda removeAllObjects];
    NSDictionary *emtyDict = [[NSDictionary alloc] initWithObjectsAndKeys:nil];
    [self saveAgendaDict:emtyDict];
    [emtyDict release];
}

#pragma mark - Delegat eMethods

-(void)ProcessCompleted:(NSDictionary *)results {
    
    //Save array of dictionaris
    [self saveAgendaDict:results];
    
    //Save array of class instances
    [self saveAgendaObjects:results];
        
    [(id)[self delegate] performSelectorOnMainThread:@selector(agendaProcessCompleted:)
                                          withObject:(NSMutableArray *)agenda
                                       waitUntilDone:NO];
}

-(void)ProcessHasErrors:(NSError *)error {
    [(id)[self delegate] performSelectorOnMainThread:@selector(agendaProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
}

#pragma mark - Singleton

+ (AgendaIcsHandler *)sharedHandler
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
