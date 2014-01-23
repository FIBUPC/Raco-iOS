//
//  Aula.m
//  Moodbile
//
//  Created by LCFIB on 09/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Aula.h"


@implementation Aula

@synthesize name, url, tag;

-(id)initWithName: (NSString*)full_name url:(NSString*)direction tag:(NSString *)aTag{
	[self setName:full_name];
	[self setUrl:direction];
    [self setTag:aTag];
	return self;
}

@end
