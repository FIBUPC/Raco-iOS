//
//  FibSubjectsHandler.h
//  iRaco
//
//  Created by Marcel Arbó on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONProvider.h"

@protocol FibSubjectsHandlerDelegate;

@interface FibSubjectsHandler : NSObject <JSONProviderDelegate> {

	id<FibSubjectsHandlerDelegate>  delegate;    
    JSONProvider                    *jsonProvider;
    
    NSMutableArray                  *fibSubjects;
    NSDictionary                    *fibSubjectsDict;
}

@property(nonatomic, assign) id<FibSubjectsHandlerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray                *fibSubjects;
@property (nonatomic, retain) NSDictionary                  *fibSubjectsDict;

+ (FibSubjectsHandler *)sharedHandler;

- (void)startProcess;
- (void)saveFibSubjectsDict:(NSDictionary *)_fibSubjectsDict;
- (void)saveFibSubjectsObjects:(NSDictionary *)_fibSubjectsArray;
- (void)sortFibSubjects;

@end

@protocol FibSubjectsHandlerDelegate <NSObject>

- (void)FibSubjectsProcessCompleted:(NSMutableArray *)fibSubjects;
- (void)FibSubjectsProcessHasErrors:(NSError *)error;

@end
