//
//  FibSubjectDetailHandler.m
//  iRaco
//
//  Created by Marcel Arbó on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FibSubjectDetailHandler.h"
#import "Defines.h"


@implementation FibSubjectDetailHandler

@synthesize delegate;
@synthesize fibSubjectsDetail, tempFibSubjectsDetailDict, fibSubjectsDetailDict;

static FibSubjectDetailHandler *sharedInstance = nil;

#pragma mark - Public Methods

- (void)startProcessWithTag:(NSString *)aTag maxSubjects:(int)_maxSubjects {
    
    NSString *parameters = [NSString stringWithFormat:@"id=%@",aTag];
    NSString *url = kFibSubjectDetailUrl;
    NSString *method = kGetMethod;
    
    maxSubjects = _maxSubjects;
    
    jsonProvider = [[JSONProvider alloc] initWithUrl:url method:method parameters:parameters];
    jsonProvider.delegate = self;
}

- (Subject *)retrieveFibSubjectDetailWithTag:(NSString *)aTag {
    for (Subject *aSubject in fibSubjectsDetail) {
        if ([[aSubject idAssig] isEqualToString:aTag]) {
            return aSubject;
            break;
        }
    }
    return nil;
}

- (void)saveFibSubjectDetailDict:(NSArray *)_fibSubjectDetailDict {
    [sharedInstance setFibSubjectsDetailDict:_fibSubjectDetailDict];
}

- (void)saveFibSubjectDetailObject:(NSArray *)_fibSubjectDetail {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aDic in _fibSubjectDetail) {
        Subject *aSubject = [[Subject alloc] initWithDictionary:aDic];
        [tempArray addObject:aSubject];
        [aSubject release];
    }
    
    [sharedInstance setFibSubjectsDetail:tempArray];
    [tempArray release];
}

- (void)saveOneFibSubjectDetailDict:(NSDictionary *)_fibSubjectDetailDict {
    if (!tempFibSubjectsDetailDict) {
        tempFibSubjectsDetailDict = [[NSMutableArray alloc] init];
    }
    [[sharedInstance tempFibSubjectsDetailDict] addObject:_fibSubjectDetailDict];
    
    if ([tempFibSubjectsDetailDict count] == maxSubjects) {     //Check if is last element of all FibSubjectsDetail
        //Save all fibSubjectDetailDicts
        [self saveFibSubjectDetailDict:[sharedInstance tempFibSubjectsDetailDict]];
    }
}

- (void)saveOneFibSubjectDetailObject:(NSDictionary *)_fibSubjectDetail {
    if (!fibSubjectsDetail) {
        fibSubjectsDetail = [[NSMutableArray alloc] init];
    }
    
    Subject *aSubject = [[Subject alloc] initWithDictionary:_fibSubjectDetail];
    [[sharedInstance fibSubjectsDetail] addObject:aSubject];
    [aSubject release];
}


#pragma mark - Delegate Methods

-(void)ProcessCompleted:(NSDictionary *)results {
    
    if (!results) {
        [self ProcessHasErrors:nil];
    }
    else {
        
        //Save FibSubjectDetail class instance
        [self saveOneFibSubjectDetailDict:results];
        
        //Save FibSubjectDetail dictionary
        [self saveOneFibSubjectDetailObject:results];
        
        Subject *tempSubject = [[[Subject alloc] initWithDictionary:results] autorelease];    
        [(id)[self delegate] performSelectorOnMainThread:@selector(FibSubjectDetailProcessCompleted:)
                                              withObject:(Subject *)tempSubject
                                           waitUntilDone:NO];
    }
}

-(void)ProcessHasErrors:(NSError *)error {
    DLog(@"RacoSubjects parser: has error");
    [(id)[self delegate] performSelectorOnMainThread:@selector(FibSubjectDetailProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
}

#pragma mark - Singleton

+ (FibSubjectDetailHandler *)sharedHandler
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
