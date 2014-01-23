//
//  OccupationHandler.m
//  iRaco
//
//  Created by Marcel Arbó on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OccupationHandler.h"
#import "Defines.h"
#import "JSONProvider.h"
#import "Place.h"
#import "OccupationSubjectHandler.h"


@implementation OccupationHandler

@synthesize freePlacesArray, freePlacesArrayDict;
@synthesize delegate;

static OccupationHandler *sharedInstance = nil;

#pragma mark - Public Methods

- (void)startProcess{
    
    //Call for JSONProvider
    NSString *parameters = nil;
    NSString *url = kOccupationParserUrl;
    NSString *method = kGetMethod;
    
    jsonProvider = [[JSONProvider alloc] initWithUrl:url method:method parameters:parameters];
    jsonProvider.delegate = self;
}

- (void)saveFreePlacesDict:(NSDictionary *)_freePlacesDict {
    [sharedInstance setFreePlacesArrayDict:_freePlacesDict];
}

- (void)saveFreePlacesObjects:(NSDictionary *)_freePlacesArray {    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in freePlacesArrayDict) {
        Place *place = [[Place alloc] initWithDictionary:dict];
        [tempArray addObject:place];
        [place release];
    }
    
    [sharedInstance setFreePlacesArray:tempArray];
    [tempArray release];
}

- (NSMutableArray *)retrieveOccupationArrayWithTag:(NSString *)placeTag {
    //filter with tag
    NSMutableArray *filterOccupationArray = [[[NSMutableArray alloc] init] autorelease];
    for (Place *aPlace in freePlacesArray) {
        if ( !([[aPlace name] rangeOfString:placeTag].location == NSNotFound) ) {
            
            //Add subject to selectedPlaces
            NSString *subject = [[OccupationSubjectHandler sharedHandler] getActualSubjectFromPlace:(Place *)aPlace];
            [aPlace setSubject:subject];
            
            [filterOccupationArray addObject:aPlace];
        }
    }
    return filterOccupationArray;
}

#pragma mark - Delegate Methods

- (void)ProcessCompleted:(NSDictionary *)results {
    
    //Save array of dictionaris
    NSDictionary *dictOfFreePlaces = [results objectForKey:@"aules"];
    [self saveFreePlacesDict:dictOfFreePlaces];
    
    //Save array of class instances        
    NSDictionary *arrayOfFreePlacesDict = [results objectForKey:@"aules"];
    [self saveFreePlacesObjects:arrayOfFreePlacesDict];
    
    [(id)[self delegate] performSelectorOnMainThread:@selector(OccupationProcessCompleted:)
                                          withObject:(NSMutableArray *)freePlacesArray
                                       waitUntilDone:NO];
}

- (void)ProcessHasErrors:(NSError *)error {
    DLog(@"RacoSubjects parser: has error");
    [(id)[self delegate] performSelectorOnMainThread:@selector(OccupationProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
}

#pragma mark - Singleton

+ (OccupationHandler *)sharedHandler
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
