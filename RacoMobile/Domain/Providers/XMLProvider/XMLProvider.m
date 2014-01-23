//
//  XMLProvider.m
//  iRaco
//
//  Created by LCFIB on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLProvider.h"

@interface XMLProvider ()
- (void)startProcess;
- (BOOL)containsAttribute:(NSString *)aTag;
- (NSString *)getTagForAttribute:(NSString *)anAttribute;
@end

@implementation XMLProvider

@synthesize delegate;
@synthesize retrieverQueue;
@synthesize currentItem, currentItemValue, ItemsArray;
@synthesize xmlUrl, xmlTag, attributesDict;

- (id)initWithUrl:(NSString *)_url xmlTag:(NSString *)_xmlTag attributesDict:(NSDictionary *)_attributesDict {
	if(!(self=[super init])){
		return nil;
	}
    //Set the url and xmlTag values
    [self setXmlUrl:_url];
    [self setXmlTag:_xmlTag];
    [self setAttributesDict:_attributesDict];
    //Call to start process
    [self startProcess];
    return self;
}

-(void)dealloc{
    [self setCurrentItem:nil];
    [self setCurrentItemValue:nil];
    [self setItemsArray:nil];
    [self setXmlUrl:nil];
    [self setXmlTag:nil];
    [self setAttributesDict:nil];
    [self setRetrieverQueue:nil];
    [self setItemsArray:nil];
    [self setDelegate:nil];
    [super dealloc];
}

- (NSOperationQueue *)retrieverQueue {
	if(nil == retrieverQueue) {
		retrieverQueue = [[NSOperationQueue alloc] init];
		retrieverQueue.maxConcurrentOperationCount = 1;
	}
	return retrieverQueue;
}

- (void)startProcess {
	SEL method = @selector(fetchAndParseRss);
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self 
																	 selector:method 
																	   object:nil];
	[self.retrieverQueue addOperation:op];
	[op release];
}

-(BOOL)fetchAndParseRss {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	//To suppress the leak in NSXMLParser
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	
	NSURL *url = [NSURL URLWithString:xmlUrl];
    
    //Init the Array of <tag> dictionaries
    ItemsArray = [[NSMutableArray alloc] init];
    
	BOOL success = NO;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	[parser setShouldResolveExternalEntities:NO];
	success = [parser parse];
	[parser release];
	[pool drain];
	return success;
}

#pragma mark - MXLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if(nil != qualifiedName){
		elementName = qualifiedName;
	}
    //DLog(@"\n\n**** Tag =%@- element name is: %@",xmlTag,elementName);
	if ([elementName isEqualToString:xmlTag]) {
		currentItem = [[[NSMutableDictionary alloc] init] autorelease];
	} else if ([self containsAttribute:elementName]){
        NSString *aTag = [self getTagForAttribute:elementName];
        [currentItem setObject:[attributeDict valueForKey:aTag] forKey:elementName];
    }else if(elementName) {
		self.currentItemValue = [NSMutableString string];
	} else {
		self.currentItemValue = nil;
	}
}
                
- (BOOL)containsAttribute:(NSString *)aTag {
    //If exist an Attribute on this Tag
    if ([attributesDict objectForKey:aTag]) {
        return TRUE;
    }
    else return FALSE;
}

- (NSString *)getTagForAttribute:(NSString *)anAttribute {
    return [attributesDict objectForKey:anAttribute];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(nil != self.currentItemValue){
		[self.currentItemValue appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if(nil != qName){
		elementName = qName;
	}
    if([elementName isEqualToString:xmlTag]){
		[ItemsArray addObject:currentItem];
	}else if ([self containsAttribute:elementName]){
        //Do nothing, we have added before because elementName contains an Attribute
	}
    else {
        [currentItem setObject:currentItemValue forKey:elementName];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	if(parseError.code != NSXMLParserDelegateAbortedParseError) {
		[(id)[self delegate] performSelectorOnMainThread:@selector(ProcessHasErrors:)
                                              withObject:(NSError *)parseError
                                           waitUntilDone:NO];
	}
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[(id)[self delegate] performSelectorOnMainThread:@selector(ProcessCompleted:)
                                          withObject:(NSMutableArray *)ItemsArray
                                       waitUntilDone:NO];
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
