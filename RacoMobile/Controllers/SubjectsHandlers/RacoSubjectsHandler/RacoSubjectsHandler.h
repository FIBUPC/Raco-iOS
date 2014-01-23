//
//  RacoSubjectsHandler.h
//  iRaco
//
//  Created by Marcel Arbó on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONProvider.h"

@protocol RacoSubjectsHandlerDelegate;

@interface RacoSubjectsHandler : NSObject <JSONProviderDelegate> {
    
	id<RacoSubjectsHandlerDelegate> delegate;
    JSONProvider                    *jsonProvider;
    
    NSMutableArray                  *racoSubjects;
    NSDictionary                    *racoSubjectsDict;
}

@property(nonatomic, assign) id<RacoSubjectsHandlerDelegate>    delegate;

@property (nonatomic, retain) NSMutableArray                    *racoSubjects;
@property (nonatomic, retain) NSDictionary                      *racoSubjectsDict;

+ (RacoSubjectsHandler *)sharedHandler;

- (void)startProcess;
- (void)saveRacoSubjectsDict:(NSDictionary *)_racoSubjectsDict;
- (void)saveRacoSubjectsObjects:(NSDictionary *)_racoSubjectsArray;

@end

@protocol RacoSubjectsHandlerDelegate <NSObject>

- (void)RacoSubjectsProcessCompleted:(NSMutableArray *)racoSubjects;
- (void)RacoSubjectsProcessHasErrors:(NSError *)error;

@end