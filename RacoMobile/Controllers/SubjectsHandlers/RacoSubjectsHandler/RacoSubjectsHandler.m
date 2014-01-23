//
//  RacoSubjectsHandler.m
//  iRaco
//
//  Created by Marcel Arbó on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RacoSubjectsHandler.h"
#import "Subject.h"
#import "Defines.h"


@implementation RacoSubjectsHandler

@synthesize racoSubjects, racoSubjectsDict;
@synthesize delegate;

static RacoSubjectsHandler *sharedInstance = nil;

#pragma mark - Public Methods

- (void)startProcess{
    
    //Load user KEY for service
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *racoSubjectsKey = [userDefaults objectForKey:kRacoSubjectsKey];
    NSString *urlBase = kRacoSubjectsUrl;
    NSString *url = [urlBase stringByAppendingString:racoSubjectsKey];
    
    NSString *parameters = nil;
    NSString *method = kGetMethod;
    
    jsonProvider = [[JSONProvider alloc] initWithUrl:url method:method parameters:parameters];
    jsonProvider.delegate = self;
}

- (void)saveRacoSubjectsDict:(NSDictionary *)_racoSubjectsDict {
    [sharedInstance setRacoSubjectsDict:_racoSubjectsDict];
}

- (void)saveRacoSubjectsObjects:(NSDictionary *)_racoSubjectsArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aDic in _racoSubjectsArray) {
        Subject *aSubject = [[Subject alloc] initWithDictionary:aDic];
        [tempArray addObject:aSubject];
        [aSubject release];
    }
    
    [sharedInstance setRacoSubjects:tempArray];
    [tempArray release];
}

#pragma mark - Delegate Methods

-(void)ProcessCompleted:(NSDictionary *)results {
    
    //Save array of dictionaris
    [self saveRacoSubjectsDict:results];
    
    //Save array of class instances
    [self saveRacoSubjectsObjects:results];
    
    [(id)[self delegate] performSelectorOnMainThread:@selector(RacoSubjectsProcessCompleted:)
                                          withObject:(NSMutableArray *)racoSubjects
                                       waitUntilDone:NO];
}

-(void)ProcessHasErrors:(NSError *)error {
    DLog(@"RacoSubjects parser: has error");
    [(id)[self delegate] performSelectorOnMainThread:@selector(RacoSubjectsProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
}

#pragma mark - Singleton

+ (RacoSubjectsHandler *)sharedHandler
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
