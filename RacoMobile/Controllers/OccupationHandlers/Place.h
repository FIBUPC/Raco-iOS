//
//  Place.h
//  iRaco
//
//  Created by Marcel Arbó on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - constants
#define kPlaceNom       @"nom"
#define kPlacePlaces    @"places"
#pragma mark -


@interface Place : NSObject {
    NSString    *name;
    NSString    *places;
    NSString    *subject;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *places;
@property (nonatomic, retain) NSString *subject;

- (id)initWithDictionary:(NSDictionary *)aDict;


@end
