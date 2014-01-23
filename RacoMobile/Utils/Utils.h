//
//  Utils.h
//  iRaco
//
//  Created by Marcel Arbó on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utils : NSObject {
    
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

+ (NSString *)convertDateFormat:(NSString *)oldStringDate;

+ (NSString *)stringFromDate:(NSDate *)_date;

+ (NSString *)stringWithHourFromDate:(NSDate *)_date;

+ (NSDate *)getDateFromString:(NSString *)stringDate;

+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

+ (BOOL)connected ;

@end
