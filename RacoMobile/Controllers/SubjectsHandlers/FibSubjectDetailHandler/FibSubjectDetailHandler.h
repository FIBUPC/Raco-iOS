//
//  FibSubjectDetailHandler.h
//  iRaco
//
//  Created by Marcel Arbó on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subject.h"


#import <Foundation/Foundation.h>
#import "JSONProvider.h"

@protocol FibSubjectDetailHandlerDelegate;

@interface FibSubjectDetailHandler : NSObject <JSONProviderDelegate> {

	id<FibSubjectDetailHandlerDelegate> delegate;    
    JSONProvider                        *jsonProvider;
    
    NSMutableArray                      *fibSubjectsDetail;
    NSMutableArray                      *tempFibSubjectsDetailDict;
    NSArray                             *fibSubjectsDetailDict;
    
    int                                 maxSubjects;
}

@property(nonatomic, assign) id<FibSubjectDetailHandlerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray *fibSubjectsDetail;
@property (nonatomic, retain) NSMutableArray *tempFibSubjectsDetailDict;
@property (nonatomic, retain) NSArray *fibSubjectsDetailDict;

+ (FibSubjectDetailHandler *)sharedHandler;

- (void)startProcessWithTag:(NSString *)aTag maxSubjects:(int)_maxSubjects;
- (void)saveFibSubjectDetailDict:(NSArray *)_fibSubjectDetailDict;
- (void)saveFibSubjectDetailObject:(NSArray *)_fibSubjectDetail;
- (Subject *)retrieveFibSubjectDetailWithTag:(NSString *)aTag;

@end

@protocol FibSubjectDetailHandlerDelegate <NSObject>

- (void)FibSubjectDetailProcessCompleted:(Subject *)fibSubjectDetail;
- (void)FibSubjectDetailProcessHasErrors:(NSError *)error;

@end
