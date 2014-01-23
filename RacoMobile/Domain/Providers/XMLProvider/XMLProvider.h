//
//  XMLProvider.h
//  iRaco
//
//  Created by LCFIB on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMLProviderDelegate;

@interface XMLProvider : NSObject <NSXMLParserDelegate>{
    NSMutableDictionary     *currentItem;
	NSMutableString         *currentItemValue;
	NSMutableArray          *ItemsArray;
	NSOperationQueue        *retrieverQueue;
    
    NSString                *xmlUrl;
    NSString                *xmlTag;
    NSDictionary            *attributesDict;
    
    id<XMLProviderDelegate> delegate;
}

@property (nonatomic, retain) NSMutableDictionary       *currentItem;
@property (nonatomic, retain) NSMutableString           *currentItemValue;
@property (nonatomic, retain) NSMutableArray            *ItemsArray;

@property (nonatomic, retain) NSString                  *xmlUrl;
@property (nonatomic, retain) NSString                  *xmlTag;
@property (nonatomic, retain) NSDictionary              *attributesDict;

@property(nonatomic, retain) NSOperationQueue           *retrieverQueue;

@property(nonatomic, assign) id<XMLProviderDelegate>    delegate;

- (id)initWithUrl:(NSString *)_url xmlTag:(NSString *)_xmlTag attributesDict:(NSDictionary *)attributesDict;

@end

@protocol XMLProviderDelegate <NSObject>

- (void)ProcessCompleted:(NSDictionary *)results;
- (void)ProcessHasErrors:(NSError *)error;

@end
