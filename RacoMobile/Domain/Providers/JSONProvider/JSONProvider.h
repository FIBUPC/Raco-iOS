//
//  JSONProvider.h
//  iRaco
//
//  Created by Marcel Arbó on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParser.h"

@protocol JSONProviderDelegate;

@interface JSONProvider : NSObject <JSONParserDelegate> {
    id<JSONProviderDelegate>    delegate;
    
    JSONParser                  *jsonParser;
}

@property(nonatomic, assign) id<JSONProviderDelegate> delegate;

- (id)initWithUrl:(NSString *)_url 
        method:(NSString *)_method 
    parameters:(NSString *)_parameters;

@end

@protocol JSONProviderDelegate <NSObject>

- (void)ProcessCompleted:(NSDictionary *)results;
- (void)ProcessHasErrors:(NSError *)error;

@end
