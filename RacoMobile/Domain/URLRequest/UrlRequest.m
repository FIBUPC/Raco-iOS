//
//  UrlRequest.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 01/05/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "UrlRequest.h"

@interface UrlRequest ()
- (void)getDataWithUrl:(NSString *)_url parameters:(NSString *)_param;
- (void)postDataWithUrl:(NSString *)_url parameters:(NSString *)_param;
@end

@implementation UrlRequest

@synthesize delegate;

- (id)initWithUrl:(NSString *)_url method:(NSString *)_method parameters:(NSString *)_parameters {
	if(!(self=[super init])){
		return nil;
	}
	if ([_method isEqualToString:@"GET"]) {
        [self getDataWithUrl:_url parameters:_parameters];
    }
    else {
        [self postDataWithUrl:_url parameters:_parameters];
    }
	return self;
}

-(void)dealloc{
    [self setDelegate:nil];
    [super dealloc];
}

#pragma mark - Private Methods

- (void)getDataWithUrl:(NSString *)_url parameters:(NSString *)_params {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
    responseData = [[NSMutableData data] retain];
    NSString *urlRequest = _url;
    //Append parameters string (username=xxxxx&password=xxxxx) to the Basic URL (www.company.com/service?)
    if(_params) urlRequest = [urlRequest stringByAppendingString:_params];
	NSURLRequest *request = [NSURLRequest requestWithURL:
							 [NSURL URLWithString:urlRequest]];
	[NSURLConnection connectionWithRequest:request delegate:self];	
}

- (void)postDataWithUrl:(NSString *)_url parameters:(NSString *)_params {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	responseData = [[NSMutableData data] retain];
	NSURL *urlRequest = [NSURL URLWithString:_url];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlRequest];
	[request setHTTPMethod:@"POST"];
	NSData *requestBody = [_params dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:requestBody];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[(id)[self delegate] performSelectorOnMainThread:@selector(RequestHasErrors:)
										  withObject:(NSError *)error
									   waitUntilDone:NO];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];	
	
    [(id)[self delegate] performSelectorOnMainThread:@selector(RequestCompleted:)
                                          withObject:(NSString *)responseString
                                       waitUntilDone:NO];
    
    [responseString release];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
