//
//  Place.m
//  iRaco
//
//  Created by Marcel Arbó on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Place.h"
#import "IcalEvent.h"
#import "Utils.h"

@implementation Place

@synthesize name, places, subject;

- (id)initWithDictionary:(NSDictionary *)aDict {
    
    // Return nil if aDict is nil
    if (!aDict) return nil;
    
    if ( (self = [super init]) ) {
        NSString *newName = [aDict objectForKey:kPlaceNom];
        NSString *newPlaces = [aDict objectForKey:kPlacePlaces];
        
        if (newName) [self setName:newName];
        if (newPlaces) [self setPlaces:newPlaces];  
        [self setSubject:nil];
    } 
    
    return self;
}

- (void)dealloc {
    [self setName:nil];
    [self setPlaces:nil];
    [self setSubject:nil];
    [super dealloc];
}

@end
