//
//  Aula.h
//  Moodbile
//
//  Created by LCFIB on 09/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Aula : NSObject {
	NSString *name;
	NSString *url;
    NSString *tag;
}
@property (nonatomic,copy) NSString     *name;
@property (nonatomic,copy) NSString     *url;
@property (nonatomic, copy) NSString    *tag;

-(id)initWithName: (NSString*)full_name url:(NSString*)direction tag:(NSString *)aTag;

@end
