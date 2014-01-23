//
//  JSONProvider.m
//  iRaco
//
//  Created by Marcel Arbó on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSONProvider.h"


@implementation JSONProvider

@synthesize delegate;

- (id)initWithUrl:(NSString *)_url method:(NSString *)_method parameters:(NSString *)_parameters {
	if(!(self=[super init])){
		return nil;
	}
    jsonParser = [[JSONParser alloc] initWithUrl:_url method:_method parameters:_parameters];
    jsonParser.delegate = self;
    
	return self;
}

-(void)dealloc{
    [jsonParser release];
    [self setDelegate:nil];
    [super dealloc];
}

#pragma mark - JSONParser Protocol methods

- (void)parseCompleted:(NSDictionary *)results {
    [(id)[self delegate] performSelectorOnMainThread:@selector(ProcessCompleted:)
                                          withObject:(NSDictionary *)results
                                       waitUntilDone:NO];
}

- (void)parseErrorOccurred:(NSError *)parseError {
    [(id)[self delegate] performSelectorOnMainThread:@selector(ProcessHasErrors:)
										  withObject:(NSError *)parseError
									   waitUntilDone:NO];
}

@end
