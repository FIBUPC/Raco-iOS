//
//  ItemProtocol.h
//  iRaco
//
//  Created by Marcel Arbó on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ItemProtocol <NSObject>

- (NSString *)commonItemTitle;
- (NSString *)commonItemDescription;
- (NSString *)commonItemDate;
- (NSString *)commonItemImageUrl;
- (NSString *)commonItemIcon;
- (UIColor *)commonItemBackground;

@end
