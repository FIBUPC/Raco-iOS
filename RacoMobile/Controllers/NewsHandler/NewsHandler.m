//
//  NewsHandler.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 17/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "NewsHandler.h"
#import "NewRss.h"
#import "Defines.h"


@implementation NewsHandler

@synthesize news, newsDict;
@synthesize delegate;

static NewsHandler *sharedInstance = nil;

#pragma mark - Public Methods

- (void)startProcess{

    NSString *url = kNewRssParserUrl;
    NSString *xmlTag = kNewRssXMLTag;
    NSDictionary *attributesDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:KNewUrl,nil] 
                                                                forKeys:[NSArray arrayWithObjects:kNewThumb,nil]];
    
    xmlProvider = [[XMLProvider alloc] initWithUrl:url xmlTag:xmlTag attributesDict:attributesDict];
    xmlProvider.delegate = self;
    
    [attributesDict release];
}

- (void)saveNewsDict:(NSDictionary *)_newsDict {
    [sharedInstance setNewsDict:_newsDict];
}

- (void)saveNewsObjects:(NSDictionary *)_newsArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in _newsArray) {
        NewRss *aNew = [[NewRss alloc] initWithDictionary:dict];
        [tempArray addObject:aNew];
        [aNew release];
    }
    
    [sharedInstance setNews:tempArray];
    [tempArray release];
}

- (NSMutableArray *)retrieveNewsArrayWithNumber:(int)numMax {
    NSMutableArray *numMaxNewsArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < numMax; i++) {
        if ([news count] > i+1) {
            [numMaxNewsArray addObject:[news objectAtIndex:i]];
        }
        else break;
    }
	return numMaxNewsArray;
}

#pragma mark - Delegate Methods

-(void)ProcessCompleted:(NSDictionary *)results {
    
    //Save array of dictionaris
    [self saveNewsDict:results];
    
    //Save array of class instances
    [self saveNewsObjects:results];
    
    [(id)[self delegate] performSelectorOnMainThread:@selector(newRssProcessCompleted:)
                                          withObject:(NSMutableArray *)news
                                       waitUntilDone:NO];
}

-(void)ProcessHasErrors:(NSError *)error {
    DLog(@"News parser: has error");
    [(id)[self delegate] performSelectorOnMainThread:@selector(newRssProcessHasErrors:)
                                          withObject:(NSError *)error
                                       waitUntilDone:NO];
    DLog(@"selector sent");
}

#pragma mark -
#pragma mark Singleton

+ (NewsHandler *)sharedHandler
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
