//
//  Subject.m
//  iRaco
//
//  Created by Marcel Arbó on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Subject.h"


@implementation Subject

@synthesize idAssig, codi_upc, nom, credits, professors, descripcio, bibliografia, bibliografiaComplementaria;

- (id)initWithDictionary:(NSDictionary *)aDict {
    
    // Return nil if aDict is nil
    if (!aDict) return nil;
    
    if ( (self = [super init]) ) {
        NSString *newIdAssig = [aDict objectForKey:kSubjectIdAssig];
        NSString *newCodi = [aDict objectForKey:kSubjectCodiUPC];
        NSString *newNom = [aDict objectForKey:kSubjectNom];
        NSString *newCredits = [aDict objectForKey:kSubjectCredits];
        NSDictionary *newProfessors = [aDict objectForKey:kSubjectProfessors];
        NSDictionary *newDescripcio = [aDict objectForKey:kSubjectDescripcio];
        NSDictionary *newBibliografia = [aDict objectForKey:kSubjectBibliografia];
        NSDictionary *newBibliografiaComplementaria = [aDict objectForKey:kSubjectBibliografiaComplementaria];
        
        //Check if nom is not NSNull Class
        if ([newNom isKindOfClass:(id)[NSNull class]]) {
            newNom = @"";
        }
        
        if (newIdAssig) [self setIdAssig:newIdAssig];
        if (newCodi) [self setCodi_upc:newCodi];
        if (newNom) [self setNom:newNom];
        if (newCredits) [self setCredits:newCredits];
        if (newProfessors) [self setProfessors:newProfessors];
        if (newDescripcio) [self setDescripcio:newDescripcio];
        if (newBibliografia) [self setBibliografia:newBibliografia];
        if (newBibliografiaComplementaria) [self setBibliografiaComplementaria:newBibliografiaComplementaria];
    }
    
    return self;
}

- (void)dealloc {
    [self setIdAssig:nil];
    [self setCodi_upc:nil];
    [self setNom:nil];
    [self setCredits:nil];
    [self setProfessors:nil];
    [self setDescripcio:nil];
    [self setBibliografia:nil];
    [super dealloc];
}

@end