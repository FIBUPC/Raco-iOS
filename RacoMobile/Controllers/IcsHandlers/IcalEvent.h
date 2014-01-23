//
//  AgendaEvent.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 23/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IcalEvent : NSObject {
    NSString *dateStamp;
    NSString *dateStart;
    NSString *dateEnd;
    NSString *summary;
    NSString *uid;
    NSString *startHour;
    NSString *endHour;
    NSString *location;
    NSDate   *compareDate;

}

@property (nonatomic, retain) NSString  *dateStamp;
@property (nonatomic, retain) NSString  *dateStart;
@property (nonatomic, retain) NSString  *dateEnd;
@property (nonatomic, retain) NSString  *summary;
@property (nonatomic, retain) NSString  *uid;
@property (nonatomic, retain) NSString  *startHour;
@property (nonatomic, retain) NSString  *endHour;
@property (nonatomic, retain) NSString  *location;
@property (nonatomic, retain) NSDate    *compareDate;


- (id)initWithDictionary:(NSDictionary *)aDict;

@end
