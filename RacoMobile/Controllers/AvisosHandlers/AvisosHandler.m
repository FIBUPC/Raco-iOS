//
//  AvisosHandler.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 17/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "AvisosHandler.h"
#import "Avis.h"
#import "Defines.h"


@implementation AvisosHandler

@synthesize avisos, avisosDict;
@synthesize delegate;

static AvisosHandler *sharedInstance = nil;

#pragma mark - Public Methods

- (void)startProcess {
    
    //Load user KEY for service
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *rssAvisosAssignaturesKey = [userDefaults objectForKey:kRssAvisosAssignaturesKey];
    NSString *urlBase = kAvisosRacoSubjectsUrl;    
    NSString *url = [urlBase stringByAppendingString:rssAvisosAssignaturesKey];
    
    NSString *xmlTag = kAvisosXMLTag;
    NSDictionary *attributesDict = nil;
    
    xmlProvider = [[XMLProvider alloc] initWithUrl:url xmlTag:xmlTag attributesDict:attributesDict];
    xmlProvider.delegate = self;
    
    [attributesDict release];
}

- (void)saveAvisosDict:(NSDictionary *)_avisosDict {
    [sharedInstance setAvisosDict:_avisosDict];
}

- (void)saveAvisosObjects:(NSDictionary *)_avisosArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in _avisosArray) {
        Avis *anAvis = [[Avis alloc] initWithDictionary:dict];
        [tempArray addObject:anAvis];
        [anAvis release];
    }
    
    [sharedInstance setAvisos:tempArray];
    [tempArray release];
}

- (NSMutableArray *)retrieveAvisosArrayWithNumber:(int)numMax {
    NSMutableArray *numMaxAvisosArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < numMax; i++) {
        if ([avisos count] > i) {
            [numMaxAvisosArray addObject:[avisos objectAtIndex:i]];
        }
        else break;
    }
	return numMaxAvisosArray;
}

- (NSMutableArray *)retrieveAvisosArrayWithTag:(NSString *)avisTag {
    
    // if avisTag is GRAU-BD and Avis Title is " GRAU-BD - TitolAvis ", we need to compare avisTag(GRAU-BD) with stripped avisFullName(GRAU-BD)

    NSString *avisFullName = @"";
    
    //Filter with tag
    NSMutableArray *filterAvisosArray = [[[NSMutableArray alloc] init] autorelease];
    for (Avis *anAvis in avisos) {
        
        int lineIndex = [[anAvis title] rangeOfString:@" - "].location;
        if (lineIndex < 100) {
            avisFullName = [[anAvis title] substringToIndex:lineIndex];
        }
        
        if ([avisTag isEqualToString:avisFullName]) {
            [filterAvisosArray addObject:anAvis];
        }
    }
	return filterAvisosArray;
}

#pragma mark -DelegateMethods

-(void)ProcessCompleted:(NSDictionary *)results {
    
    //Save array of dictionaris
    [self saveAvisosDict:results];
    
    //Save array of class instances
    [self saveAvisosObjects:results];
    
    [(id)[self delegate] performSelectorOnMainThread:@selector(avisosProcessCompleted:)
                                          withObject:(NSMutableArray *)avisos
                                       waitUntilDone:NO];
}

-(void)ProcessHasErrors:(NSError *)error {
    DLog(@"Avisos parser: has error");
    [(id)[self delegate] performSelectorOnMainThread:@selector(avisosProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
    DLog(@"selector sent");
}

#pragma mark - Singleton

+ (AvisosHandler *)sharedHandler
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
