//
//  JSONParser.m
//  iRaco
//
//  Created by Marcel Arbó on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSONParser.h"
#import "JSON.h"


@implementation JSONParser

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
    NSDictionary *results = [responseString JSONValue];
	
    [(id)[self delegate] performSelectorOnMainThread:@selector(parseCompleted:)
                                          withObject:(NSDictionary *)results
                                       waitUntilDone:NO];
}

@end
