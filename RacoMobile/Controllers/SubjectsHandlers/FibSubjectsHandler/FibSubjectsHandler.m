//
//  FibSubjectsHandler.m
//  iRaco
//
//  Created by Marcel Arbó on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FibSubjectsHandler.h"
#import "Subject.h"
#import "Defines.h"


@implementation FibSubjectsHandler

@synthesize fibSubjects, fibSubjectsDict;
@synthesize delegate;

static FibSubjectsHandler *sharedInstance = nil;

#pragma mark - Public Methods

- (void)startProcess{
    
    NSString *parameters = nil;
    NSString *url = kFibSubjectsUrl;
    NSString *method = kGetMethod;
    
    jsonProvider = [[JSONProvider alloc] initWithUrl:url method:method parameters:parameters];
    jsonProvider.delegate = self;
}

- (void)saveFibSubjectsDict:(NSDictionary *)_fibSubjectsDict {
    [sharedInstance setFibSubjectsDict:_fibSubjectsDict];
}

- (void)saveFibSubjectsObjects:(NSDictionary *)_fibSubjectsArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aDic in _fibSubjectsArray) {
        Subject *aSubject = [[Subject alloc] initWithDictionary:aDic];
        [tempArray addObject:aSubject];
        [aSubject release];
    }
    
    [sharedInstance setFibSubjects:tempArray];
    [tempArray release];
}

- (void)sortFibSubjects {
    NSMutableArray *noSortedArray = [[NSMutableArray alloc] initWithArray:fibSubjects];
    
    NSSortDescriptor *sortDescriptor; 
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"idAssig" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor]; 
    NSArray *sortedArray = [noSortedArray sortedArrayUsingDescriptors:sortDescriptors];
    [noSortedArray release];
    
    [[sharedInstance fibSubjects] removeAllObjects];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (Subject *aSubject in sortedArray) {
        [tempArray addObject:aSubject];
    }
    
    [sharedInstance setFibSubjects:tempArray];
    [tempArray release];
}

#pragma mark - Delegate Methods

-(void)ProcessCompleted:(NSDictionary *)results {
    
    //Save array of dictionaris
    [self saveFibSubjectsDict:results];
    
    //Save array of class instances
    [self saveFibSubjectsObjects:results];
    
    [(id)[self delegate] performSelectorOnMainThread:@selector(FibSubjectsProcessCompleted:)
                                          withObject:(NSMutableArray *)fibSubjects
                                       waitUntilDone:NO];
}

-(void)ProcessHasErrors:(NSError *)error {
    DLog(@"RacoSubjects parser: has error");
    [(id)[self delegate] performSelectorOnMainThread:@selector(FibSubjectsProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
}

#pragma mark - Singleton

+ (FibSubjectsHandler *)sharedHandler
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
