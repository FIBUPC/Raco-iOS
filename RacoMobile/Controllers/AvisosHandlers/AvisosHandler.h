//
//  AvisosHandler.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 17/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLProvider.h"

@protocol AvisosHandlerDelegate;

@interface AvisosHandler : NSObject <XMLProviderDelegate>{

	id<AvisosHandlerDelegate>   delegate;
    XMLProvider                 *xmlProvider;
    
    NSMutableArray              *avisos;
    NSDictionary                *avisosDict;
}

@property(nonatomic, assign) id<AvisosHandlerDelegate>  delegate;

@property (nonatomic, retain) NSMutableArray            *avisos;
@property (nonatomic, retain) NSDictionary              *avisosDict;

+ (AvisosHandler *)sharedHandler;

- (void)startProcess;
- (void)saveAvisosDict:(NSDictionary *)_avisosDict;
- (void)saveAvisosObjects:(NSDictionary *)_avisosArray;
- (NSMutableArray *)retrieveAvisosArrayWithNumber:(int)numMax;
- (NSMutableArray *)retrieveAvisosArrayWithTag:(NSString *)avisTag;


@end

@protocol AvisosHandlerDelegate <NSObject>

-(void)avisosProcessCompleted:(NSMutableArray *)news;
-(void)avisosProcessHasErrors:(NSError *)error;

@end