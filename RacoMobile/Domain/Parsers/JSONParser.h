//
//  JSONParser.h
//  iRaco
//
//  Created by Marcel Arbó on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlRequest.h"

@protocol JSONParserDelegate;

@interface JSONParser : NSObject <URLRequestDelegate> {
    id<JSONParserDelegate>  delegate;
    
    UrlRequest              *urlRequest;
}

@property(nonatomic, assign) id<JSONParserDelegate> delegate;

- (id)initWithUrl:(NSString *)_url 
           method:(NSString *)_method 
       parameters:(NSString *)_parameters;

@end

@protocol JSONParserDelegate <NSObject>

- (void)parseCompleted:(NSDictionary *)results;
- (void)parseErrorOccurred:(NSError *)parseError;

@end