//
//  UrlRequest.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 01/05/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLRequestDelegate;

@interface UrlRequest : NSObject {
    NSMutableData           *responseData;
    id<URLRequestDelegate>  delegate;
}

@property(nonatomic, assign) id<URLRequestDelegate> delegate;

- (id)initWithUrl:(NSString *)_url method:(NSString *)_method parameters:(NSString *)_parameters;

@end

@protocol URLRequestDelegate <NSObject>

- (void)RequestCompleted:(NSString *)responseString;
- (void)RequestHasErrors:(NSError *)error;

@end
