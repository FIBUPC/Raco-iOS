//
//  ICALParser.h
//  iRaco
//
//  Created by Marcel Arbó on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlRequest.h"

@protocol ICALParserDelegate;

@interface ICALParser : NSObject <URLRequestDelegate> {
    id<ICALParserDelegate>  delegate;
    
    UrlRequest              *urlRequest;
}

@property(nonatomic, assign) id<ICALParserDelegate> delegate;

- (id)initWithUrl:(NSString *)_url 
           method:(NSString *)_method 
       parameters:(NSString *)_parameters;

@end

@protocol ICALParserDelegate <NSObject>

- (void)parseDidStartCalendar;
- (void)parseDidEndCalendar;
- (void)parseDidBeginEvent;
- (void)parseDidEndEvent;
- (void)parseDidFoundProperty:(NSDictionary *)propertyDict;
- (void)parseErrorOccurred:(NSError *)parseError;

@end
