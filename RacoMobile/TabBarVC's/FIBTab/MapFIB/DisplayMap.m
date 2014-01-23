//
//  DisplayMap.m
//  iRaco
//
//  Created by Marcel Arbó on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DisplayMap.h"

@implementation DisplayMap

@synthesize coordinate,title,subtitle;

-(void)dealloc{
    [self setTitle:nil];
    [self setSubtitle:nil];
    [super dealloc];
}

@end
