//
//  NewsHandler.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 17/04/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLProvider.h"

@protocol NewsHandlerDelegate;

@interface NewsHandler : NSObject <XMLProviderDelegate>{

	id<NewsHandlerDelegate> delegate;
    XMLProvider             *xmlProvider;
    
    NSMutableArray          *news;
    NSDictionary            *newsDict;
}

@property(nonatomic, assign) id<NewsHandlerDelegate>    delegate;

@property (nonatomic, retain) NSMutableArray            *news;
@property (nonatomic, retain) NSDictionary              *newsDict;

+ (NewsHandler *)sharedHandler;

- (void)startProcess;
- (void)saveNewsDict:(NSDictionary *)_newsDict;
- (void)saveNewsObjects:(NSDictionary *)_newsArray;
- (NSMutableArray *)retrieveNewsArrayWithNumber:(int)numMax;

@end

@protocol NewsHandlerDelegate <NSObject>

-(void)newRssProcessCompleted:(NSMutableArray *)news;
-(void)newRssProcessHasErrors:(NSError *)error;

@end
