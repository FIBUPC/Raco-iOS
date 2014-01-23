//
//  IcalProvider.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 23/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICALParser.h"


@protocol IcalProviderDelegate;

@interface IcalProvider : NSObject <ICALParserDelegate>{
    NSMutableDictionary         *currentEvent;
	NSString                    *currentEventValue;
    NSMutableArray              *icalEvents;
    
    id<IcalProviderDelegate>    delegate;
    
    ICALParser                  *icalParser;
}

@property (nonatomic, assign) id<IcalProviderDelegate>  delegate;

@property (nonatomic, retain) NSMutableDictionary       *currentEvent;
@property (nonatomic, retain) NSString                  *currentEventValue;
@property (nonatomic, retain) NSMutableArray            *icalEvents;

- (id)initWithUrl:(NSString *)_url 
           method:(NSString *)_method 
       parameters:(NSString *)_parameters;

@end

@protocol IcalProviderDelegate <NSObject>

- (void)ProcessCompleted:(NSDictionary *)results;
- (void)ProcessHasErrors:(NSError *)error;

@end
