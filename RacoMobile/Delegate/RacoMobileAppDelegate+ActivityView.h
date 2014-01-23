//
//  RacoMobileAppDelegate+ActivityView.h
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 03/08/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RacoMobileAppDelegate.h"


@interface RacoMobileAppDelegate (ActivityView)

//LoadingView methods
- (void)hideActivityViewer;
- (void)showActivityViewer:(NSString*)aTexto;
- (void)showActivityViewer;

@end
