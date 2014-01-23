//
//  NewRss.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 17/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemProtocol.h"


#pragma mark - constants
#define kNewTitle       @"title"
#define kNewDescription @"description"
#define kNewLink        @"link"
#define kNewTGuid       @"guid"
#define kNewPubDate     @"pubDate"
#define kNewThumb       @"media:thumbnail"
#define KNewUrl         @"url"
#pragma mark -


@interface NewRss : NSObject <ItemProtocol> {
	NSString    *title;
	NSString    *description;
	NSString    *linkUrl;
	NSString    *guidUrl;
	NSString    *pubDate;	
	NSString    *mediaUrl;
	UIImage     *appIcon;
}

@property(nonatomic, retain) NSString   *title;
@property(nonatomic, retain) NSString   *description;
@property(nonatomic, retain) NSString   *linkUrl;
@property(nonatomic, retain) NSString   *guidUrl;
@property(nonatomic, retain) NSString   *pubDate;
@property(nonatomic, retain) NSString   *mediaUrl;
@property (nonatomic, retain) UIImage   *appIcon;

- (id)initWithDictionary:(NSDictionary *)aDict;

@end
