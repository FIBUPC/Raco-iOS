//
//  OccupationHandler.h
//  iRaco
//
//  Created by Marcel Arbó on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONProvider.h"

@protocol OccupationHandlerDelegate;

@interface OccupationHandler : NSObject <JSONProviderDelegate> {
    
	id<OccupationHandlerDelegate>   delegate;
    JSONProvider                    *jsonProvider;
    
    NSMutableArray                  *freePlacesArray;
    NSDictionary                    *freePlacesArrayDict;
}

@property(nonatomic, assign) id<OccupationHandlerDelegate>  delegate;

@property (nonatomic, retain) NSMutableArray                *freePlacesArray;
@property (nonatomic, retain) NSDictionary                  *freePlacesArrayDict;

+ (OccupationHandler *)sharedHandler;

- (void)startProcess;
- (void)saveFreePlacesDict:(NSDictionary *)_freePlacesDict;
- (void)saveFreePlacesObjects:(NSDictionary *)_freePlacesArray;
- (NSMutableArray *)retrieveOccupationArrayWithTag:(NSString *)placeTag;

@end

@protocol OccupationHandlerDelegate <NSObject>

- (void)OccupationProcessCompleted:(NSMutableArray *)freePlacesArray;
- (void)OccupationProcessHasErrors:(NSError *)error;

@end
