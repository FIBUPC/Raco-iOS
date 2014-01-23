//
//  AgendaIcsHandler.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 22/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcalProvider.h"

@protocol AgendaIcsHandlerDelegate;

@interface AgendaIcsHandler : NSObject <IcalProviderDelegate> {
    
	id<AgendaIcsHandlerDelegate>    delegate;
    IcalProvider                    *icalProvider;
    
    NSMutableArray                  *agenda;
    NSDictionary                    *agendaDict;
}

@property(nonatomic, assign) id<AgendaIcsHandlerDelegate>   delegate;

@property (nonatomic, retain) NSMutableArray                *agenda;
@property (nonatomic, retain) NSDictionary                  *agendaDict;

+ (AgendaIcsHandler *)sharedHandler;

- (void)startProcess;
- (void)saveAgendaDict:(NSDictionary *)_agendaDict;
- (void)saveAgendaObjects:(NSDictionary *)_agendaArray;
- (void)sortAgendaEvents;
- (void)deleteData;

@end

@protocol AgendaIcsHandlerDelegate <NSObject>

-(void)agendaProcessCompleted:(NSMutableArray *)agendaEvents;
-(void)agendaProcessHasErrors:(NSError *)error;

@end
