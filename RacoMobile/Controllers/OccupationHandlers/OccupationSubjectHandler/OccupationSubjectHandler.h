//
//  OccupationSubjectHandler.h
//  iRaco
//
//  Created by Marcel Arbó on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import "IcalProvider.h"
#import "Place.h"

@protocol OccupationSubjectHandlerDelegate;

@interface OccupationSubjectHandler : NSObject <IcalProviderDelegate> {

	id<OccupationSubjectHandlerDelegate>    delegate;
    IcalProvider                            *icalProvider;
    
    NSMutableArray                          *placesSubject;
    NSDictionary                            *placesSubjectDict;
}

@property(nonatomic, assign) id<OccupationSubjectHandlerDelegate>   delegate;

@property (nonatomic, retain) NSMutableArray                        *placesSubject;
@property (nonatomic, retain) NSDictionary                          *placesSubjectDict;

+ (OccupationSubjectHandler *)sharedHandler;

- (void)startProcess;
- (void)savePlacesSubjectDict:(NSDictionary *)_placesSubjectDict;
- (void)saveplacesSubjectObjects:(NSDictionary *)_placesSubjectArray;
- (NSString *)getActualSubjectFromPlace:(Place *)aPlace;

@end

@protocol OccupationSubjectHandlerDelegate <NSObject>

- (void)OccupationSubjectProcessCompleted:(NSMutableArray *)placesSubjectArray;
- (void)OccupationSubjectProcessHasErrors:(NSError *)error;

@end
