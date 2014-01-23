//
//  ScheduleHandler.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 23/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcalProvider.h"
#import "IcalEvent.h"

@protocol ScheduleHandlerDelegate;

@interface ScheduleHandler : NSObject <IcalProviderDelegate> {
    
	id<ScheduleHandlerDelegate> delegate;
    IcalProvider                *icalProvider;
    
    NSMutableArray              *scheduleEventsWithDate;
    
    NSMutableDictionary         *schedule;
    NSDictionary                *scheduleDict;
}

@property(nonatomic, assign) id<ScheduleHandlerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray             *scheduleEventsWithDate;

@property (nonatomic, retain) NSMutableDictionary        *schedule;
@property (nonatomic, retain) NSDictionary               *scheduleDict;

+ (ScheduleHandler *)sharedHandler;

- (void)startProcess;
- (void)saveScheduleDict:(NSDictionary *)_scheduleDict;
- (void)saveScheduleObjects:(NSDictionary *)_scheduleArray;
- (void)saveEventsFromScheduleWithDate:(NSDate *)_date;
- (NSMutableArray *)getEventWithInterval:hourTime date:(NSDate *)selectedDate fromEvents:(NSArray *)events;
- (NSArray *)getEventsWithDate:(NSDate *)selectedDate;
- (void)deleteData;

@end

@protocol ScheduleHandlerDelegate <NSObject>

-(void)scheduleProcessCompleted:(NSMutableArray *)scheduleEvents;
-(void)scheduleProcessHasErrors:(NSError *)error;

@end
