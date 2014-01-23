//
//  Avis.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 17/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemProtocol.h"


#pragma mark - constants
#define kAvisTitle          @"title"
#define kAvisLink           @"link"
#define kAvisDescription    @"description"
#define kAvisPubDate        @"pubDate"
#define kAvisCategory       @"category"
#pragma mark -


@interface Avis : NSObject <ItemProtocol> {
	NSString    *title;
	NSString    *link;
	NSString    *description;
    NSString    *pubDate;
	NSString    *category;
}

@property (nonatomic, retain) NSString   *title;
@property (nonatomic, retain) NSString   *link;
@property (nonatomic, retain) NSString   *description;
@property (nonatomic, retain) NSString   *pubDate;
@property (nonatomic, retain) NSString   *category;

- (id)initWithDictionary:(NSDictionary *)aDict;

@end